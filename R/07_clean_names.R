# ============================================================
# CORE - Corporate Entity Resolution Engine
#
# Module : 07_clean_names.R
# Purpose: Create standardized company name variables
# Version: 1.0.0
# ============================================================

core_clean_company_names <- function(data,
                                     company_column = "company") {
  
  if (!data.table::is.data.table(data)) {
    data <- data.table::as.data.table(data)
  }
  
  if (!company_column %in% names(data)) {
    stop("Column `", company_column, "` not found in data.")
  }
  
  data[, company_u := toupper(as.character(get(company_column)))]
  
  data[, company_clean := company_u]
  
  data[, company_clean := stringi::stri_replace_all_regex(
    company_clean,
    "[[:punct:]]+",
    " "
  )]
  
  data[, company_clean := stringi::stri_replace_all_regex(
    company_clean,
    "\\s+",
    " "
  )]
  
  data[, company_clean := trimws(company_clean)]
  
  data[
    company_clean == "",
    company_clean := NA_character_
  ]
  
  cat("=====================================\n")
  cat("Company Names Cleaned\n")
  cat("Rows:", nrow(data), "\n")
  cat("Input column:", company_column, "\n")
  cat("Output columns: company_u, company_clean\n")
  cat("=====================================\n")
  
  data[]
}

# Backward-compatible alias
clean_company_names <- core_clean_company_names