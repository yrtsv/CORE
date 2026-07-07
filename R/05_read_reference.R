# ============================================================
# CORE - Corporate Entity Resolution Engine
#
# Module : 05_read_reference.R
# Purpose: Read the reference company file
# Version: 1.0.0
# ============================================================

core_read_reference <- function(reference_path,
                                sheet = NULL) {
  
  if (is.null(reference_path) ||
      length(reference_path) != 1 ||
      is.na(reference_path) ||
      reference_path == "") {
    stop("`reference_path` must be a non-empty file path.")
  }
  
  if (!file.exists(reference_path)) {
    stop("Reference file not found: ", reference_path)
  }
  
  file_extension <- tolower(tools::file_ext(reference_path))
  
  if (file_extension %in% c("xlsx", "xls")) {
    
    reference_data <- readxl::read_excel(
      reference_path,
      sheet = sheet
    )
    
  } else if (file_extension == "csv") {
    
    reference_data <- data.table::fread(reference_path)
    
  } else if (file_extension == "dta") {
    
    reference_data <- haven::read_dta(reference_path)
    
  } else if (file_extension == "rds") {
    
    reference_data <- readRDS(reference_path)
    
  } else {
    
    stop(
      "Unsupported reference file format: .",
      file_extension,
      ". Supported formats are: xlsx, xls, csv, dta, rds."
    )
  }
  
  reference_data <- data.table::as.data.table(reference_data)
  
  cat("=====================================\n")
  cat("Reference File Loaded\n")
  cat("Path:", reference_path, "\n")
  cat("Rows:", nrow(reference_data), "\n")
  cat("Columns:", ncol(reference_data), "\n")
  cat("=====================================\n")
  
  reference_data[]
}

# Backward-compatible wrapper
read_reference <- function() {
  
  if (!exists("core_config")) {
    stop("core_config not found. Please run 03_project_config.R first.")
  }
  
  core_read_reference(
    reference_path = core_config$files$reference
  )
}