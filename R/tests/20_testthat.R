# ============================================================
# CORE - Corporate Entity Resolution Engine
#
# Module : 20_testthat.R
# Purpose: Formal testthat checks for the CORE pipeline
# Version: 1.0.0
# ============================================================

core_run_testthat <- function() {
  
  if (!requireNamespace("testthat", quietly = TRUE)) {
    stop("Package `testthat` is required. Please install it first.")
  }
  
  cat("=====================================\n")
  cat("CORE testthat Suite Started\n")
  cat("=====================================\n")
  
  source("R/tests/19_test_core.R")
  
  core_test <- core_run_integration_test()
  
  testthat::test_that("CORE result object contains required components", {
    
    testthat::expect_s3_class(core_test, "core_results")
    
    required_objects <- c(
      "employer",
      "reference",
      "candidates",
      "scored_candidates",
      "review_queue",
      "export_files",
      "settings"
    )
    
    testthat::expect_true(
      all(required_objects %in% names(core_test))
    )
  })
  
  testthat::test_that("CORE review queue is valid", {
    
    testthat::expect_true(data.table::is.data.table(core_test$review_queue))
    testthat::expect_gt(nrow(core_test$review_queue), 0)
    
    required_columns <- c(
      "employer_id",
      "employer_name",
      "reference_id",
      "reference_name",
      "confidence_score",
      "candidate_rank",
      "review_status"
    )
    
    testthat::expect_true(
      all(required_columns %in% names(core_test$review_queue))
    )
  })
  
  testthat::test_that("Confidence scores are within valid range", {
    
    testthat::expect_true(
      all(core_test$review_queue$confidence_score >= 0, na.rm = TRUE)
    )
    
    testthat::expect_true(
      all(core_test$review_queue$confidence_score <= 100, na.rm = TRUE)
    )
  })
  
  testthat::test_that("Expected high-confidence matches are found", {
    
    microsoft_score <- core_test$review_queue[
      employer_name == "MICROSOFT" &
        reference_name == "MICROSOFT",
      confidence_score
    ]
    
    amazon_score <- core_test$review_queue[
      employer_name == "AMAZON COM" &
        reference_name == "AMAZON COM",
      confidence_score
    ]
    
    testthat::expect_gt(length(microsoft_score), 0)
    testthat::expect_gte(microsoft_score[1], 95)
    
    testthat::expect_gt(length(amazon_score), 0)
    testthat::expect_gte(amazon_score[1], 95)
  })
  
  testthat::test_that("Candidate ranking is valid within employer", {
    
    rank_check <- core_test$review_queue[
      ,
      .(
        min_rank = min(candidate_rank),
        duplicated_rank = any(duplicated(candidate_rank))
      ),
      by = employer_id
    ]
    
    testthat::expect_true(all(rank_check$min_rank == 1))
    testthat::expect_false(any(rank_check$duplicated_rank))
  })
  
  testthat::test_that("Export files are created", {
    
    expected_files <- c(
      "output/test_core/core_test_results.csv",
      "output/test_core/core_test_results.rds",
      "output/test_core/core_test_results_metadata.json"
    )
    
    testthat::expect_true(
      all(file.exists(expected_files))
    )
  })
  
  cat("=====================================\n")
  cat("CORE testthat Suite Passed\n")
  cat("=====================================\n")
  
  invisible(core_test)
}

# Backward-compatible alias
run_core_testthat <- core_run_testthat