# ============================================================
# CORE - Corporate Entity Resolution Engine
#
# Module : 18_run_core.R
# Purpose: Run the full CORE pipeline and return intermediate outputs
# Version: 1.1.0
# ============================================================

core_run <- function(employer_path,
                     reference_path,
                     employer_company_column = "company",
                     reference_company_column = "company_name",
                     employer_columns = NULL,
                     output_directory = "output",
                     output_file_name = "core_results",
                     dictionary_scope = "project",
                     alias_dictionary_name = NULL,
                     learning_dictionary_path = "inst/dictionaries/project/custom/learning_dictionary.csv",
                     use_learning_layer = FALSE,
                     learning_mode = "none",
                     minimum_consensus = 3,
                     learning_bonus = 10,
                     learning_penalty = -10,
                     min_shared_tokens = 1,
                     auto_accept_threshold = 95,
                     review_threshold = 80,
                     max_candidates_per_employer = 5,
                     export_formats = c("csv", "dta"),
                     export_results = TRUE) {
  
  learning_mode <- match.arg(
    learning_mode,
    choices = c("none", "passive", "consensus", "soft")
  )
  
  if (!isTRUE(use_learning_layer)) {
    learning_mode <- "none"
  }
  
  if (isTRUE(use_learning_layer)) {
    warning(
      "The Learning Layer uses previously reviewed human decisions as methodological evidence. ",
      "These decisions may contain reviewer errors, project-specific assumptions, or outdated interpretations. ",
      "CORE does not treat learned decisions as ground truth. ",
      "Learning evidence is advisory and does not automatically accept or reject candidate correspondences."
    )
  }
  
  if (is.null(employer_columns)) {
    warning(
      "employer_columns = NULL will read the full employer dataset. ",
      "For large datasets, provide selected columns to reduce memory use."
    )
  }
  
  core_tokenize_column <- function(data,
                                   name_column = "company_core",
                                   tokens_column = "company_tokens",
                                   token_count_column = "token_count") {
    
    data[, (tokens_column) := stringi::stri_split_regex(
      get(name_column),
      "\\s+",
      simplify = FALSE
    )]
    
    data[, (tokens_column) := lapply(
      get(tokens_column),
      function(x) {
        x <- x[!is.na(x) & x != ""]
        paste(unique(x), collapse = " ")
      }
    )]
    
    data[, (tokens_column) := unlist(get(tokens_column))]
    
    data[, (token_count_column) := data.table::fifelse(
      get(tokens_column) == "",
      0L,
      lengths(strsplit(get(tokens_column), "\\s+"))
    )]
    
    data[]
  }
  
  core_apply_learning_evidence_safe <- function(review_queue,
                                                learning_dictionary_path,
                                                learning_mode = "none",
                                                minimum_consensus = 3,
                                                learning_bonus = 10,
                                                learning_penalty = -10) {
    
    if (!data.table::is.data.table(review_queue)) {
      review_queue <- data.table::as.data.table(review_queue)
    }
    
    review_queue[, learning_mode := learning_mode]
    review_queue[, learned_evidence_available := FALSE]
    review_queue[, learned_accept_count := 0L]
    review_queue[, learned_reject_count := 0L]
    review_queue[, learned_skip_count := 0L]
    review_queue[, learned_total_count := 0L]
    review_queue[, learned_consensus_decision := NA_character_]
    review_queue[, learned_consensus_count := 0L]
    review_queue[, learned_consensus_eligible := FALSE]
    review_queue[, learning_adjustment := 0]
    review_queue[, learning_adjusted_score := confidence_score]
    review_queue[, learning_priority_signal := NA_character_]
    
    if (learning_mode == "none") {
      return(review_queue[])
    }
    
    if (!file.exists(learning_dictionary_path)) {
      return(review_queue[])
    }
    
    learning_dictionary <- data.table::fread(
      learning_dictionary_path,
      na.strings = c("", "NA")
    )
    
    required_columns <- c(
      "employer_name",
      "reference_name",
      "user_decision"
    )
    
    missing_columns <- setdiff(required_columns, names(learning_dictionary))
    
    if (length(missing_columns) > 0) {
      warning(
        "Learning dictionary found but required columns are missing: ",
        paste(missing_columns, collapse = ", "),
        ". Learning evidence was not applied."
      )
      return(review_queue[])
    }
    
    learning_dictionary <- learning_dictionary[
      !is.na(employer_name) &
        employer_name != "" &
        !is.na(reference_name) &
        reference_name != "" &
        !is.na(user_decision) &
        user_decision %in% c("accept", "reject", "skip")
    ]
    
    if (nrow(learning_dictionary) == 0) {
      return(review_queue[])
    }
    
    learning_summary <- learning_dictionary[
      ,
      .(
        learned_accept_count = sum(user_decision == "accept"),
        learned_reject_count = sum(user_decision == "reject"),
        learned_skip_count = sum(user_decision == "skip"),
        learned_total_count = .N
      ),
      by = .(
        employer_name,
        reference_name
      )
    ]
    
    learning_summary[
      ,
      learned_consensus_decision := data.table::fifelse(
        learned_accept_count >= minimum_consensus &
          learned_accept_count > learned_reject_count,
        "accept",
        data.table::fifelse(
          learned_reject_count >= minimum_consensus &
            learned_reject_count > learned_accept_count,
          "reject",
          data.table::fifelse(
            learned_skip_count >= minimum_consensus &
              learned_skip_count > learned_accept_count &
              learned_skip_count > learned_reject_count,
            "skip",
            NA_character_
          )
        )
      )
    ]
    
    learning_summary[
      ,
      learned_consensus_count := data.table::fifelse(
        learned_consensus_decision == "accept",
        learned_accept_count,
        data.table::fifelse(
          learned_consensus_decision == "reject",
          learned_reject_count,
          data.table::fifelse(
            learned_consensus_decision == "skip",
            learned_skip_count,
            0L
          )
        )
      )
    ]
    
    learning_summary[
      ,
      learned_consensus_eligible := !is.na(learned_consensus_decision)
    ]
    
    result <- merge(
      review_queue,
      learning_summary,
      by = c("employer_name", "reference_name"),
      all.x = TRUE,
      sort = FALSE,
      suffixes = c("", "_dict")
    )
    
    for (col in c(
      "learned_accept_count",
      "learned_reject_count",
      "learned_skip_count",
      "learned_total_count",
      "learned_consensus_count"
    )) {
      dict_col <- paste0(col, "_dict")
      if (dict_col %in% names(result)) {
        result[!is.na(get(dict_col)), (col) := get(dict_col)]
        result[, (dict_col) := NULL]
      }
      result[is.na(get(col)), (col) := 0L]
    }
    
    for (col in c(
      "learned_consensus_decision",
      "learned_consensus_eligible"
    )) {
      dict_col <- paste0(col, "_dict")
      if (dict_col %in% names(result)) {
        result[!is.na(get(dict_col)), (col) := get(dict_col)]
        result[, (dict_col) := NULL]
      }
    }
    
    result[
      learned_total_count > 0,
      learned_evidence_available := TRUE
    ]
    
    if (learning_mode == "passive") {
      return(result[])
    }
    
    if (learning_mode == "consensus") {
      result[
        learned_consensus_eligible == TRUE,
        learning_priority_signal := "consensus_available"
      ]
      
      return(result[])
    }
    
    if (learning_mode == "soft") {
      
      result[
        learned_consensus_decision == "accept",
        learning_adjustment := learning_bonus
      ]
      
      result[
        learned_consensus_decision == "reject",
        learning_adjustment := learning_penalty
      ]
      
      result[
        learned_consensus_decision == "skip",
        learning_adjustment := 0
      ]
      
      result[
        ,
        learning_adjusted_score := pmax(
          0,
          pmin(100, confidence_score + learning_adjustment)
        )
      ]
      
      result[
        learned_consensus_decision == "accept",
        learning_priority_signal := "soft_accept_evidence"
      ]
      
      result[
        learned_consensus_decision == "reject",
        learning_priority_signal := "soft_reject_evidence"
      ]
      
      result[
        learned_consensus_decision == "skip",
        learning_priority_signal := "soft_skip_evidence"
      ]
      
      return(result[])
    }
    
    result[]
  }
  
  employer <- haven::read_dta(employer_path)
  employer <- data.table::as.data.table(employer)
  
  if (!is.null(employer_columns)) {
    employer <- employer[, ..employer_columns]
  }
  
  reference <- haven::read_dta(reference_path)
  reference <- data.table::as.data.table(reference)
  
  if (
    !reference_company_column %in% names(reference) &&
    reference_company_column == "company name" &&
    "company_name" %in% names(reference)
  ) {
    reference_company_column <- "company_name"
  }
  
  if (!employer_company_column %in% names(employer)) {
    stop("Employer company column not found: ", employer_company_column)
  }
  
  if (!reference_company_column %in% names(reference)) {
    stop("Reference company column not found: ", reference_company_column)
  }
  
  employer <- clean_company_names(
    employer,
    company_column = employer_company_column
  )
  
  reference <- clean_company_names(
    reference,
    company_column = reference_company_column
  )
  
  employer <- tokenize_company_names(employer)
  reference <- tokenize_company_names(reference)
  
  employer <- core_apply_suffix_engine(
    employer,
    name_column = "company_clean",
    output_column = "company_core",
    dictionary_scope = dictionary_scope
  )
  
  reference <- core_apply_suffix_engine(
    reference,
    name_column = "company_clean",
    output_column = "company_core",
    dictionary_scope = dictionary_scope
  )
  
  employer <- core_tokenize_column(employer)
  reference <- core_tokenize_column(reference)
  
  employer <- core_match_exact(
    reference_data = reference,
    employer_data = employer,
    reference_column = "company_core",
    employer_column = "company_core"
  )
  
  employer <- core_apply_alias_engine(
    employer,
    name_column = "company_core",
    dictionary_scope = dictionary_scope,
    dictionary_name = alias_dictionary_name
  )
  
  candidates <- core_generate_candidates(
    employer_data = employer,
    reference_data = reference,
    employer_name_column = "company_core",
    reference_name_column = "company_core",
    employer_tokens_column = "company_tokens",
    reference_tokens_column = "company_tokens",
    min_shared_tokens = min_shared_tokens
  )
  
  scored_candidates <- core_score_candidates(
    candidates = candidates,
    employer_data = employer,
    reference_data = reference,
    employer_name_column = "company_core",
    reference_name_column = "company_core",
    employer_tokens_column = "company_tokens",
    reference_tokens_column = "company_tokens"
  )
  
  review_queue <- core_create_review_queue(
    scored_candidates = scored_candidates,
    auto_accept_threshold = auto_accept_threshold,
    review_threshold = review_threshold,
    max_candidates_per_employer = max_candidates_per_employer
  )
  
  review_queue <- core_apply_learning_evidence_safe(
    review_queue = review_queue,
    learning_dictionary_path = learning_dictionary_path,
    learning_mode = learning_mode,
    minimum_consensus = minimum_consensus,
    learning_bonus = learning_bonus,
    learning_penalty = learning_penalty
  )
  
  export_files <- NULL
  
  if (isTRUE(export_results)) {
    export_files <- core_export_results(
      data = review_queue,
      output_directory = output_directory,
      file_name = output_file_name,
      formats = export_formats,
      include_metadata = TRUE
    )
  }
  
  results <- list(
    employer = employer,
    reference = reference,
    candidates = candidates,
    scored_candidates = scored_candidates,
    review_queue = review_queue,
    export_files = export_files,
    settings = list(
      employer_path = employer_path,
      reference_path = reference_path,
      employer_company_column = employer_company_column,
      reference_company_column = reference_company_column,
      employer_columns = employer_columns,
      output_directory = output_directory,
      output_file_name = output_file_name,
      dictionary_scope = dictionary_scope,
      alias_dictionary_name = alias_dictionary_name,
      learning_dictionary_path = learning_dictionary_path,
      use_learning_layer = use_learning_layer,
      learning_mode = learning_mode,
      minimum_consensus = minimum_consensus,
      learning_bonus = learning_bonus,
      learning_penalty = learning_penalty,
      min_shared_tokens = min_shared_tokens,
      auto_accept_threshold = auto_accept_threshold,
      review_threshold = review_threshold,
      max_candidates_per_employer = max_candidates_per_employer,
      export_formats = export_formats,
      export_results = export_results
    )
  )
  
  class(results) <- c("core_results", class(results))
  
  results
}

# Backward-compatible alias
run_core <- core_run