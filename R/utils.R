#' Check Min RStudio Version
#'
#' Return error if minimum version requirement not met.
#'
#' @param version string of min required version number
#' @keywords internal
#' @noRd
check_min_rstudio_version <- function(version) {
  if (rstudioapi::getVersion() < version) {
    paste("RStudio version", version, "or greater required.") %>%
      rlang::abort()
  }
}

#' RStudio Config Path
#'
#' Copy of the internal function `usethis:::rstudio_config_path()`
#'
#' @param ... strings added to the RStduio config path
#'
#' @return string path
#' @keywords internal
#' @noRd
rstudio_config_path <- function(...) {
  if (is_windows()) {
    base <- rappdirs::user_config_dir("RStudio", appauthor = NULL)
  }
  else {
    base <- rappdirs::user_config_dir("RStudio", os = "unix")
  }
  fs::path(base, ...)
}

#' Is OS Windows?
#'
#' Copy of the internal function `usethis:::is_windows()`
#'
#' @param ... no used
#'
#' @return logical
#' @keywords internal
#' @noRd
is_windows <- function(...) {
  .Platform$OS.type == "windows"
}


#' Check Validity of User-passed Preferences
#'
#'  Function performs some checks of the user inputs, e.g. the name of the
#'  preference is checked against the table from
#'  `fetch_rstudio_settings_table()`...if name is not found a warning
#'  message is printed. The type/class of the input is also checked against
#'  the expected class (again taken from `fetch_rstudio_settings_table()`)
#'
#' @param x list of user-passed preferences to update/modify
#' @noRd
check_prefs_consistency <- function(x) {
  # first grab df of all prefs
  df_all_prefs <- fetch_rstudio_settings_table()

  # check for prefs not listed -------------------------------------------------
  bad_pref_names <- names(x) %>% setdiff(df_all_prefs$Property)
  if (length(bad_pref_names) > 0L) {
    paste(
      "{.val {paste(bad_pref_names, sep = ', ')}}",
      "may not be valid RStudio preference names.",
      "Proceed with caution."
    ) %>%
      cli::cli_alert_danger()
  }

  # check passed types ---------------------------------------------------------
  purrr::iwalk(
    x,
    function(.x, .y) {
      pref_def_list <-
        df_all_prefs %>%
        dplyr::filter(.data$Property %in% .y) %>%
        as.list()

      # if pref is not found in table, move on to the next checks
      if (rlang::is_empty(pref_def_list$Property)) {
        return(invisible(NULL))
      }

      # checking passed arguments against expected types
      if (pref_def_list$r_type %in% "logical" && !rlang::is_logical(.x)) {
        paste("Expecting {.field {.y}} to be type {.val logical}, but it is not.",
              "Proceed with caution.") %>%
          cli::cli_alert_danger()
      }
      else if (pref_def_list$r_type %in% "character" && !rlang::is_character(.x)) {
        paste("Expecting {.field {.y}} to be type {.val character}, but it is not.",
              "Proceed with caution.") %>%
          cli::cli_alert_danger()
      }
      else if (pref_def_list$r_type %in% "integer" && !rlang::is_integer(.x)) {
        paste("Expecting {.field {.y}} to be type {.val integer}, but it is not.",
              "Proceed with caution.") %>%
          cli::cli_alert_danger()
      }
      else if (pref_def_list$r_type %in% "numeric" && !is.numeric(.x)) {
        paste("Expecting {.field {.y}} to be type {.val numeric}, but it is not.",
              "Proceed with caution.") %>%
          cli::cli_alert_danger()
      }
    }
  )

  invisible(NULL)
}


#' Create a back-up copy of a file
#'
#' Function copies the file, and adds today's date to the end of the file name.
#'
#' @param file path and file location.
#' @param quiet logical
#' @noRd
backup_file <- function(file, quiet = FALSE) {
  path_dir <- fs::path_dir(file)
  path_ext <- paste0(".", fs::path_ext(file))
  new_file_name <-
    fs::path_file(file) %>% {
      gsub(
        pattern = path_ext,
        replacement = paste0(" ", Sys.Date(), path_ext),
        x = .,
        fixed = TRUE
      )
    }

  if (fs::file_exists(fs::path(path_dir, new_file_name))) {
    if (!quiet) {
      paste(
        "Aboring backup;",
        "file {.val {fs::path(path_dir, new_file_name)}} already exists."
      ) %>%
        cli::cli_alert_danger()
    }
    return(invisible(NULL))
  }

  fs::file_copy(
    path = file,
    new_path = fs::path(path_dir, new_file_name),
    overwrite = FALSE
  )
  if (!quiet) {
    cli::cli_alert_success("File {.val {fs::path(path_dir, new_file_name)}} saved as backup.")
  }
}
