# ============================================================
# CORE - Corporate Entity Resolution Engine
#
# Module : 11_match_exact.R
# Purpose: Perform deterministic exact entity name matching
# Version: 1.0.2
#
# No Dictionary API dependency required.
# ============================================================

core_match_exact <- function(reference_data,
                             employer_data,
                             reference_column = "company_core",
                             employer_column = "company_core") {
  
  if (!data.table::is.data.table(reference_data)) {
    reference_data <- data.table::as.data.table(reference_data)
  }
  
  if (!data.table::is.data.table(employer_data)) {
    employer_data <- data.table::as.data.table(employer_data)
  }
  
  if (!reference_column %in% names(reference_data)) {
    stop("Column `", reference_column, "` not found in reference_data.")
  }
  
  if (!employer_column %in% names(employer_data)) {
    stop("Column `", employer_column, "` not found in employer_data.")
  }
  
  internal_row_id <- "__core_exact_row_id__"
  
  if (internal_row_id %in% names(employer_data)) {
    stop("Internal column name conflict: `", internal_row_id, "` already exists.")
  }
  
  employer_work <- data.table::copy(employer_data)
  employer_work[, (internal_row_id) := .I]
  
  reference_lookup <- reference_data[
    !is.na(get(reference_column)) & get(reference_column) != "",
    .(exact_match_count = .N),
    by = .(company_core_lookup = get(reference_column))
  ]
  
  reference_lookup[, exact_match := TRUE]
  
  result <- merge(
    employer_work,
    reference_lookup,
    by.x = employer_column,
    by.y = "company_core_lookup",
    all.x = TRUE,
    sort = FALSE
  )
  
  result[is.na(exact_match), exact_match := FALSE]
  result[is.na(exact_match_count), exact_match_count := 0L]
  
  data.table::setorderv(result, cols = internal_row_id)
  result[, (internal_row_id) := NULL]
  
  result[]
}

# Backward-compatible alias
match_exact <- core_match_exact