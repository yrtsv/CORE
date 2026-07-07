# ============================================================
# CORE - Corporate Entity Resolution Engine
#
# Module : 13_candidate_generation.R
# Purpose: Generate candidate entity matches using token overlap
# Version: 1.0.0
#
# Requires:
# - 26_candidate_utils.R
# ============================================================

core_generate_candidates <- function(employer_data,
                                     reference_data,
                                     employer_id_column = NULL,
                                     reference_id_column = NULL,
                                     employer_name_column = "company_core",
                                     reference_name_column = "company_core",
                                     employer_tokens_column = "company_tokens",
                                     reference_tokens_column = "company_tokens",
                                     min_shared_tokens = 1) {
  
  if (!data.table::is.data.table(employer_data)) {
    employer_data <- data.table::as.data.table(employer_data)
  }
  
  if (!data.table::is.data.table(reference_data)) {
    reference_data <- data.table::as.data.table(reference_data)
  }
  
  if (!exists("core_prepare_candidate_tokens", mode = "function")) {
    stop("core_prepare_candidate_tokens() not found. Please source 26_candidate_utils.R first.")
  }
  
  if (!exists("core_validate_candidate_inputs", mode = "function")) {
    stop("core_validate_candidate_inputs() not found. Please source 26_candidate_utils.R first.")
  }
  
  core_validate_candidate_inputs(
    data = employer_data,
    name_column = employer_name_column,
    tokens_column = employer_tokens_column,
    id_column = employer_id_column,
    data_label = "employer_data"
  )
  
  core_validate_candidate_inputs(
    data = reference_data,
    name_column = reference_name_column,
    tokens_column = reference_tokens_column,
    id_column = reference_id_column,
    data_label = "reference_data"
  )
  
  if (!is.numeric(min_shared_tokens) ||
      length(min_shared_tokens) != 1 ||
      is.na(min_shared_tokens) ||
      min_shared_tokens < 1) {
    stop("`min_shared_tokens` must be a numeric value greater than or equal to 1.")
  }
  
  min_shared_tokens <- as.integer(min_shared_tokens)
  
  employer_work <- data.table::copy(employer_data)
  reference_work <- data.table::copy(reference_data)
  
  if (is.null(employer_id_column)) {
    employer_work[, core_employer_id := .I]
    employer_id_column <- "core_employer_id"
  }
  
  if (is.null(reference_id_column)) {
    reference_work[, core_reference_id := .I]
    reference_id_column <- "core_reference_id"
  }
  
  employer_tokens <- core_prepare_candidate_tokens(
    data = employer_work,
    id_column = employer_id_column,
    name_column = employer_name_column,
    tokens_column = employer_tokens_column,
    id_output = "employer_id",
    name_output = "employer_name"
  )
  
  reference_tokens <- core_prepare_candidate_tokens(
    data = reference_work,
    id_column = reference_id_column,
    name_column = reference_name_column,
    tokens_column = reference_tokens_column,
    id_output = "reference_id",
    name_output = "reference_name"
  )
  
  if (nrow(employer_tokens) == 0 || nrow(reference_tokens) == 0) {
    return(
      data.table::data.table(
        employer_id = integer(),
        employer_name = character(),
        reference_id = integer(),
        reference_name = character(),
        shared_tokens = character(),
        shared_token_count = integer()
      )
    )
  }
  
  data.table::setkey(employer_tokens, token)
  data.table::setkey(reference_tokens, token)
  
  token_matches <- merge(
    employer_tokens,
    reference_tokens,
    by = "token",
    allow.cartesian = TRUE
  )
  
  candidates <- token_matches[
    ,
    .(
      shared_tokens = paste(sort(unique(token)), collapse = " "),
      shared_token_count = data.table::uniqueN(token)
    ),
    by = .(
      employer_id,
      employer_name,
      reference_id,
      reference_name
    )
  ]
  
  candidates <- candidates[
    shared_token_count >= min_shared_tokens
  ]
  
  data.table::setorder(
    candidates,
    employer_id,
    -shared_token_count,
    reference_id
  )
  
  candidates[]
}

# Backward-compatible alias
generate_candidates <- core_generate_candidates