# ============================================================
# CORE - Corporate Entity Resolution Engine
#
# Module : 15_review_queue.R
# Purpose: Create ranked human-review queue from scored candidates
# Version: 1.0.0
# ============================================================

core_create_review_queue <- function(scored_candidates,
                                     auto_accept_threshold = 95,
                                     review_threshold = 80,
                                     max_candidates_per_employer = 5) {
  
  if (!data.table::is.data.table(scored_candidates)) {
    scored_candidates <- data.table::as.data.table(scored_candidates)
  }
  
  required_columns <- c(
    "employer_id",
    "employer_name",
    "reference_id",
    "reference_name",
    "confidence_score"
  )
  
  missing_columns <- setdiff(required_columns, names(scored_candidates))
  
  if (length(missing_columns) > 0) {
    stop(
      "Missing scored candidate column(s): ",
      paste(missing_columns, collapse = ", ")
    )
  }
  
  if (!is.numeric(auto_accept_threshold) ||
      length(auto_accept_threshold) != 1 ||
      is.na(auto_accept_threshold) ||
      auto_accept_threshold < 0 ||
      auto_accept_threshold > 100) {
    stop("`auto_accept_threshold` must be a numeric value between 0 and 100.")
  }
  
  if (!is.numeric(review_threshold) ||
      length(review_threshold) != 1 ||
      is.na(review_threshold) ||
      review_threshold < 0 ||
      review_threshold > 100) {
    stop("`review_threshold` must be a numeric value between 0 and 100.")
  }
  
  if (review_threshold > auto_accept_threshold) {
    stop("`review_threshold` cannot be greater than `auto_accept_threshold`.")
  }
  
  if (!is.numeric(max_candidates_per_employer) ||
      length(max_candidates_per_employer) != 1 ||
      is.na(max_candidates_per_employer) ||
      max_candidates_per_employer < 1) {
    stop("`max_candidates_per_employer` must be greater than or equal to 1.")
  }
  
  max_candidates_per_employer <- as.integer(max_candidates_per_employer)
  
  review_queue <- data.table::copy(scored_candidates)
  
  data.table::setorder(
    review_queue,
    employer_id,
    -confidence_score,
    reference_id
  )
  
  review_queue[
    ,
    candidate_rank := seq_len(.N),
    by = employer_id
  ]
  
  review_queue <- review_queue[
    candidate_rank <= max_candidates_per_employer
  ]
  
  review_queue[
    ,
    review_status := data.table::fcase(
      confidence_score >= auto_accept_threshold, "auto_accept",
      confidence_score >= review_threshold, "needs_review",
      default = "discard"
    )
  ]
  
  review_queue[, user_decision := NA_character_]
  review_queue[, reviewed_at := NA_character_]
  review_queue[, reviewed_by := NA_character_]
  review_queue[, review_notes := NA_character_]
  
  review_queue[
    ,
    review_priority := data.table::fcase(
      review_status == "needs_review", 1L,
      review_status == "auto_accept", 2L,
      review_status == "discard", 3L,
      default = 9L
    )
  ]
  
  data.table::setorder(
    review_queue,
    review_priority,
    employer_id,
    candidate_rank
  )
  
  review_queue[]
}

# Backward-compatible alias
create_review_queue <- core_create_review_queue