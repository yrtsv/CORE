# ============================================================
# CORE - Corporate Entity Resolution Engine
#
# Module : 02_load_packages.R
# Purpose: Load required packages for CORE
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
  "dplyr"
)

load_package <- function(pkg) {
  suppressPackageStartupMessages(
    library(pkg, character.only = TRUE)
  )
  message("Loaded: ", pkg)
}

cat("=====================================\n")
cat("CORE Package Loading\n")
cat("=====================================\n\n")

invisible(lapply(required_packages, load_package))

cat("\n")
cat("=====================================\n")
cat("All packages loaded successfully.\n")
cat("=====================================\n")