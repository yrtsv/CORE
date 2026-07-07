# ============================================================
# CORE - Corporate Entity Resolution Engine
#
# Module : 26_candidate_utils.R
# Purpose: Utility functions for candidate generation
# Version: 1.0.0
# ============================================================

core_candidate_excluded_tokens <- function() {
  c(
    "THE", "AND", "OF",
    "GROUP", "HOLDING", "HOLDINGS",
    "COMPANY", "CO",
    "INC", "CORP", "CORPORATION",
    "LLC", "LTD", "LIMITED"
  )
}

core_validate_candidate_inputs <- function(data,
                                           name_column,
                                           tokens_column,
                                           id_column = NULL,
                                           data_label = "data") {
  
  required_columns <- c(name_column, tokens_column)
  missing_columns <- setdiff(required_columns, names(data))
  
  if (length(missing_columns) > 0) {
    stop(
      "Missing ",
      data_label,
      " column(s): ",
      paste(missing_columns, collapse = ", ")
    )
  }
  
  if (!is.null(id_column) && !id_column %in% names(data)) {
    stop("Column `", id_column, "` not found in ", data_label, ".")
  }
  
  invisible(TRUE)
}

core_prepare_candidate_tokens <- function(data,
                                          id_column,
                                          name_column,
                                          tokens_column,
                                          id_output,
                                          name_output,
                                          excluded_tokens = core_candidate_excluded_tokens()) {
  
  if (!data.table::is.data.table(data)) {
    data <- data.table::as.data.table(data)
  }
  
  token_table <- data[
    ,
    .(
      entity_id = get(id_column),
      entity_name = get(name_column),
      token = strsplit(get(tokens_column), "\\s+")
    )
  ]
  
  token_table <- token_table[
    ,
    .(
      token = unlist(token, use.names = FALSE)
    ),
    by = .(
      entity_id,
      entity_name
    )
  ]
  
  token_table[, token := toupper(trimws(as.character(token)))]
  
  token_table <- token_table[
    !is.na(token) &
      token != "" &
      !token %in% excluded_tokens
  ]
  
  token_table <- unique(token_table)
  
  data.table::setnames(
    token_table,
    old = c("entity_id", "entity_name"),
    new = c(id_output, name_output)
  )
  
  token_table[]
}