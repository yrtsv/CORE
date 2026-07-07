# ============================================================
# CORE - Corporate Entity Resolution Engine
#
# Module : 14_scoring_engine.R
# Purpose: Score candidate entity matches using explainable token metrics
# Version: 1.0.0
#
# Requires:
# - 27_scoring_utils.R
# ============================================================

core_score_candidates <- function(candidates,
                                  employer_data,
                                  reference_data,
                                  employer_id_column = NULL,
                                  reference_id_column = NULL,
                                  employer_name_column = "company_core",
                                  reference_name_column = "company_core",
                                  employer_tokens_column = "company_tokens",
                                  reference_tokens_column = "company_tokens") {
  
  if (!data.table::is.data.table(candidates)) {
    candidates <- data.table::as.data.table(candidates)
  }
  
  if (!data.table::is.data.table(employer_data)) {
    employer_data <- data.table::as.data.table(employer_data)
  }
  
  if (!data.table::is.data.table(reference_data)) {
    reference_data <- data.table::as.data.table(reference_data)
  }
  
  if (!exists("core_validate_scoring_inputs", mode = "function")) {
    stop("core_validate_scoring_inputs() not found. Please source 27_scoring_utils.R first.")
  }
  
  if (!exists("core_prepare_scoring_lookup", mode = "function")) {
    stop("core_prepare_scoring_lookup() not found. Please source 27_scoring_utils.R first.")
  }
  
  if (!exists("core_calculate_token_scores", mode = "function")) {
    stop("core_calculate_token_scores() not found. Please source 27_scoring_utils.R first.")
  }
  
  if (!exists("core_calculate_confidence_score", mode = "function")) {
    stop("core_calculate_confidence_score() not found. Please source 27_scoring_utils.R first.")
  }
  
  core_validate_scoring_inputs(
    candidates = candidates,
    employer_data = employer_data,
    reference_data = reference_data,
    employer_name_column = employer_name_column,
    reference_name_column = reference_name_column,
    employer_tokens_column = employer_tokens_column,
    reference_tokens_column = reference_tokens_column
  )
  
  employer_lookup <- core_prepare_scoring_lookup(
    data = employer_data,
    id_column = employer_id_column,
    name_column = employer_name_column,
    tokens_column = employer_tokens_column,
    id_output = "employer_id",
    tokens_output = "employer_tokens"
  )
  
  reference_lookup <- core_prepare_scoring_lookup(
    data = reference_data,
    id_column = reference_id_column,
    name_column = reference_name_column,
    tokens_column = reference_tokens_column,
    id_output = "reference_id",
    tokens_output = "reference_tokens"
  )
  
  scored <- employer_lookup[
    candidates,
    on = "employer_id"
  ]
  
  scored <- reference_lookup[
    scored,
    on = "reference_id"
  ]
  
  scored <- core_calculate_token_scores(scored)
  scored <- core_calculate_confidence_score(scored)
  
  scored[
    ,
    c(
      "employer_token_list",
      "reference_token_list",
      "shared_token_list"
    ) := NULL
  ]
  
  data.table::setorder(
    scored,
    employer_id,
    -confidence_score,
    reference_id
  )
  
  scored[]
}

# Backward-compatible alias
score_candidates <- core_score_candidates