# ============================================================
# CORE - Corporate Entity Resolution Engine
#
# Module : 12_alias_engine.R
# Purpose: Apply validated alias decisions to entity names
# Version: 1.0.1
#
# Requires:
# - 23_dictionary_manager.R
# - 25_alias_utils.R
# ============================================================

core_apply_alias_engine <- function(data,
                                    name_column = "company_core",
                                    dictionary_scope = "project",
                                    dictionary_name = NULL,
                                    base_directory = "inst/dictionaries") {
  
  if (!data.table::is.data.table(data)) {
    data <- data.table::as.data.table(data)
  }
  
  if (!name_column %in% names(data)) {
    stop("Column `", name_column, "` not found in data.")
  }
  
  if (!exists("core_get_alias_dictionary", mode = "function")) {
    stop("core_get_alias_dictionary() not found. Please source 25_alias_utils.R first.")
  }
  
  if (!exists("core_prepare_alias_lookup", mode = "function")) {
    stop("core_prepare_alias_lookup() not found. Please source 25_alias_utils.R first.")
  }
  
  if (!exists("core_normalise_alias_input", mode = "function")) {
    stop("core_normalise_alias_input() not found. Please source 25_alias_utils.R first.")
  }
  
  alias_dictionary <- core_get_alias_dictionary(
    dictionary_scope = dictionary_scope,
    dictionary_name = dictionary_name,
    base_directory = base_directory,
    validated_only = TRUE
  )
  
  data[, alias_match := FALSE]
  data[, alias_canonical := NA_character_]
  data[, alias_source := NA_character_]
  data[, alias_validated := NA]
  
  if (nrow(alias_dictionary) == 0) {
    return(data[])
  }
  
  lookup <- core_prepare_alias_lookup(alias_dictionary)
  
  internal_alias_lookup <- "__core_alias_lookup_name__"
  internal_row_id <- "__core_alias_row_id__"
  
  if (internal_alias_lookup %in% names(data)) {
    stop(
      "Internal column name conflict: `",
      internal_alias_lookup,
      "` already exists in data."
    )
  }
  
  if (internal_row_id %in% names(data)) {
    stop(
      "Internal column name conflict: `",
      internal_row_id,
      "` already exists in data."
    )
  }
  
  data[, (internal_row_id) := .I]
  data[, (internal_alias_lookup) := core_normalise_alias_input(get(name_column))]
  
  result <- lookup[
    data,
    on = c(alias_lookup_name = internal_alias_lookup)
  ]
  
  result[!is.na(dict_alias_canonical), alias_match := TRUE]
  result[!is.na(dict_alias_canonical), alias_canonical := dict_alias_canonical]
  result[!is.na(dict_alias_source), alias_source := dict_alias_source]
  result[!is.na(dict_alias_validated), alias_validated := dict_alias_validated]
  
  data.table::setorderv(
    result,
    cols = internal_row_id
  )
  
  result[
    ,
    c(
      "alias_lookup_name",
      "dict_alias_canonical",
      "dict_alias_source",
      "dict_alias_validated",
      internal_row_id
    ) := NULL
  ]
  
  result[]
}

# Backward-compatible alias
apply_alias_engine <- core_apply_alias_engine