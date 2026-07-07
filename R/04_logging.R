# ============================================================
# CORE - Corporate Entity Resolution Engine
#
# Module : 04_logging.R
# Purpose: Create a project-level logging system
# Version: 0.0.1
# ============================================================

if (!exists("core_config")) {
  stop("core_config not found. Please run 03_project_config.R first.")
}

log_dir <- core_config$paths$logs

if (!dir.exists(log_dir)) {
  dir.create(log_dir, recursive = TRUE)
}

log_file <- file.path(
  log_dir,
  paste0("core_log_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".log")
)

logger::log_appender(logger::appender_file(log_file))
logger::log_layout(logger::layout_glue_colors)
logger::log_threshold(logger::INFO)

logger::log_info("CORE logging system initialized.")
logger::log_info("Log file: {log_file}")
logger::log_info("CORE version: {core_config$version}")

cat("=====================================\n")
cat("CORE Logging System Initialized\n")
cat("Log file:", log_file, "\n")
cat("=====================================\n")