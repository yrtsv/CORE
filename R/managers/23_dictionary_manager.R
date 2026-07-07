# ============================================================
# CORE - Corporate Entity Resolution Engine
#
# Module : 23_dictionary_manager.R
# Purpose: Manage CORE dictionary resources
# Version: 1.0.0
# ============================================================

core_dictionary_scopes <- function() {
  c("core", "project", "community")
}

core_dictionary_types <- function() {
  c("suffix", "alias", "company", "geography", "custom")
}

core_dictionary_schema <- function(type) {
  
  core_validate_dictionary_type(type)
  
  schemas <- list(
    suffix = c(
      "suffix",
      "canonical_suffix",
      "country",
      "language",
      "active",
      "notes"
    ),
    alias = c(
      "alias",
      "canonical_name",
      "source",
      "validated",
      "notes"
    ),
    company = c(
      "company_name",
      "canonical_name",
      "identifier",
      "source",
      "validated"
    ),
    geography = c(
      "original_name",
      "standard_name",
      "country",
      "region"
    ),
    custom = c(
      "original_value",
      "standard_value",
      "description"
    )
  )
  
  schemas[[type]]
}

core_normalise_dictionary_file_name <- function(name) {
  
  if (is.null(name) || length(name) != 1 || is.na(name) || name == "") {
    stop("Dictionary name must be a non-empty character value.")
  }
  
  if (!grepl("\\.csv$", name, ignore.case = TRUE)) {
    name <- paste0(name, ".csv")
  }
  
  name
}

core_validate_dictionary_scope <- function(scope) {
  
  valid_scopes <- core_dictionary_scopes()
  
  if (!scope %in% valid_scopes) {
    stop(
      "Unsupported dictionary scope: ",
      scope,
      ". Supported scopes are: ",
      paste(valid_scopes, collapse = ", ")
    )
  }
  
  invisible(TRUE)
}

core_validate_dictionary_type <- function(type) {
  
  valid_types <- core_dictionary_types()
  
  if (!type %in% valid_types) {
    stop(
      "Unsupported dictionary type: ",
      type,
      ". Supported types are: ",
      paste(valid_types, collapse = ", ")
    )
  }
  
  invisible(TRUE)
}

core_dictionary_directory <- function(scope = "core",
                                      type = "suffix",
                                      base_directory = "inst/dictionaries") {
  
  core_validate_dictionary_scope(scope)
  core_validate_dictionary_type(type)
  
  file.path(base_directory, scope, type)
}

core_dictionary_path <- function(scope = "core",
                                 type = "suffix",
                                 name,
                                 base_directory = "inst/dictionaries") {
  
  file.path(
    core_dictionary_directory(
      scope = scope,
      type = type,
      base_directory = base_directory
    ),
    core_normalise_dictionary_file_name(name)
  )
}

core_dictionary_info <- function(scope = "core",
                                 type = "suffix",
                                 name,
                                 base_directory = "inst/dictionaries") {
  
  dictionary_directory <- core_dictionary_directory(
    scope = scope,
    type = type,
    base_directory = base_directory
  )
  
  dictionary_file <- core_dictionary_path(
    scope = scope,
    type = type,
    name = name,
    base_directory = base_directory
  )
  
  list(
    scope = scope,
    type = type,
    name = core_normalise_dictionary_file_name(name),
    directory = dictionary_directory,
    path = dictionary_file,
    directory_exists = dir.exists(dictionary_directory),
    file_exists = file.exists(dictionary_file)
  )
}

core_list_dictionaries <- function(base_directory = "inst/dictionaries") {
  
  if (!dir.exists(base_directory)) {
    stop("Dictionary directory not found: ", base_directory)
  }
  
  dictionary_files <- list.files(
    path = base_directory,
    pattern = "\\.csv$",
    recursive = TRUE,
    full.names = TRUE
  )
  
  if (length(dictionary_files) == 0) {
    return(
      data.table::data.table(
        scope = character(),
        type = character(),
        name = character(),
        file_path = character()
      )
    )
  }
  
  base_normalised <- normalizePath(base_directory, winslash = "/", mustWork = TRUE)
  files_normalised <- normalizePath(dictionary_files, winslash = "/", mustWork = TRUE)
  
  relative_paths <- sub(
    paste0("^", base_normalised, "/"),
    "",
    files_normalised
  )
  
  path_parts <- strsplit(relative_paths, "/")
  
  result <- data.table::rbindlist(
    lapply(
      seq_along(path_parts),
      function(i) {
        parts <- path_parts[[i]]
        
        data.table::data.table(
          scope = ifelse(length(parts) >= 3, parts[1], NA_character_),
          type = ifelse(length(parts) >= 3, parts[2], NA_character_),
          name = basename(dictionary_files[i]),
          file_path = dictionary_files[i]
        )
      }
    ),
    fill = TRUE
  )
  
  result[
    scope %in% core_dictionary_scopes() &
      type %in% core_dictionary_types()
  ][]
}

core_validate_dictionary <- function(data, type) {
  
  if (!data.table::is.data.table(data)) {
    data <- data.table::as.data.table(data)
  }
  
  required_columns <- core_dictionary_schema(type)
  missing_columns <- setdiff(required_columns, names(data))
  
  list(
    type = type,
    valid = length(missing_columns) == 0,
    required_columns = required_columns,
    missing_columns = missing_columns,
    available_columns = names(data)
  )
}

core_load_dictionary <- function(scope = "core",
                                 type = "suffix",
                                 name = NULL,
                                 base_directory = "inst/dictionaries",
                                 validate = TRUE,
                                 combine = TRUE) {
  
  dictionary_directory <- core_dictionary_directory(
    scope = scope,
    type = type,
    base_directory = base_directory
  )
  
  if (!dir.exists(dictionary_directory)) {
    stop("Dictionary directory not found: ", dictionary_directory)
  }
  
  if (is.null(name)) {
    
    dictionary_files <- list.files(
      dictionary_directory,
      pattern = "\\.csv$",
      full.names = TRUE
    )
    
    if (length(dictionary_files) == 0) {
      stop("No CSV dictionary files found in: ", dictionary_directory)
    }
    
  } else {
    
    dictionary_files <- core_dictionary_path(
      scope = scope,
      type = type,
      name = name,
      base_directory = base_directory
    )
    
    if (!file.exists(dictionary_files)) {
      stop("Dictionary file not found: ", dictionary_files)
    }
  }
  
  dictionary_list <- lapply(
    dictionary_files,
    function(dictionary_file) {
      
      dictionary_data <- data.table::fread(
        dictionary_file,
        na.strings = c("", "NA")
      )
      
      dictionary_data <- data.table::as.data.table(dictionary_data)
      
      dictionary_data[, dictionary_scope := scope]
      dictionary_data[, dictionary_type := type]
      dictionary_data[, dictionary_file := basename(dictionary_file)]
      
      if (isTRUE(validate)) {
        validation <- core_validate_dictionary(
          data = dictionary_data,
          type = type
        )
        
        if (!isTRUE(validation$valid)) {
          stop(
            "Dictionary validation failed for ",
            dictionary_file,
            ". Missing columns: ",
            paste(validation$missing_columns, collapse = ", ")
          )
        }
      }
      
      dictionary_data
    }
  )
  
  if (isTRUE(combine)) {
    return(data.table::rbindlist(dictionary_list, fill = TRUE))
  }
  
  dictionary_list
}

core_save_dictionary <- function(data,
                                 scope = "project",
                                 type = "custom",
                                 name,
                                 base_directory = "inst/dictionaries",
                                 overwrite = FALSE,
                                 validate = TRUE) {
  
  core_validate_dictionary_scope(scope)
  core_validate_dictionary_type(type)
  
  if (!data.table::is.data.table(data)) {
    data <- data.table::as.data.table(data)
  }
  
  if (isTRUE(validate)) {
    validation <- core_validate_dictionary(
      data = data,
      type = type
    )
    
    if (!isTRUE(validation$valid)) {
      stop(
        "Dictionary validation failed. Missing columns: ",
        paste(validation$missing_columns, collapse = ", ")
      )
    }
  }
  
  dictionary_directory <- core_dictionary_directory(
    scope = scope,
    type = type,
    base_directory = base_directory
  )
  
  if (!dir.exists(dictionary_directory)) {
    dir.create(dictionary_directory, recursive = TRUE)
  }
  
  dictionary_file <- core_dictionary_path(
    scope = scope,
    type = type,
    name = name,
    base_directory = base_directory
  )
  
  if (file.exists(dictionary_file) && !isTRUE(overwrite)) {
    stop(
      "Dictionary file already exists: ",
      dictionary_file,
      ". Use overwrite = TRUE to replace it."
    )
  }
  
  data.table::fwrite(
    data,
    file = dictionary_file,
    quote = TRUE,
    na = ""
  )
  
  invisible(dictionary_file)
}

core_register_dictionary <- function(source_file,
                                     scope = "project",
                                     type = "custom",
                                     name = NULL,
                                     base_directory = "inst/dictionaries",
                                     overwrite = FALSE,
                                     validate = TRUE) {
  
  if (!file.exists(source_file)) {
    stop("Source dictionary file not found: ", source_file)
  }
  
  if (is.null(name)) {
    name <- basename(source_file)
  }
  
  dictionary_data <- data.table::fread(
    source_file,
    na.strings = c("", "NA")
  )
  
  saved_path <- core_save_dictionary(
    data = dictionary_data,
    scope = scope,
    type = type,
    name = name,
    base_directory = base_directory,
    overwrite = overwrite,
    validate = validate
  )
  
  invisible(saved_path)
}

core_remove_dictionary <- function(scope = "project",
                                   type = "custom",
                                   name,
                                   base_directory = "inst/dictionaries",
                                   confirm = FALSE) {
  
  if (!isTRUE(confirm)) {
    stop(
      "Dictionary removal requires confirm = TRUE. ",
      "This protects against accidental deletion."
    )
  }
  
  dictionary_file <- core_dictionary_path(
    scope = scope,
    type = type,
    name = name,
    base_directory = base_directory
  )
  
  if (!file.exists(dictionary_file)) {
    stop("Dictionary file not found: ", dictionary_file)
  }
  
  file.remove(dictionary_file)
}