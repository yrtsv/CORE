# CORE Shiny deployment entry point

app_environment <- new.env(parent = globalenv())

app_result <- source(
  file = "app/app.R",
  local = app_environment,
  chdir = FALSE
)

app_object <- app_result$value

if (!inherits(app_object, "shiny.appobj")) {
  stop("app/app.R did not return a valid Shiny application object.")
}

app_object