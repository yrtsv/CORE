library(shiny)
library(data.table)
library(haven)
library(DT)

# ------------------------------------------------------------
# Portable project paths
# ------------------------------------------------------------

find_project_root <- function() {
  candidates <- unique(c(
    normalizePath(getwd(), winslash = "/", mustWork = FALSE),
    normalizePath(file.path(getwd(), ".."), winslash = "/", mustWork = FALSE)
  ))
  
  for (candidate in candidates) {
    if (
      file.exists(file.path(candidate, "R", "07_clean_names.R")) &&
      dir.exists(file.path(candidate, "inst"))
    ) {
      return(candidate)
    }
  }
  
  stop(
    "CORE project root could not be found. ",
    "Run or deploy the application from the repository root or app directory."
  )
}

project_root <- find_project_root()
app_dir <- file.path(project_root, "app")

learning_dictionary_path <- file.path(
  project_root,
  "inst",
  "dictionaries",
  "project",
  "custom",
  "learning_dictionary.csv"
)

# ------------------------------------------------------------
# Source CORE modules
# ------------------------------------------------------------

source_files <- c(
  "R/07_clean_names.R",
  "R/08_tokenizer.R",
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
  "R/workflow/18_run_core.R"
)

for (file in source_files) {
  source(file.path(project_root, file), local = FALSE)
}

# ------------------------------------------------------------
# Helper functions
# ------------------------------------------------------------

first_available <- function(df, possible_cols) {
  hit <- possible_cols[possible_cols %in% names(df)]
  if (length(hit) == 0) return(rep(NA, nrow(df)))
  df[[hit[1]]]
}

clean_na <- function(x) {
  ifelse(is.na(x) | x == "", "-", x)
}

word_count <- function(n, word) {
  if (is.na(n) || n == 0) return(NULL)
  if (n == 1) return(paste0(word, " once before."))
  if (n == 2) return(paste0(word, " twice before."))
  paste0(word, " ", n, " times before.")
}

learning_dictionary_rows <- function(path = learning_dictionary_path) {
  if (!file.exists(path)) return(0L)
  nrow(data.table::fread(path))
}

load_previous_review_summary <- function(path = learning_dictionary_path) {
  
  if (!file.exists(path)) {
    return(data.table::data.table(
      employer_name = character(),
      reference_name = character(),
      previous_accept_count = integer(),
      previous_reject_count = integer(),
      previous_skip_count = integer(),
      previous_review_count = integer()
    ))
  }
  
  ld <- data.table::fread(path, na.strings = c("", "NA"))
  
  required_cols <- c("employer_name", "reference_name", "user_decision")
  missing_cols <- setdiff(required_cols, names(ld))
  
  if (length(missing_cols) > 0 || nrow(ld) == 0) {
    return(data.table::data.table(
      employer_name = character(),
      reference_name = character(),
      previous_accept_count = integer(),
      previous_reject_count = integer(),
      previous_skip_count = integer(),
      previous_review_count = integer()
    ))
  }
  
  ld <- ld[
    !is.na(employer_name) &
      !is.na(reference_name) &
      !is.na(user_decision) &
      user_decision %in% c("accept", "reject", "skip")
  ]
  
  if (nrow(ld) == 0) {
    return(data.table::data.table(
      employer_name = character(),
      reference_name = character(),
      previous_accept_count = integer(),
      previous_reject_count = integer(),
      previous_skip_count = integer(),
      previous_review_count = integer()
    ))
  }
  
  ld[
    ,
    .(
      previous_accept_count = sum(user_decision == "accept"),
      previous_reject_count = sum(user_decision == "reject"),
      previous_skip_count = sum(user_decision == "skip"),
      previous_review_count = .N
    ),
    by = .(employer_name, reference_name)
  ]
}

previous_review_text <- function(accept_count, reject_count, skip_count) {
  
  parts <- c(
    word_count(accept_count, "Accepted"),
    word_count(reject_count, "Rejected"),
    word_count(skip_count, "Skipped")
  )
  
  parts <- parts[!is.null(parts)]
  
  if (length(parts) == 0) {
    return("No previous review history.")
  }
  
  paste(parts, collapse = "\n")
}

run_core_pipeline <- function(employer_data, reference_data) {
  
  old_wd <- getwd()
  setwd(project_root)
  on.exit(setwd(old_wd), add = TRUE)
  
  names(employer_data)[1] <- "company"
  names(reference_data)[1] <- "company_name"
  
  employer_path <- tempfile(fileext = ".dta")
  reference_path <- tempfile(fileext = ".dta")
  
  haven::write_dta(employer_data, employer_path)
  haven::write_dta(reference_data, reference_path)
  
  core_run(
    employer_path = employer_path,
    reference_path = reference_path,
    employer_company_column = "company",
    reference_company_column = "company_name",
    output_directory = tempdir(),
    output_file_name = "core_shiny_demo",
    export_results = FALSE,
    use_learning_layer = FALSE,
    learning_mode = "none"
  )
}

# ------------------------------------------------------------
# User interface
# ------------------------------------------------------------

ui <- fluidPage(
  
  titlePanel("CORE Demonstrator"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      h4("Mode"),
      radioButtons(
        "app_mode",
        label = NULL,
        choices = c(
          "Demonstration Mode" = "demo",
          "Research Mode" = "research"
        ),
        selected = "demo"
      ),
      
      uiOutput("mode_panel"),
      
      hr(),
      
      h4("Previous Review History"),
      verbatimTextOutput("learning_dictionary_status"),
      tags$div(
        style = "font-size: 12px; color: #666;",
        "Previous decisions are shown as review history only. CORE does not automatically accept, reject, or rescore matches based on previous decisions."
      ),
      
      hr(),
      
      h4("Review actions"),
      uiOutput("review_action_panel"),
      
      hr(),
      
      h4("Save Learning"),
      textInput("reviewer_name", "Reviewer", value = "shiny_user"),
      actionButton("save_learning", "Save learned decisions"),
      br(), br(),
      verbatimTextOutput("learning_status"),
      
      hr(),
      
      h4("Export"),
      downloadButton("download_decisions", "Export reviewed decisions")
    ),
    
    mainPanel(
      tabsetPanel(
        
        tabPanel(
          "Review Queue",
          br(),
          h4("Curated Review Queue"),
          p("Select a row to inspect diagnostics and record a review decision."),
          DT::dataTableOutput("review_queue"),
          br(),
          h4("Match Diagnostics"),
          verbatimTextOutput("diagnostics")
        ),
        
        tabPanel(
          "Scored Candidates",
          br(),
          h4("Scored Candidate Pairs"),
          DT::dataTableOutput("scored_candidates")
        ),
        
        tabPanel(
          "Statistics",
          br(),
          DT::dataTableOutput("stats")
        )
      )
    )
  )
)

# ------------------------------------------------------------
# Server
# ------------------------------------------------------------

server <- function(input, output, session) {
  
  review_decisions <- reactiveVal(NULL)
  core_results_store <- reactiveVal(NULL)
  learning_status <- reactiveVal("No learned decisions saved yet.")
  selected_review_id <- reactiveVal(NULL)
  
  output$learning_dictionary_status <- renderText({
    rows <- learning_dictionary_rows()
    
    if (rows == 0) {
      return("No previous review history found.")
    }
    
    paste0("Previous review records found: ", rows)
  })
  
  output$mode_panel <- renderUI({
    
    if (input$app_mode == "demo") {
      tagList(
        p("Use built-in demo data to run CORE instantly."),
        actionButton("run_demo", "Run Demonstration")
      )
    } else {
      tagList(
        fileInput("employer_file", "Upload employer data", accept = ".csv"),
        fileInput("reference_file", "Upload reference company data", accept = ".csv"),
        actionButton("run_core", "Run CORE")
      )
    }
  })
  
  observeEvent(input$run_demo, {
    
    employer_data <- read.csv(
      file.path(app_dir, "data", "demo_employers.csv"),
      stringsAsFactors = FALSE
    )
    
    reference_data <- read.csv(
      file.path(app_dir, "data", "demo_reference.csv"),
      stringsAsFactors = FALSE
    )
    
    results <- run_core_pipeline(employer_data, reference_data)
    core_results_store(results)
    selected_review_id(NULL)
    
    review_decisions(
      data.frame(
        review_id = seq_len(nrow(results$review_queue)),
        user_decision = rep(NA_character_, nrow(results$review_queue)),
        learned = rep(FALSE, nrow(results$review_queue)),
        reviewed_at = rep(NA_character_, nrow(results$review_queue)),
        stringsAsFactors = FALSE
      )
    )
    
    learning_status("No learned decisions saved yet.")
    showNotification("Demonstration completed.", type = "message")
  })
  
  observeEvent(input$run_core, {
    
    req(input$employer_file)
    req(input$reference_file)
    
    employer_data <- read.csv(
      input$employer_file$datapath,
      stringsAsFactors = FALSE
    )
    
    reference_data <- read.csv(
      input$reference_file$datapath,
      stringsAsFactors = FALSE
    )
    
    results <- run_core_pipeline(employer_data, reference_data)
    core_results_store(results)
    selected_review_id(NULL)
    
    review_decisions(
      data.frame(
        review_id = seq_len(nrow(results$review_queue)),
        user_decision = rep(NA_character_, nrow(results$review_queue)),
        learned = rep(FALSE, nrow(results$review_queue)),
        reviewed_at = rep(NA_character_, nrow(results$review_queue)),
        stringsAsFactors = FALSE
      )
    )
    
    learning_status("No learned decisions saved yet.")
    showNotification("CORE run completed.", type = "message")
  })
  
  core_results <- reactive({
    req(core_results_store())
    core_results_store()
  })
  
  review_queue_full_with_history <- reactive({
    req(core_results())
    
    rq <- data.table::as.data.table(as.data.frame(core_results()$review_queue))
    
    rq[, review_id := seq_len(.N)]
    
    previous_summary <- load_previous_review_summary()
    
    rq <- merge(
      rq,
      previous_summary,
      by = c("employer_name", "reference_name"),
      all.x = TRUE,
      sort = FALSE
    )
    
    for (col in c(
      "previous_accept_count",
      "previous_reject_count",
      "previous_skip_count",
      "previous_review_count"
    )) {
      if (!col %in% names(rq)) rq[, (col) := 0L]
      rq[is.na(get(col)), (col) := 0L]
    }
    
    rq[, previous_review_history := mapply(
      previous_review_text,
      previous_accept_count,
      previous_reject_count,
      previous_skip_count
    )]
    
    rq[]
  })
  
  review_queue_curated <- reactive({
    req(review_queue_full_with_history())
    
    rq <- as.data.frame(review_queue_full_with_history())
    decisions <- review_decisions()
    
    out <- data.frame(
      review_id = rq$review_id,
      employer_name = clean_na(first_available(rq, c("employer_name", "company", "company_u"))),
      reference_name = clean_na(first_available(rq, c("reference_name", "company_name"))),
      confidence_score = first_available(rq, c("confidence_score", "final_score", "score")),
      system_status = clean_na(first_available(rq, c("review_status", "status"))),
      priority = first_available(rq, c("review_priority", "priority")),
      previous_reviews = first_available(rq, c("previous_review_count")),
      stringsAsFactors = FALSE
    )
    
    if (!is.null(decisions)) {
      out$user_decision <- clean_na(decisions$user_decision)
    } else {
      out$user_decision <- "-"
    }
    
    out
  })
  
  observeEvent(input$review_queue_rows_selected, {
    
    selected_row <- input$review_queue_rows_selected
    
    if (length(selected_row) == 0) {
      selected_review_id(NULL)
      return(NULL)
    }
    
    rq <- review_queue_curated()
    selected_review_id(rq$review_id[selected_row])
  })
  
  selected_row_index <- reactive({
    req(selected_review_id())
    rq <- review_queue_curated()
    which(rq$review_id == selected_review_id())[1]
  })
  
  scored_candidates_curated <- reactive({
    req(core_results())
    
    sc <- as.data.frame(core_results()$scored_candidates)
    
    data.frame(
      employer_name = clean_na(first_available(sc, c("employer_name", "company", "company_u"))),
      reference_name = clean_na(first_available(sc, c("reference_name", "company_name"))),
      confidence_score = first_available(sc, c("confidence_score", "final_score", "score")),
      candidate_rank = first_available(sc, c("candidate_rank", "rank")),
      shared_tokens = clean_na(first_available(sc, c("shared_tokens"))),
      employer_only_tokens = clean_na(first_available(sc, c("employer_only_tokens"))),
      reference_only_tokens = clean_na(first_available(sc, c("reference_only_tokens"))),
      stringsAsFactors = FALSE
    )
  })
  
  output$review_action_panel <- renderUI({
    
    if (is.null(core_results_store())) {
      return(tags$p("Run CORE first."))
    }
    
    if (is.null(selected_review_id())) {
      return(tags$p("No candidate selected."))
    }
    
    rq <- review_queue_curated()
    selected_row <- rq[rq$review_id == selected_review_id(), , drop = FALSE]
    
    tagList(
      tags$p(
        strong("Selected pair:"), br(),
        selected_row$employer_name, " → ", selected_row$reference_name
      ),
      actionButton("accept_match", "Accept Match"),
      actionButton("reject_match", "Reject Match"),
      actionButton("learn_match", "Learn from Decision")
    )
  })
  
  update_decision <- function(decision_value = NULL, learn_value = NULL) {
    
    req(core_results())
    
    id <- selected_review_id()
    
    if (is.null(id)) {
      showNotification("Please select a row first.", type = "warning")
      return(NULL)
    }
    
    decisions <- review_decisions()
    req(decisions)
    
    idx <- which(decisions$review_id == id)
    
    if (length(idx) == 0) {
      showNotification("Selected row could not be found.", type = "error")
      return(NULL)
    }
    
    if (!is.null(decision_value)) {
      decisions$user_decision[idx] <- decision_value
      decisions$reviewed_at[idx] <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
    }
    
    if (!is.null(learn_value)) {
      decisions$learned[idx] <- learn_value
      decisions$reviewed_at[idx] <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
    }
    
    review_decisions(decisions)
    selected_review_id(id)
    
    showNotification("Decision updated.", type = "message")
  }
  
  observeEvent(input$accept_match, {
    update_decision(decision_value = "accept")
  })
  
  observeEvent(input$reject_match, {
    update_decision(decision_value = "reject")
  })
  
  observeEvent(input$learn_match, {
    update_decision(learn_value = TRUE)
  })
  
  learning_review_queue <- reactive({
    
    req(review_queue_full_with_history())
    req(review_decisions())
    
    rq_full <- as.data.frame(review_queue_full_with_history())
    decisions <- review_decisions()
    
    data.table::data.table(
      review_id = rq_full$review_id,
      employer_id = as.character(first_available(rq_full, c("employer_id"))),
      employer_name = as.character(first_available(rq_full, c("employer_name", "company", "company_u"))),
      reference_id = as.character(first_available(rq_full, c("reference_id"))),
      reference_name = as.character(first_available(rq_full, c("reference_name", "company_name"))),
      confidence_score = as.numeric(first_available(rq_full, c("confidence_score", "final_score", "score"))),
      user_decision = decisions$user_decision,
      learned = decisions$learned,
      reviewed_by = input$reviewer_name,
      reviewed_at = decisions$reviewed_at,
      review_notes = NA_character_
    )
  })
  
  observeEvent(input$save_learning, {
    
    req(review_queue_full_with_history())
    req(review_decisions())
    
    learning_df <- learning_review_queue()
    
    learning_df <- learning_df[
      learned == TRUE &
        !is.na(user_decision) &
        user_decision %in% c("accept", "reject", "skip")
    ]
    
    if (nrow(learning_df) == 0) {
      showNotification(
        "No learned decisions to save. Mark rows with 'Learn from Decision' first.",
        type = "warning"
      )
      return(NULL)
    }
    
    saved_dictionary <- core_save_learning_decisions(
      review_queue = learning_df,
      learning_dictionary_path = learning_dictionary_path,
      decision_source = "shiny_review"
    )
    
    learning_status(
      paste0(
        "Saved ", nrow(learning_df), " learned decision(s).\n",
        "Learning dictionary: ", learning_dictionary_path, "\n",
        "Total dictionary rows: ", nrow(saved_dictionary)
      )
    )
    
    showNotification("Learned decisions saved to learning dictionary.", type = "message")
  })
  
  output$learning_status <- renderText({
    learning_status()
  })
  
  output$review_queue <- DT::renderDataTable({
    
    req(review_queue_curated())
    rq <- review_queue_curated()
    
    DT::datatable(
      rq,
      rownames = FALSE,
      selection = "single",
      filter = "top",
      options = list(
        pageLength = 10,
        scrollX = TRUE,
        autoWidth = TRUE,
        columnDefs = list(
          list(visible = FALSE, targets = 0)
        )
      )
    ) %>%
      DT::formatStyle(
        "system_status",
        backgroundColor = DT::styleEqual(
          c("auto_accept", "review", "discard"),
          c("#dff0d8", "#fcf8e3", "#f2dede")
        )
      ) %>%
      DT::formatStyle(
        "user_decision",
        backgroundColor = DT::styleEqual(
          c("accept", "reject", "skip"),
          c("#dff0d8", "#f2dede", "#fcf8e3")
        )
      ) %>%
      DT::formatStyle(
        "previous_reviews",
        backgroundColor = DT::styleInterval(
          0,
          c(NA, "#d9edf7")
        )
      )
  })
  
  output$scored_candidates <- DT::renderDataTable({
    
    req(scored_candidates_curated())
    sc <- scored_candidates_curated()
    
    DT::datatable(
      sc,
      rownames = FALSE,
      filter = "top",
      options = list(
        pageLength = 10,
        scrollX = TRUE,
        autoWidth = TRUE
      )
    )
  })
  
  output$diagnostics <- renderText({
    
    req(review_queue_full_with_history())
    
    id <- selected_review_id()
    
    if (is.null(id)) {
      return("Select a candidate pair from the Review Queue.")
    }
    
    rq_full <- as.data.frame(review_queue_full_with_history())
    row <- rq_full[rq_full$review_id == id, , drop = FALSE]
    decisions <- review_decisions()
    drow <- decisions[decisions$review_id == id, , drop = FALSE]
    
    employer_name <- clean_na(first_available(row, c("employer_name", "company", "company_u")))
    reference_name <- clean_na(first_available(row, c("reference_name", "company_name")))
    employer_id <- clean_na(first_available(row, c("employer_id")))
    reference_id <- clean_na(first_available(row, c("reference_id")))
    shared_tokens <- clean_na(first_available(row, c("shared_tokens")))
    employer_only <- clean_na(first_available(row, c("employer_only_tokens")))
    reference_only <- clean_na(first_available(row, c("reference_only_tokens")))
    shared_ratio <- clean_na(first_available(row, c("shared_token_ratio")))
    employer_coverage <- clean_na(first_available(row, c("employer_coverage")))
    reference_coverage <- clean_na(first_available(row, c("reference_coverage")))
    confidence_score <- clean_na(first_available(row, c("confidence_score", "final_score", "score")))
    system_status <- clean_na(first_available(row, c("review_status", "status")))
    explanation <- clean_na(first_available(row, c("score_explanation", "explanation")))
    previous_history <- clean_na(first_available(row, c("previous_review_history")))
    
    user_decision <- clean_na(drow$user_decision)
    learned <- clean_na(drow$learned)
    reviewed_at <- clean_na(drow$reviewed_at)
    
    paste0(
      "Employer:\n", employer_name, "\n\n",
      "Employer ID:\n", employer_id, "\n\n",
      "Reference:\n", reference_name, "\n\n",
      "Reference ID:\n", reference_id, "\n\n",
      "Previous review history:\n", previous_history, "\n\n",
      "Shared tokens:\n", shared_tokens, "\n\n",
      "Employer-only tokens:\n", employer_only, "\n\n",
      "Reference-only tokens:\n", reference_only, "\n\n",
      "Shared token ratio:\n", shared_ratio, "\n\n",
      "Employer coverage:\n", employer_coverage, "\n\n",
      "Reference coverage:\n", reference_coverage, "\n\n",
      "Final confidence score:\n", confidence_score, "\n\n",
      "System decision:\n", system_status, "\n\n",
      "Human decision:\n", user_decision, "\n\n",
      "Marked for learning:\n", learned, "\n\n",
      "Reviewed at:\n", reviewed_at, "\n\n",
      "Score explanation:\n", explanation
    )
  })
  
  output$stats <- DT::renderDataTable({
    
    req(review_queue_full_with_history())
    decisions <- review_decisions()
    rq <- as.data.frame(review_queue_full_with_history())
    
    reviewed_count <- if (is.null(decisions)) 0 else sum(!is.na(decisions$user_decision))
    learned_count <- if (is.null(decisions)) 0 else sum(decisions$learned)
    dictionary_rows <- learning_dictionary_rows()
    rows_with_previous_reviews <- sum(rq$previous_review_count > 0, na.rm = TRUE)
    
    stats_df <- data.frame(
      metric = c(
        "Employer records",
        "Reference records",
        "Candidate pairs",
        "Scored candidates",
        "Review queue rows",
        "User-reviewed rows",
        "Marked for learning",
        "Learning dictionary rows",
        "Rows with previous reviews"
      ),
      value = c(
        nrow(core_results()$employer),
        nrow(core_results()$reference),
        nrow(core_results()$candidates),
        nrow(core_results()$scored_candidates),
        nrow(core_results()$review_queue),
        reviewed_count,
        learned_count,
        dictionary_rows,
        rows_with_previous_reviews
      )
    )
    
    DT::datatable(
      stats_df,
      rownames = FALSE,
      options = list(
        dom = "t",
        pageLength = 9
      )
    )
  })
  
  output$download_decisions <- downloadHandler(
    
    filename = function() {
      paste0("core_reviewed_decisions_", Sys.Date(), ".csv")
    },
    
    content = function(file) {
      
      req(review_queue_curated())
      req(review_decisions())
      
      rq <- review_queue_curated()
      decisions <- review_decisions()
      
      rq_export <- rq[, !names(rq) %in% c("user_decision"), drop = FALSE]
      
      export_df <- merge(
        rq_export,
        decisions,
        by = "review_id",
        all.x = TRUE
      )
      
      write.csv(export_df, file, row.names = FALSE)
    }
  )
}

shinyApp(ui, server)
