# ============================================================
# CORE - Corporate Entity Resolution Engine
#
# Module : 18_run_core.R
# Purpose: Run the full CORE pipeline and return intermediate outputs
# Version: 1.0.0
# ============================================================

core_run <- function(employer_path,
                     reference_path,
                     employer_company_column = "company",
                     reference_company_column = "company name",
                     employer_columns = NULL,
                     output_directory = "output",
                     output_file_name = "core_results",
                     dictionary_scope = "project",
                     alias_dictionary_name = NULL,
                     learning_dictionary_path = "inst/dictionaries/project/custom/learning_dictionary.csv",
                     min_shared_tokens = 1,
                     auto_accept_threshold = 95,
                     review_threshold = 80,
                     max_candidates_per_employer = 5,
                     export_formats = c("csv", "dta"),
                     export_results = TRUE) {
  
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
  
  employer <- haven::read_dta(employer_path)
  employer <- data.table::as.data.table(employer)
  
  if (!is.null(employer_columns)) {
    employer <- employer[, ..employer_columns]
  }
  
  reference <- haven::read_dta(reference_path)
  reference <- data.table::as.data.table(reference)
  
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
  
  review_queue <- core_apply_learning_layer(
    review_queue = review_queue,
    learning_dictionary_path = learning_dictionary_path
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