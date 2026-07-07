# ============================================================
# CORE - Corporate Entity Resolution Engine
#
# Module : 19_test_core.R
# Purpose: Run a small integration test for the CORE pipeline
# Version: 1.0.0
# ============================================================

core_run_integration_test <- function() {
  
  cat("=====================================\n")
  cat("CORE Integration Test Started\n")
  cat("=====================================\n")
  
  source("R/05_read_reference.R")
  source("R/06_read_employer.R")
  source("R/07_clean_names.R")
  source("R/08_tokenizer.R")
  source("R/09_prepare_reference.R")
  
  source("R/managers/23_dictionary_manager.R")
  
  source("R/utilities/24_suffix_utils.R")
  source("R/utilities/25_alias_utils.R")
  source("R/utilities/26_candidate_utils.R")
  source("R/utilities/27_scoring_utils.R")
  
  source("R/engines/10_suffix_engine.R")
  source("R/engines/11_match_exact.R")
  source("R/engines/12_alias_engine.R")
  source("R/engines/13_candidate_generation.R")
  source("R/engines/14_scoring_engine.R")
  source("R/engines/15_review_queue.R")
  source("R/engines/16_learning_layer.R")
  source("R/engines/17_export_results.R")
  
  source("R/workflow/18_run_core.R")
  
  dir.create("data/raw", recursive = TRUE, showWarnings = FALSE)
  dir.create("data/reference", recursive = TRUE, showWarnings = FALSE)
  dir.create("output/test_core", recursive = TRUE, showWarnings = FALSE)
  dir.create("inst/dictionaries/project/suffix", recursive = TRUE, showWarnings = FALSE)
  dir.create("inst/dictionaries/project/alias", recursive = TRUE, showWarnings = FALSE)
  dir.create("inst/dictionaries/project/custom", recursive = TRUE, showWarnings = FALSE)
  
  suffix_dictionary <- data.table::data.table(
    suffix = c("INC", "CORP", "CORPORATION", "LLC", "LTD", "LIMITED"),
    canonical_suffix = c(
      "Incorporated",
      "Corporation",
      "Corporation",
      "Limited Liability Company",
      "Limited",
      "Limited"
    ),
    country = "US",
    language = "English",
    active = TRUE,
    notes = ""
  )
  
  core_save_dictionary(
    data = suffix_dictionary,
    scope = "project",
    type = "suffix",
    name = "test_suffix",
    overwrite = TRUE
  )
  
  alias_dictionary <- data.table::data.table(
    alias = c("APPLE COMPUTER", "AMAZON COM"),
    canonical_name = c("APPLE", "AMAZON"),
    source = "integration_test",
    validated = TRUE,
    notes = ""
  )
  
  core_save_dictionary(
    data = alias_dictionary,
    scope = "project",
    type = "alias",
    name = "test_alias",
    overwrite = TRUE
  )
  
  learning_dictionary_path <- "inst/dictionaries/project/custom/test_learning_dictionary.csv"
  
  if (file.exists(learning_dictionary_path)) {
    file.remove(learning_dictionary_path)
  }
  
  test_employer <- data.frame(
    donor_id = 1:6,
    company = c(
      "Apple Computer",
      "Microsoft Corp",
      "Amazon.com Inc",
      "1st Source Bank",
      "Texas 1st Source Construction",
      "Unknown Local Shop"
    ),
    donation_amount = c(250, 500, 1000, 150, 75, 40),
    cycle = c(2020, 2020, 2022, 2022, 2024, 2024),
    state = c("CA", "WA", "WA", "IN", "TX", "NY")
  )
  
  employer_path <- "data/raw/test_employer.dta"
  
  haven::write_dta(
    test_employer,
    employer_path
  )
  
  test_reference <- data.frame(
    company_id = c(101, 102, 103, 104),
    gvkey = c("001690", "012141", "064768", "010500"),
    cik = c("320193", "789019", "1018724", "34782"),
    ticker = c("AAPL", "MSFT", "AMZN", "SRCE"),
    company_name = c(
      "APPLE INC",
      "MICROSOFT CORPORATION",
      "AMAZON.COM INC",
      "1ST SOURCE CORP"
    )
  )
  
  reference_path <- "data/reference/test_reference.dta"
  
  haven::write_dta(
    test_reference,
    reference_path
  )
  
  core_test <- core_run(
    employer_path = employer_path,
    reference_path = reference_path,
    employer_company_column = "company",
    reference_company_column = "company_name",
    output_directory = "output/test_core",
    output_file_name = "core_test_results",
    dictionary_scope = "project",
    alias_dictionary_name = "test_alias",
    learning_dictionary_path = learning_dictionary_path,
    min_shared_tokens = 1,
    auto_accept_threshold = 95,
    review_threshold = 70,
    max_candidates_per_employer = 5,
    export_formats = c("csv", "rds"),
    export_results = TRUE
  )
  
  required_objects <- c(
    "employer",
    "reference",
    "candidates",
    "scored_candidates",
    "review_queue",
    "export_files",
    "settings"
  )
  
  missing_objects <- setdiff(required_objects, names(core_test))
  
  if (length(missing_objects) > 0) {
    stop(
      "Integration test failed. Missing object(s): ",
      paste(missing_objects, collapse = ", ")
    )
  }
  
  if (nrow(core_test$review_queue) == 0) {
    stop("Integration test failed. Review queue is empty.")
  }
  
  required_review_columns <- c(
    "employer_id",
    "employer_name",
    "reference_id",
    "reference_name",
    "confidence_score",
    "candidate_rank",
    "review_status"
  )
  
  missing_review_columns <- setdiff(
    required_review_columns,
    names(core_test$review_queue)
  )
  
  if (length(missing_review_columns) > 0) {
    stop(
      "Integration test failed. Missing review column(s): ",
      paste(missing_review_columns, collapse = ", ")
    )
  }
  
  microsoft_match <- core_test$review_queue[
    employer_name == "MICROSOFT" &
      reference_name == "MICROSOFT",
    confidence_score
  ]
  
  amazon_match <- core_test$review_queue[
    employer_name == "AMAZON COM" &
      reference_name == "AMAZON COM",
    confidence_score
  ]
  
  if (length(microsoft_match) == 0 || microsoft_match[1] < 95) {
    stop("Integration test failed. Microsoft expected high-confidence match not found.")
  }
  
  if (length(amazon_match) == 0 || amazon_match[1] < 95) {
    stop("Integration test failed. Amazon expected high-confidence match not found.")
  }
  
  expected_files <- c(
    "output/test_core/core_test_results.csv",
    "output/test_core/core_test_results.rds",
    "output/test_core/core_test_results_metadata.json"
  )
  
  missing_files <- expected_files[!file.exists(expected_files)]
  
  if (length(missing_files) > 0) {
    stop(
      "Integration test failed. Missing export file(s): ",
      paste(missing_files, collapse = ", ")
    )
  }
  
  cat("=====================================\n")
  cat("CORE Integration Test Passed\n")
  cat("Rows in review queue:", nrow(core_test$review_queue), "\n")
  cat("Export files created:\n")
  print(core_test$export_files)
  cat("=====================================\n")
  
  invisible(core_test)
}

# Backward-compatible alias
run_core_integration_test <- core_run_integration_test