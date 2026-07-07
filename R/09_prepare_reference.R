# ============================================================
# CORE - Corporate Entity Resolution Engine
#
# Module : 09_prepare_reference.R
# Purpose: Prepare reference company data for matching
# Version: 1.0.0
# ============================================================

core_prepare_reference <- function(reference_data,
                                   company_column = "company name") {
  
  if (missing(reference_data) || is.null(reference_data)) {
    stop("`reference_data` must be provided.")
  }
  
  if (!data.table::is.data.table(reference_data)) {
    reference_data <- data.table::as.data.table(reference_data)
  }
  
  if (!company_column %in% names(reference_data)) {
    stop("Column `", company_column, "` not found in reference_data.")
  }
  
  if (!exists("core_clean_company_names", mode = "function")) {
    stop("core_clean_company_names() not found. Please source 07_clean_names.R first.")
  }
  
  if (!exists("core_tokenize_company_names", mode = "function")) {
    stop("core_tokenize_company_names() not found. Please source 08_tokenizer.R first.")
  }
  
  reference_data <- core_clean_company_names(
    reference_data,
    company_column = company_column
  )
  
  reference_data <- core_tokenize_company_names(
    reference_data,
    input_column = "company_clean",
    output_column = "company_tokens",
    token_count_column = "token_count"
  )
  
  cat("=====================================\n")
  cat("Reference Data Prepared\n")
  cat("Rows:", nrow(reference_data), "\n")
  cat("Columns:", ncol(reference_data), "\n")
  cat("=====================================\n")
  
  reference_data[]
}

# Backward-compatible alias
prepare_reference <- core_prepare_reference