# ============================================================
# CORE - Corporate Entity Resolution Engine
#
# Module : 06_read_employer.R
# Purpose: Read the employer dataset
# Version: 1.0.0
# ============================================================

core_read_employer <- function(employer_path,
                               columns = NULL) {
  
  if (is.null(employer_path) ||
      length(employer_path) != 1 ||
      is.na(employer_path) ||
      employer_path == "") {
    stop("`employer_path` must be a non-empty file path.")
  }
  
  if (!file.exists(employer_path)) {
    stop("Employer file not found: ", employer_path)
  }
  
  file_extension <- tolower(tools::file_ext(employer_path))
  
  if (file_extension == "dta") {
    
    if (is.null(columns)) {
      employer_data <- haven::read_dta(employer_path)
    } else {
      employer_data <- haven::read_dta(
        employer_path,
        col_select = dplyr::all_of(columns)
      )
    }
    
  } else if (file_extension == "csv") {
    
    employer_data <- data.table::fread(
      employer_path,
      select = columns
    )
    
  } else if (file_extension %in% c("xlsx", "xls")) {
    
    employer_data <- readxl::read_excel(employer_path)
    
    if (!is.null(columns)) {
      employer_data <- employer_data[, columns, drop = FALSE]
    }
    
  } else if (file_extension == "rds") {
    
    employer_data <- readRDS(employer_path)
    
    if (!is.null(columns)) {
      employer_data <- employer_data[, columns, drop = FALSE]
    }
    
  } else {
    
    stop(
      "Unsupported employer file format: .",
      file_extension,
      ". Supported formats are: dta, csv, xlsx, xls, rds."
    )
  }
  
  employer_data <- data.table::as.data.table(employer_data)
  
  cat("=====================================\n")
  cat("Employer File Loaded\n")
  cat("Path:", employer_path, "\n")
  cat("Rows:", nrow(employer_data), "\n")
  cat("Columns:", ncol(employer_data), "\n")
  cat("=====================================\n")
  
  employer_data[]
}

# Backward-compatible wrapper
read_employer <- function(columns = NULL) {
  
  if (!exists("core_config")) {
    stop("core_config not found. Please run 03_project_config.R first.")
  }
  
  core_read_employer(
    employer_path = core_config$files$employer,
    columns = columns
  )
}