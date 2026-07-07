# ============================================================
# CORE - Corporate Entity Resolution Engine
#
# Module : 10_suffix_engine.R
# Purpose: Detect and remove terminal legal / organisational suffixes
# Version: 1.0.0
#
# Requires:
# - 23_dictionary_manager.R
# - 24_suffix_utils.R
# ============================================================

core_apply_suffix_engine <- function(data,
                                     name_column = "company_clean",
                                     output_column = "company_core",
                                     max_suffix_iterations = 3,
                                     dictionary_scope = "core",
                                     dictionary_name = NULL,
                                     base_directory = "inst/dictionaries",
                                     keep_original_core = FALSE) {
  
  if (!data.table::is.data.table(data)) {
    data <- data.table::as.data.table(data)
  }
  
  if (!name_column %in% names(data)) {
    stop("Column `", name_column, "` not found in data.")
  }
  
  if (!exists("core_get_suffix_patterns", mode = "function")) {
    stop("core_get_suffix_patterns() not found. Please source 24_suffix_utils.R first.")
  }
  
  if (!exists("core_build_terminal_suffix_regex", mode = "function")) {
    stop("core_build_terminal_suffix_regex() not found. Please source 24_suffix_utils.R first.")
  }
  
  if (!exists("core_clean_suffix_output", mode = "function")) {
    stop("core_clean_suffix_output() not found. Please source 24_suffix_utils.R first.")
  }
  
  if (!is.numeric(max_suffix_iterations) ||
      length(max_suffix_iterations) != 1 ||
      is.na(max_suffix_iterations) ||
      max_suffix_iterations < 1) {
    stop("`max_suffix_iterations` must be a positive numeric value.")
  }
  
  max_suffix_iterations <- as.integer(max_suffix_iterations)
  
  suffix_patterns <- core_get_suffix_patterns(
    dictionary_scope = dictionary_scope,
    dictionary_name = dictionary_name,
    base_directory = base_directory,
    active_only = TRUE
  )
  
  terminal_suffix_regex <- core_build_terminal_suffix_regex(
    suffix_patterns = suffix_patterns
  )
  
  data[, (output_column) := core_clean_suffix_output(get(name_column))]
  
  data[, original_company_core := get(output_column)]
  
  for (i in seq_len(max_suffix_iterations)) {
    
    before <- data[[output_column]]
    
    data[, (output_column) := gsub(
      terminal_suffix_regex,
      "",
      get(output_column),
      ignore.case = TRUE,
      perl = TRUE
    )]
    
    data[, (output_column) := core_clean_suffix_output(get(output_column))]
    
    after <- data[[output_column]]
    
    if (identical(before, after)) {
      break
    }
  }
  
  data[
    get(output_column) == "" | is.na(get(output_column)),
    (output_column) := get(name_column)
  ]
  
  data[, suffix_removed := original_company_core != get(output_column)]
  data[, suffix_detected := suffix_removed]
  data[, core_nchar := nchar(get(output_column))]
  
  if (!isTRUE(keep_original_core)) {
    data[, original_company_core := NULL]
  }
  
  data[]
}

# Backward-compatible alias
apply_suffix_engine <- core_apply_suffix_engine