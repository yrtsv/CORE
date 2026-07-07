# ============================================================
# CORE - Corporate Entity Resolution Engine
#
# Module : 08_tokenizer.R
# Purpose: Tokenize cleaned company names
# Version: 1.0.0
# ============================================================

core_tokenize_company_names <- function(data,
                                        input_column = "company_clean",
                                        output_column = "company_tokens",
                                        token_count_column = "token_count") {
  
  if (!data.table::is.data.table(data)) {
    data <- data.table::as.data.table(data)
  }
  
  if (!input_column %in% names(data)) {
    stop(
      "Column `", input_column,
      "` not found. Please run 07_clean_names.R first."
    )
  }
  
  data[
    ,
    (output_column) := stringi::stri_split_regex(
      get(input_column),
      "\\s+",
      simplify = FALSE
    )
  ]
  
  data[
    ,
    (output_column) := lapply(
      get(output_column),
      function(tokens) {
        
        if (length(tokens) == 0 || all(is.na(tokens))) {
          return("")
        }
        
        tokens <- trimws(tokens)
        tokens <- tokens[tokens != ""]
        tokens <- unique(tokens)
        
        paste(tokens, collapse = " ")
      }
    )
  ]
  
  data[
    ,
    (output_column) := unlist(get(output_column))
  ]
  
  data[
    ,
    (token_count_column) := data.table::fifelse(
      get(output_column) == "",
      0L,
      lengths(strsplit(get(output_column), "\\s+"))
    )
  ]
  
  cat("=====================================\n")
  cat("Company Tokenization Completed\n")
  cat("Rows:", nrow(data), "\n")
  cat(
    "Average token count:",
    round(mean(data[[token_count_column]], na.rm = TRUE), 2),
    "\n"
  )
  cat(
    "Output columns:",
    output_column, ", ", token_count_column, "\n",
    sep = ""
  )
  cat("=====================================\n")
  
  data[]
}

# Backward-compatible alias
tokenize_company_names <- core_tokenize_company_names