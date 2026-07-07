# ============================================================
# CORE - Corporate Entity Resolution Engine
#
# Module : 25_alias_utils.R
# Purpose: Utility functions for alias dictionary handling
# Version: 1.0.0
# ============================================================

core_get_alias_dictionary <- function(dictionary_scope = "project",
                                      dictionary_name = NULL,
                                      base_directory = "inst/dictionaries",
                                      validated_only = TRUE) {
  
  if (!exists("core_load_dictionary", mode = "function")) {
    stop(
      "Dictionary API not available. ",
      "Please source 23_dictionary_manager.R before using alias utilities."
    )
  }
  
  alias_dictionary <- core_load_dictionary(
    scope = dictionary_scope,
    type = "alias",
    name = dictionary_name,
    base_directory = base_directory,
    validate = TRUE,
    combine = TRUE
  )
  
  if (!data.table::is.data.table(alias_dictionary)) {
    alias_dictionary <- data.table::as.data.table(alias_dictionary)
  }
  
  if (nrow(alias_dictionary) == 0) {
    return(alias_dictionary[])
  }
  
  alias_dictionary[, alias := toupper(trimws(as.character(alias)))]
  alias_dictionary[, canonical_name := toupper(trimws(as.character(canonical_name)))]
  alias_dictionary[, source := trimws(as.character(source))]
  
  alias_dictionary <- alias_dictionary[
    !is.na(alias) &
      alias != "" &
      !is.na(canonical_name) &
      canonical_name != ""
  ]
  
  if (isTRUE(validated_only) && "validated" %in% names(alias_dictionary)) {
    alias_dictionary <- alias_dictionary[
      is.na(validated) | validated == TRUE
    ]
  }
  
  alias_dictionary[
    ,
    .SD[.N],
    by = alias
  ][]
}

core_prepare_alias_lookup <- function(alias_dictionary) {
  
  if (!data.table::is.data.table(alias_dictionary)) {
    alias_dictionary <- data.table::as.data.table(alias_dictionary)
  }
  
  if (nrow(alias_dictionary) == 0) {
    return(
      data.table::data.table(
        alias_lookup_name = character(),
        dict_alias_canonical = character(),
        dict_alias_source = character(),
        dict_alias_validated = logical()
      )
    )
  }
  
  alias_dictionary[
    ,
    .(
      alias_lookup_name = alias,
      dict_alias_canonical = canonical_name,
      dict_alias_source = source,
      dict_alias_validated = validated
    )
  ]
}

core_normalise_alias_input <- function(x) {
  toupper(trimws(as.character(x)))
}