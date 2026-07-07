# ============================================================
# CORE - Corporate Entity Resolution Engine
#
# Module : 01_install_packages.R
# Purpose: Install required packages for CORE
# Version: 0.0.1
# ============================================================

required_packages <- c(
  "data.table",
  "stringi",
  "readxl",
  "haven",
  "logger",
  "yaml",
  "testthat",
  "shiny",
  "bslib",
  "fs",
  "cli",
  "jsonlite",
  "digest",
  "dplyr",
  "openxlsx"
)

install_if_missing <- function(pkg){
  
  if(!requireNamespace(pkg, quietly = TRUE)){
    
    message("Installing: ", pkg)
    
    install.packages(pkg)
    
  } else {
    
    message("Already installed: ", pkg)
    
  }
  
}

cat("=====================================\n")
cat("CORE Package Installation\n")
cat("=====================================\n\n")

invisible(lapply(required_packages, install_if_missing))

cat("\n")
cat("=====================================\n")
cat("Installation completed.\n")
cat("=====================================\n")