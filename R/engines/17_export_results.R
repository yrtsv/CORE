# ============================================================
# CORE - Corporate Entity Resolution Engine
#
# Module : 17_export_results.R
# Purpose: Export CORE results in analysis-ready formats
# Version: 1.0.0
# ============================================================

core_export_results <- function(data,
                                output_directory = "output",
                                file_name = "core_results",
                                formats = c("csv", "dta"),
                                include_metadata = TRUE) {
  
  if (!data.table::is.data.table(data)) {
    data <- data.table::as.data.table(data)
  }
  
  if (!dir.exists(output_directory)) {
    dir.create(output_directory, recursive = TRUE)
  }
  
  supported_formats <- c("csv", "dta", "rds", "json", "xlsx")
  
  if (length(formats) == 1 && formats == "all") {
    formats <- supported_formats
  }
  
  formats <- unique(tolower(formats))
  
  unsupported_formats <- setdiff(formats, supported_formats)
  
  if (length(unsupported_formats) > 0) {
    stop(
      "Unsupported export format(s): ",
      paste(unsupported_formats, collapse = ", "),
      ". Supported formats are: ",
      paste(supported_formats, collapse = ", ")
    )
  }
  
  if (any(formats %in% c("json", "xlsx"))) {
    warning(
      "JSON and XLSX exports are available for convenience, ",
      "but they are not recommended for large CORE result tables. ",
      "For large datasets, prefer CSV, DTA, or RDS."
    )
  }
  
  export_paths <- list()
  
  if ("csv" %in% formats) {
    csv_path <- file.path(output_directory, paste0(file_name, ".csv"))
    
    data.table::fwrite(
      data,
      file = csv_path,
      quote = TRUE,
      na = ""
    )
    
    export_paths$csv <- csv_path
  }
  
  if ("dta" %in% formats) {
    dta_path <- file.path(output_directory, paste0(file_name, ".dta"))
    
    haven::write_dta(
      as.data.frame(data),
      dta_path
    )
    
    export_paths$dta <- dta_path
  }
  
  if ("rds" %in% formats) {
    rds_path <- file.path(output_directory, paste0(file_name, ".rds"))
    
    saveRDS(
      data,
      rds_path
    )
    
    export_paths$rds <- rds_path
  }
  
  if ("json" %in% formats) {
    json_path <- file.path(output_directory, paste0(file_name, ".json"))
    
    jsonlite::write_json(
      data,
      path = json_path,
      pretty = TRUE,
      dataframe = "rows",
      na = "null"
    )
    
    export_paths$json <- json_path
  }
  
  if ("xlsx" %in% formats) {
    
    if (!requireNamespace("openxlsx", quietly = TRUE)) {
      stop(
        "Package `openxlsx` is required for Excel export. ",
        "Please install it or remove 'xlsx' from formats."
      )
    }
    
    xlsx_path <- file.path(output_directory, paste0(file_name, ".xlsx"))
    
    openxlsx::write.xlsx(
      data,
      file = xlsx_path,
      overwrite = TRUE
    )
    
    export_paths$xlsx <- xlsx_path
  }
  
  if (isTRUE(include_metadata)) {
    
    metadata <- list(
      core_module = "17_export_results.R",
      core_version = "1.0.0",
      exported_at = as.character(Sys.time()),
      output_directory = output_directory,
      file_name = file_name,
      number_of_rows = nrow(data),
      number_of_columns = ncol(data),
      column_names = names(data),
      formats_requested = formats,
      files_created = export_paths
    )
    
    metadata_path <- file.path(
      output_directory,
      paste0(file_name, "_metadata.json")
    )
    
    jsonlite::write_json(
      metadata,
      path = metadata_path,
      pretty = TRUE,
      auto_unbox = TRUE
    )
    
    export_paths$metadata <- metadata_path
  }
  
  invisible(export_paths)
}

# Backward-compatible alias
export_core_results <- core_export_results