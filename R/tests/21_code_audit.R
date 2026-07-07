# ============================================================
# CORE - Corporate Entity Resolution Engine
#
# Module : 21_code_audit.R
# Purpose: Run project health and release-readiness audit
# Version: 1.0.1
# ============================================================

core_run_code_audit <- function(project_root = ".") {
  
  cat("=====================================\n")
  cat("CORE Code Audit Started\n")
  cat("=====================================\n")
  
  audit_results <- list()
  
  required_folders <- c(
    "data", "data/raw", "data/processed", "data/reference",
    "docs", "logs", "output",
    "R", "R/config", "R/managers", "R/utilities", "R/engines",
    "R/workflow", "R/diagnostics", "R/tests",
    "inst", "inst/dictionaries",
    "inst/dictionaries/core",
    "inst/dictionaries/community",
    "inst/dictionaries/project"
  )
  
  folder_check <- data.table::data.table(
    folder = required_folders,
    exists = dir.exists(file.path(project_root, required_folders))
  )
  
  audit_results$folders <- folder_check
  
  required_files <- c(
    "R/01_install_packages.R",
    "R/01_setup_packages.R",
    "R/02_load_packages.R",
    "R/03_project_config.R",
    "R/04_logging.R",
    "R/05_read_reference.R",
    "R/06_read_employer.R",
    "R/07_clean_names.R",
    "R/08_tokenizer.R",
    "R/09_prepare_reference.R",
    "R/22_dictionary_templates.R",
    "R/managers/23_dictionary_manager.R",
    "R/utilities/24_suffix_utils.R",
    "R/utilities/25_alias_utils.R",
    "R/utilities/26_candidate_utils.R",
    "R/utilities/27_scoring_utils.R",
    "R/engines/10_suffix_engine.R",
    "R/engines/11_match_exact.R",
    "R/engines/12_alias_engine.R",
    "R/engines/13_candidate_generation.R",
    "R/engines/14_scoring_engine.R",
    "R/engines/15_review_queue.R",
    "R/engines/16_learning_layer.R",
    "R/engines/17_export_results.R",
    "R/workflow/18_run_core.R",
    "R/tests/19_test_core.R",
    "R/tests/20_testthat.R",
    "R/tests/21_code_audit.R"
  )
  
  file_check <- data.table::data.table(
    file = required_files,
    exists = file.exists(file.path(project_root, required_files))
  )
  
  audit_results$files <- file_check
  
  # Source required files before checking functions.
  # This makes the audit independent of what the user already loaded.
  files_to_source <- file_check[exists == TRUE, file]
  
  for (file_to_source in files_to_source) {
    source(file.path(project_root, file_to_source), local = FALSE)
  }
  
  required_packages <- c(
    "data.table", "dplyr", "haven", "jsonlite",
    "openxlsx", "readxl", "stringi", "testthat"
  )
  
  package_check <- data.table::data.table(
    package = required_packages,
    installed = vapply(
      required_packages,
      requireNamespace,
      logical(1),
      quietly = TRUE
    )
  )
  
  audit_results$packages <- package_check
  
  required_functions <- c(
    "core_read_reference",
    "core_read_employer",
    "core_clean_company_names",
    "core_tokenize_company_names",
    "core_prepare_reference",
    "core_apply_suffix_engine",
    "core_match_exact",
    "core_apply_alias_engine",
    "core_generate_candidates",
    "core_score_candidates",
    "core_create_review_queue",
    "core_create_learning_dictionary_template",
    "core_save_learning_decisions",
    "core_apply_learning_layer",
    "core_export_results",
    "core_run",
    "core_run_integration_test",
    "core_run_testthat",
    "core_run_code_audit"
  )
  
  function_check <- data.table::data.table(
    function_name = required_functions,
    exists = vapply(
      required_functions,
      exists,
      logical(1),
      mode = "function"
    )
  )
  
  audit_results$functions <- function_check
  
  dictionary_folders <- c(
    "inst/dictionaries/core/suffix",
    "inst/dictionaries/core/alias",
    "inst/dictionaries/core/company",
    "inst/dictionaries/core/geography",
    "inst/dictionaries/core/custom",
    "inst/dictionaries/project/suffix",
    "inst/dictionaries/project/alias",
    "inst/dictionaries/project/company",
    "inst/dictionaries/project/geography",
    "inst/dictionaries/project/custom"
  )
  
  dictionary_check <- data.table::data.table(
    folder = dictionary_folders,
    exists = dir.exists(file.path(project_root, dictionary_folders))
  )
  
  audit_results$dictionaries <- dictionary_check
  
  expected_test_exports <- c(
    "output/test_core/core_test_results.csv",
    "output/test_core/core_test_results.rds",
    "output/test_core/core_test_results_metadata.json"
  )
  
  export_check <- data.table::data.table(
    file = expected_test_exports,
    exists = file.exists(file.path(project_root, expected_test_exports))
  )
  
  audit_results$test_exports <- export_check
  
  documentation_files <- c(
    "README.md",
    "The_Philosophy_Behind_CORE.md",
    "Architecture.md",
    "Workflow.md",
    "Review_Queue.md",
    "Learning_Layer.md",
    "Methodology.md"
  )
  
  documentation_check <- data.table::rbindlist(
    lapply(
      documentation_files,
      function(doc_file) {
        
        candidate_paths <- unique(c(
          doc_file,
          file.path("docs", doc_file)
        ))
        
        existing_paths <- candidate_paths[
          file.exists(file.path(project_root, candidate_paths))
        ]
        
        data.table::data.table(
          file = doc_file,
          exists = length(existing_paths) > 0,
          path_found = ifelse(length(existing_paths) > 0, existing_paths[1], NA_character_)
        )
      }
    )
  )
  
  audit_results$documentation <- documentation_check
  
  github_files <- c(
    ".gitignore",
    "LICENSE",
    "README.md"
  )
  
  github_file_check <- data.table::data.table(
    file = github_files,
    exists = file.exists(file.path(project_root, github_files))
  )
  
  audit_results$github_files <- github_file_check
  
  risk_notes <- data.table::data.table(
    area = c(
      "Candidate generation",
      "Scoring",
      "Learning Layer",
      "Large data",
      "Exports",
      "Community dictionaries"
    ),
    note = c(
      "Token overlap joins may become large on full employer datasets; chunking and blocking strategies should be considered in a performance sprint.",
      "Current scoring weights are fixed in v1.0. Future versions may support configurable scoring profiles.",
      "The Learning Layer currently persists validated decisions as CSV. SQLite or DuckDB may be considered for larger review histories.",
      "For large employer datasets, selected employer_columns should be used whenever possible.",
      "CSV and RDS are recommended for large outputs. XLSX and JSON should be treated as convenience formats.",
      "Community dictionaries are reserved in the architecture but not active in v1.0."
    )
  )
  
  audit_results$risk_notes <- risk_notes
  
  critical_failures <- c(
    any(!folder_check$exists),
    any(!file_check$exists),
    any(!package_check$installed),
    any(!function_check$exists),
    any(!dictionary_check$exists),
    any(!documentation_check$exists),
    any(!github_file_check$exists)
  )
  
  audit_status <- if (any(critical_failures)) {
    "ACTION_REQUIRED"
  } else {
    "PASSED"
  }
  
  audit_summary <- list(
    core_version = "1.0.0",
    audit_status = audit_status,
    audit_time = as.character(Sys.time()),
    folders_missing = folder_check[exists == FALSE, folder],
    files_missing = file_check[exists == FALSE, file],
    packages_missing = package_check[installed == FALSE, package],
    functions_missing = function_check[exists == FALSE, function_name],
    dictionaries_missing = dictionary_check[exists == FALSE, folder],
    documentation_missing = documentation_check[exists == FALSE, file],
    github_files_missing = github_file_check[exists == FALSE, file]
  )
  
  audit_results$summary <- audit_summary
  
  dir.create(
    file.path(project_root, "output"),
    recursive = TRUE,
    showWarnings = FALSE
  )
  
  audit_report_path <- file.path(
    project_root,
    "output",
    "core_code_audit_report.json"
  )
  
  jsonlite::write_json(
    audit_results,
    path = audit_report_path,
    pretty = TRUE,
    auto_unbox = TRUE
  )
  
  cat("=====================================\n")
  cat("CORE Code Audit Summary\n")
  cat("Version:", audit_summary$core_version, "\n")
  cat("Status:", audit_status, "\n")
  cat("Missing folders:", length(audit_summary$folders_missing), "\n")
  cat("Missing files:", length(audit_summary$files_missing), "\n")
  cat("Missing packages:", length(audit_summary$packages_missing), "\n")
  cat("Missing functions:", length(audit_summary$functions_missing), "\n")
  cat("Missing dictionaries:", length(audit_summary$dictionaries_missing), "\n")
  cat("Missing documentation:", length(audit_summary$documentation_missing), "\n")
  cat("Missing GitHub files:", length(audit_summary$github_files_missing), "\n")
  cat("Audit report:", audit_report_path, "\n")
  cat("=====================================\n")
  
  invisible(audit_results)
}

# Backward-compatible alias
run_core_code_audit <- core_run_code_audit