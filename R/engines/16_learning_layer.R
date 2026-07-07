# ============================================================
# CORE - Corporate Entity Resolution Engine
#
# Module : 16_learning_layer.R
# Purpose: Save and reuse validated human review decisions
# Version: 1.0.0
# ============================================================

core_create_learning_dictionary_template <- function(
    learning_dictionary_path = "inst/dictionaries/project/custom/learning_dictionary.csv"
) {
  
  learning_template <- data.table::data.table(
    employer_name = character(),
    reference_name = character(),
    employer_id = character(),
    reference_id = character(),
    user_decision = character(),
    confidence_score = numeric(),
    decision_source = character(),
    reviewed_by = character(),
    reviewed_at = character(),
    review_notes = character()
  )
  
  learning_directory <- dirname(learning_dictionary_path)
  
  if (!dir.exists(learning_directory)) {
    dir.create(learning_directory, recursive = TRUE)
  }
  
  data.table::fwrite(
    learning_template,
    learning_dictionary_path,
    quote = TRUE,
    na = ""
  )
  
  invisible(learning_dictionary_path)
}

core_save_learning_decisions <- function(
    review_queue,
    learning_dictionary_path = "inst/dictionaries/project/custom/learning_dictionary.csv",
    decision_source = "human_review"
) {
  
  if (!data.table::is.data.table(review_queue)) {
    review_queue <- data.table::as.data.table(review_queue)
  }
  
  required_columns <- c(
    "employer_id",
    "employer_name",
    "reference_id",
    "reference_name",
    "confidence_score",
    "user_decision"
  )
  
  missing_columns <- setdiff(required_columns, names(review_queue))
  
  if (length(missing_columns) > 0) {
    stop(
      "Missing review queue column(s): ",
      paste(missing_columns, collapse = ", ")
    )
  }
  
  if (!file.exists(learning_dictionary_path)) {
    core_create_learning_dictionary_template(learning_dictionary_path)
  }
  
  existing_dictionary <- data.table::fread(
    learning_dictionary_path,
    na.strings = c("", "NA")
  )
  
  decisions_to_save <- review_queue[
    !is.na(user_decision) &
      user_decision %in% c("accept", "reject", "skip")
  ]
  
  if (nrow(decisions_to_save) == 0) {
    return(existing_dictionary[])
  }
  
  if (!"reviewed_by" %in% names(decisions_to_save)) {
    decisions_to_save[, reviewed_by := NA_character_]
  }
  
  if (!"reviewed_at" %in% names(decisions_to_save)) {
    decisions_to_save[, reviewed_at := NA_character_]
  }
  
  if (!"review_notes" %in% names(decisions_to_save)) {
    decisions_to_save[, review_notes := NA_character_]
  }
  
  decisions_to_save[
    is.na(reviewed_at) | reviewed_at == "",
    reviewed_at := as.character(Sys.time())
  ]
  
  new_entries <- decisions_to_save[
    ,
    .(
      employer_name = as.character(employer_name),
      reference_name = as.character(reference_name),
      employer_id = as.character(employer_id),
      reference_id = as.character(reference_id),
      user_decision = as.character(user_decision),
      confidence_score = as.numeric(confidence_score),
      decision_source = as.character(decision_source),
      reviewed_by = as.character(reviewed_by),
      reviewed_at = as.character(reviewed_at),
      review_notes = as.character(review_notes)
    )
  ]
  
  updated_dictionary <- data.table::rbindlist(
    list(existing_dictionary, new_entries),
    use.names = TRUE,
    fill = TRUE
  )
  
  updated_dictionary <- updated_dictionary[
    order(employer_name, reference_name, reviewed_at)
  ]
  
  updated_dictionary <- updated_dictionary[
    ,
    .SD[.N],
    by = .(
      employer_name,
      reference_name
    )
  ]
  
  data.table::fwrite(
    updated_dictionary,
    learning_dictionary_path,
    quote = TRUE,
    na = ""
  )
  
  updated_dictionary[]
}

core_apply_learning_layer <- function(
    review_queue,
    learning_dictionary_path = "inst/dictionaries/project/custom/learning_dictionary.csv"
) {
  
  if (!data.table::is.data.table(review_queue)) {
    review_queue <- data.table::as.data.table(review_queue)
  }
  
  required_columns <- c("employer_name", "reference_name")
  missing_columns <- setdiff(required_columns, names(review_queue))
  
  if (length(missing_columns) > 0) {
    stop(
      "Missing review queue column(s): ",
      paste(missing_columns, collapse = ", ")
    )
  }
  
  if (!file.exists(learning_dictionary_path)) {
    core_create_learning_dictionary_template(learning_dictionary_path)
  }
  
  learning_dictionary <- data.table::fread(
    learning_dictionary_path,
    na.strings = c("", "NA")
  )
  
  review_queue[, learned_decision := NA_character_]
  review_queue[, learned_match := FALSE]
  
  if (nrow(learning_dictionary) == 0) {
    return(review_queue[])
  }
  
  learning_dictionary <- learning_dictionary[
    !is.na(employer_name) &
      employer_name != "" &
      !is.na(reference_name) &
      reference_name != "" &
      !is.na(user_decision) &
      user_decision %in% c("accept", "reject", "skip")
  ]
  
  if (nrow(learning_dictionary) == 0) {
    return(review_queue[])
  }
  
  learning_dictionary <- learning_dictionary[
    order(employer_name, reference_name, reviewed_at)
  ]
  
  learning_dictionary <- learning_dictionary[
    ,
    .SD[.N],
    by = .(
      employer_name,
      reference_name
    )
  ]
  
  learning_lookup <- learning_dictionary[
    ,
    .(
      employer_name,
      reference_name,
      dict_learned_decision = user_decision
    )
  ]
  
  result <- merge(
    review_queue,
    learning_lookup,
    by = c("employer_name", "reference_name"),
    all.x = TRUE,
    sort = FALSE
  )
  
  result[
    !is.na(dict_learned_decision),
    learned_decision := dict_learned_decision
  ]
  
  result[
    !is.na(learned_decision),
    learned_match := TRUE
  ]
  
  result[
    learned_decision == "accept",
    review_status := "learned_accept"
  ]
  
  result[
    learned_decision == "reject",
    review_status := "learned_reject"
  ]
  
  result[
    learned_decision == "skip",
    review_status := "learned_skip"
  ]
  
  result[, dict_learned_decision := NULL]
  
  result[]
}

# Backward-compatible aliases
create_learning_dictionary_template <- core_create_learning_dictionary_template
save_learning_decisions <- core_save_learning_decisions
apply_learning_layer <- core_apply_learning_layer