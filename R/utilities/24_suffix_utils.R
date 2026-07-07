# ============================================================
# CORE - Corporate Entity Resolution Engine
#
# Module : 24_suffix_utils.R
# Purpose: Utility functions for suffix dictionary handling and regex construction
# Version: 1.0.0
# ============================================================

core_escape_regex <- function(x) {
  
  x <- as.character(x)
  
  gsub(
    "([][{}()+*^$|\\\\?.])",
    "\\\\\\1",
    x
  )
}

core_get_suffix_patterns <- function(dictionary_scope = "project",
                                     dictionary_name = NULL,
                                     base_directory = "inst/dictionaries",
                                     active_only = TRUE) {
  
  if (!exists("core_load_dictionary", mode = "function")) {
    stop(
      "Dictionary API not available. ",
      "Please source 23_dictionary_manager.R before using suffix utilities."
    )
  }
  
  suffix_dictionary <- core_load_dictionary(
    scope = dictionary_scope,
    type = "suffix",
    name = dictionary_name,
    base_directory = base_directory,
    validate = TRUE,
    combine = TRUE
  )
  
  if (!"suffix" %in% names(suffix_dictionary)) {
    stop("Suffix dictionary must contain column `suffix`.")
  }
  
  if (isTRUE(active_only) && "active" %in% names(suffix_dictionary)) {
    suffix_dictionary <- suffix_dictionary[
      is.na(active) | active == TRUE
    ]
  }
  
  suffix_patterns <- unique(trimws(as.character(suffix_dictionary$suffix)))
  
  suffix_patterns <- suffix_patterns[
    !is.na(suffix_patterns) & suffix_patterns != ""
  ]
  
  if (length(suffix_patterns) == 0) {
    stop("Suffix dictionary is empty after validation.")
  }
  
  suffix_patterns[
    order(nchar(suffix_patterns), decreasing = TRUE)
  ]
}

core_build_terminal_suffix_regex <- function(suffix_patterns) {
  
  if (is.null(suffix_patterns) || length(suffix_patterns) == 0) {
    stop("`suffix_patterns` must contain at least one suffix value.")
  }
  
  suffix_patterns <- unique(trimws(as.character(suffix_patterns)))
  
  suffix_patterns <- suffix_patterns[
    !is.na(suffix_patterns) & suffix_patterns != ""
  ]
  
  if (length(suffix_patterns) == 0) {
    stop("`suffix_patterns` is empty after cleaning.")
  }
  
  suffix_patterns <- suffix_patterns[
    order(nchar(suffix_patterns), decreasing = TRUE)
  ]
  
  suffix_patterns_regex <- core_escape_regex(suffix_patterns)
  
  suffix_patterns_regex <- gsub(
    "\\s+",
    "\\\\s+",
    suffix_patterns_regex
  )
  
  paste0(
    "\\s*\\b(",
    paste(suffix_patterns_regex, collapse = "|"),
    ")\\b\\s*$"
  )
}

core_clean_suffix_output <- function(x) {
  
  x <- gsub("[[:punct:]]+", " ", x)
  x <- gsub("\\s+", " ", x)
  trimws(x)
}