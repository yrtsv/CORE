# ============================================================
# CORE - Corporate Entity Resolution Engine
#
# Module : 03_project_config.R
# Purpose: Define project-level configuration settings
# Version: 1.0.0
# ============================================================

core_config <- list(
  
  project_name = "Corporate Entity Resolution Engine",
  short_name   = "CORE",
  version      = "1.0.0",
  
  paths = list(
    data_raw       = "data/raw",
    data_reference = "data/reference",
    data_processed = "data/processed",
    dictionary     = "dictionary",
    output         = "output",
    logs           = "logs",
    docs           = "docs",
    tests          = "tests",
    app            = "app",
    www            = "www"
  ),
  
  files = list(
    employer = "data/raw/employee based donation dataset.dta",
    reference = "data/reference/company list for matching V3.xlsx",
    aliases = "dictionary/aliases.csv",
    manual_rules = "dictionary/manual_rules.csv",
    validated_decisions = "dictionary/validated_decisions.csv"
  ),
  
  required_employer_columns = c(
    "company_id",
    "company",
    "year",
    "dem_donation",
    "rep_donation",
    "other_donation",
    "total_donation",
    "source"
  ),
  
  required_reference_columns = c(
    "company name"
  )
)

cat("=====================================\n")
cat("CORE Project Configuration Loaded\n")
cat("Version:", core_config$version, "\n")
cat("=====================================\n")