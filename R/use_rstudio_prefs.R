#' Set RStudio Preferences
#'
#' This function updates the RStudio preferences saved in
#' the `rstudio-prefs.json` file. A full listing of preferences that may be
#' modified are listed here
#' https://docs.rstudio.com/ide/server-pro/session-user-settings.html
#'
#' @param ... series of RStudio preferences to update, e.g.
#' `always_save_history = FALSE, rainbow_parentheses = TRUE`
#' @param .write_json logical indicating whether to update and overwrite
#' the existing JSON file of options. Default is `TRUE`. When `FALSE`,
#' the function will return a list of all options, instead of writing
#' them to file.
#' @param .backup logical indicating whether to create a back-up of preferences
#' file before it's updated. Default is `TRUE`
#'
#' @export
#' @returns NULL, updates RStudio `rstudio-prefs.json` file
#' @author Daniel D. Sjoberg
#'
#' @examples
#' if (interactive()) {
#'   # pass preferences individually --------------
#'   use_rstudio_prefs(
#'     always_save_history = FALSE,
#'     rainbow_parentheses = TRUE
#'   )
#'
#'   # pass a list of preferences -----------------
#'   pref_list <-
#'     list(always_save_history = FALSE,
#'          rainbow_parentheses = TRUE)
#'
#'   use_rstudio_prefs(!!!pref_list)
#' }

use_rstudio_prefs <- function(..., .write_json = TRUE, .backup = TRUE) {
  # check whether fn may be used -----------------------------------------------
  check_min_rstudio_version("1.3")
  if (!interactive()) {
    "{.code use_rstudio_prefs()} must be run interactively." %>%
      cli::cli_alert_danger()
    return(invisible())
  }

  # save lists of existing and updated prefs -----------------------------------
  list_updated_prefs <- rlang::dots_list(...)
  if (!rlang::is_named(list_updated_prefs)) {
    stop("Each argument must be named.")
  }

  list_current_prefs <-
    jsonlite::fromJSON(rstudio_config_path("rstudio-prefs.json"))

  # check each element of list is length one -----------------------------------
  check_prefs_consistency(list_updated_prefs)

  # print updates that will be made --------------------------------------------
  pretty_print_updates(list_current_prefs, list_updated_prefs)
  # ask user to abort or not
  if (!startsWith(tolower(readline("Would you like to continue? [y/n] ")), "y")) {
    return(invisible(NULL))
  }

  # update prefs, convert to JSON, and save file -------------------------------
  final_prefs <-
    list_current_prefs %>%
    purrr::update_list(!!!list_updated_prefs)

  if (isTRUE(.write_json)) {
    write_json(
      final_prefs,
      path = rstudio_config_path("rstudio-prefs.json"),
      .backup = .backup
    )
    return(invisible(NULL))
  }
  else {
    return(final_prefs)
  }
}


