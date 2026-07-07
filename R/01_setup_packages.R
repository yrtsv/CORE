# ============================================================
# CORE - Corporate Entity Resolution Engine
# 01_setup_packages.R
# Purpose: Install and load required R packages
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
  "bslib"
)

install_if_missing <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
}

invisible(lapply(required_packages, install_if_missing))

invisible(lapply(required_packages, library, character.only = TRUE))

cat("CORE package setup completed successfully.\n")