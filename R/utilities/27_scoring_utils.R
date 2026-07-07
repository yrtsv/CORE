# ============================================================
# CORE - Corporate Entity Resolution Engine
#
# Module : 27_scoring_utils.R
# Purpose: Utility functions for candidate scoring
# Version: 1.0.0
# ============================================================

core_split_tokens <- function(x) {
  
  x <- ifelse(is.na(x), "", x)
  tokens <- unlist(strsplit(as.character(x), "\\s+"))
  tokens <- toupper(trimws(tokens))
  tokens <- tokens[!is.na(tokens) & tokens != ""]
  
  unique(tokens)
}

core_validate_scoring_inputs <- function(candidates,
                                         employer_data,
                                         reference_data,
                                         employer_name_column,
                                         reference_name_column,
                                         employer_tokens_column,
                                         reference_tokens_column) {
  
  required_candidate_columns <- c(
    "employer_id",
    "employer_name",
    "reference_id",
    "reference_name",
    "shared_tokens",
    "shared_token_count"
  )
  
  missing_candidate_columns <- setdiff(
    required_candidate_columns,
    names(candidates)
  )
  
  if (length(missing_candidate_columns) > 0) {
    stop(
      "Missing candidate column(s): ",
      paste(missing_candidate_columns, collapse = ", ")
    )
  }
  
  employer_required <- c(employer_name_column, employer_tokens_column)
  reference_required <- c(reference_name_column, reference_tokens_column)
  
  missing_employer_columns <- setdiff(employer_required, names(employer_data))
  missing_reference_columns <- setdiff(reference_required, names(reference_data))
  
  if (length(missing_employer_columns) > 0) {
    stop(
      "Missing employer column(s): ",
      paste(missing_employer_columns, collapse = ", ")
    )
  }
  
  if (length(missing_reference_columns) > 0) {
    stop(
      "Missing reference column(s): ",
      paste(missing_reference_columns, collapse = ", ")
    )
  }
  
  invisible(TRUE)
}

core_prepare_scoring_lookup <- function(data,
                                        id_column,
                                        name_column,
                                        tokens_column,
                                        id_output,
                                        tokens_output) {
  
  if (!data.table::is.data.table(data)) {
    data <- data.table::as.data.table(data)
  }
  
  work <- data.table::copy(data)
  
  if (is.null(id_column)) {
    work[, core_scoring_id := .I]
    id_column <- "core_scoring_id"
  } else {
    if (!id_column %in% names(work)) {
      stop("Column `", id_column, "` not found in data.")
    }
  }
  
  lookup <- work[
    ,
    .(
      entity_id = get(id_column),
      entity_tokens = get(tokens_column)
    )
  ]
  
  data.table::setnames(
    lookup,
    old = c("entity_id", "entity_tokens"),
    new = c(id_output, tokens_output)
  )
  
  lookup[]
}

core_calculate_token_scores <- function(scored) {
  
  scored[
    ,
    `:=`(
      employer_token_list = lapply(employer_tokens, core_split_tokens),
      reference_token_list = lapply(reference_tokens, core_split_tokens),
      shared_token_list = lapply(shared_tokens, core_split_tokens)
    )
  ]
  
  scored[
    ,
    employer_only_tokens := mapply(
      function(emp, shared) paste(setdiff(emp, shared), collapse = " "),
      employer_token_list,
      shared_token_list,
      SIMPLIFY = TRUE
    )
  ]
  
  scored[
    ,
    reference_only_tokens := mapply(
      function(ref, shared) paste(setdiff(ref, shared), collapse = " "),
      reference_token_list,
      shared_token_list,
      SIMPLIFY = TRUE
    )
  ]
  
  scored[
    ,
    `:=`(
      employer_token_count = lengths(employer_token_list),
      reference_token_count = lengths(reference_token_list)
    )
  ]
  
  scored[
    ,
    shared_token_ratio := data.table::fifelse(
      (employer_token_count + reference_token_count - shared_token_count) > 0,
      shared_token_count /
        (employer_token_count + reference_token_count - shared_token_count),
      0
    )
  ]
  
  scored[
    ,
    employer_coverage := data.table::fifelse(
      employer_token_count > 0,
      shared_token_count / employer_token_count,
      0
    )
  ]
  
  scored[
    ,
    reference_coverage := data.table::fifelse(
      reference_token_count > 0,
      shared_token_count / reference_token_count,
      0
    )
  ]
  
  scored[
    ,
    token_count_similarity := data.table::fifelse(
      pmax(employer_token_count, reference_token_count) > 0,
      pmin(employer_token_count, reference_token_count) /
        pmax(employer_token_count, reference_token_count),
      0
    )
  ]
  
  scored[]
}

core_calculate_confidence_score <- function(scored) {
  
  scored[
    ,
    exact_core_name_match := employer_name == reference_name
  ]
  
  scored[
    ,
    `:=`(
      shared_token_score = shared_token_ratio * 40,
      employer_coverage_score = employer_coverage * 25,
      reference_coverage_score = reference_coverage * 20,
      token_count_score = token_count_similarity * 10,
      exact_match_bonus = data.table::fifelse(exact_core_name_match, 5, 0)
    )
  ]
  
  scored[
    ,
    confidence_score := round(
      shared_token_score +
        employer_coverage_score +
        reference_coverage_score +
        token_count_score +
        exact_match_bonus,
      2
    )
  ]
  
  scored[
    confidence_score > 100,
    confidence_score := 100
  ]
  
  scored[
    ,
    score_explanation := paste0(
      "Shared token score: ", round(shared_token_score, 2),
      "; Employer coverage score: ", round(employer_coverage_score, 2),
      "; Reference coverage score: ", round(reference_coverage_score, 2),
      "; Token count score: ", round(token_count_score, 2),
      "; Exact match bonus: ", round(exact_match_bonus, 2)
    )
  ]
  
  scored[]
}