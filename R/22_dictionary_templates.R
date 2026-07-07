# ============================================================
# CORE - Corporate Entity Resolution Engine
#
# Module : 22_dictionary_templates.R
# Purpose: Create standard CORE dictionary template files
# Version: 1.0.0
# ============================================================

core_create_dictionary_templates <- function(base_directory = "inst/dictionaries",
                                             scope = "project",
                                             overwrite = FALSE) {
  
  if (!exists("core_dictionary_scopes")) {
    stop("core_dictionary_scopes() not found. Please source 23_dictionary_manager.R first.")
  }
  
  if (!exists("core_dictionary_types")) {
    stop("core_dictionary_types() not found. Please source 23_dictionary_manager.R first.")
  }
  
  if (!exists("core_save_dictionary")) {
    stop("core_save_dictionary() not found. Please source 23_dictionary_manager.R first.")
  }
  
  if (!scope %in% core_dictionary_scopes()) {
    stop(
      "Unsupported dictionary scope: ",
      scope,
      ". Supported scopes are: ",
      paste(core_dictionary_scopes(), collapse = ", ")
    )
  }
  
  dictionary_templates <- list(
    
    suffix = data.table::data.table(
      suffix = c("Ltd", "Limited", "PLC", "Inc", "Corp", "LLC"),
      canonical_suffix = c(
        "Limited",
        "Limited",
        "Public Limited Company",
        "Incorporated",
        "Corporation",
        "Limited Liability Company"
      ),
      country = c("UK", "UK", "UK", "US", "US", "US"),
      language = rep("English", 6),
      active = TRUE,
      notes = ""
    ),
    
    alias = data.table::data.table(
      alias = c("IBM", "P&G", "GE"),
      canonical_name = c(
        "International Business Machines",
        "Procter & Gamble",
        "General Electric"
      ),
      source = "template",
      validated = TRUE,
      notes = ""
    ),
    
    company = data.table::data.table(
      company_name = character(),
      canonical_name = character(),
      identifier = character(),
      source = character(),
      validated = logical()
    ),
    
    geography = data.table::data.table(
      original_name = character(),
      standard_name = character(),
      country = character(),
      region = character()
    ),
    
    custom = data.table::data.table(
      original_value = character(),
      standard_value = character(),
      description = character()
    )
  )
  
  output_paths <- list()
  
  for (dictionary_type in names(dictionary_templates)) {
    
    output_paths[[dictionary_type]] <- core_save_dictionary(
      data = dictionary_templates[[dictionary_type]],
      scope = scope,
      type = dictionary_type,
      name = paste0("template_", dictionary_type),
      base_directory = base_directory,
      overwrite = overwrite,
      validate = TRUE
    )
  }
  
  cat("=====================================\n")
  cat("CORE Dictionary Templates Created\n")
  cat("Base directory:", base_directory, "\n")
  cat("Scope:", scope, "\n")
  cat("Templates:\n")
  print(unlist(output_paths))
  cat("=====================================\n")
  
  invisible(output_paths)
}

# Backward-compatible alias
create_dictionary_templates <- core_create_dictionary_templates