#' Set RStudio Keyboard Shortcuts
#'
#' This function updates the RStudio keyboard shortcuts saved in
#' the `addins.json` file.
#'
#' @param ... series of RStudio keyboard shortcuts to update. The argument
#' name is the keyboard shortcut, and the value is a string of the function
#' name that will execute. See examples.
#' @inheritParams use_rstudio_prefs
#'
#' @export
#' @author Daniel D. Sjoberg
#'
#' @examples
#' \donttest{\dontrun{
#' use_rstudio_keyboard_shortcut(
#'   "Ctrl+Shift+/" = "starter::make_path_norm"
#' )
#' }}

use_rstudio_keyboard_shortcut <- function(..., .write_json = TRUE, .backup = TRUE) {
  # check whether fn may be used -----------------------------------------------
  check_min_rstudio_version("1.3")
  if (!interactive()) {
    "{.code use_rstudio_keyboard_shortcut()} must be run interactively." %>%
      cli::cli_alert_danger()
    return(invisible())
  }

  # save lists of shortcuts to add ---------------------------------------------
  i_list_updated_shortcuts <- rlang::dots_list(...)
  if (!rlang::is_named(i_list_updated_shortcuts)) {
    stop("Each argument must be named.", call. = FALSE)
  }

  # import existing addings ----------------------------------------------------
  if (!fs::dir_exists(rstudio_config_path("keybindings"))) {
    fs::dir_create(rstudio_config_path("keybindings"))
  }
  list_current_shortcuts <-
    switch(fs::file_exists(rstudio_config_path("keybindings/addins.json")),
      jsonlite::fromJSON(rstudio_config_path("keybindings/addins.json"))
    ) %||%
    list()

  # invert list names and values -----------------------------------------------
  i_list_current_shortcuts <- invert_list_names_and_values(list_current_shortcuts)

  # print updates that will be made --------------------------------------------
  pretty_print_updates(i_list_current_shortcuts, i_list_updated_shortcuts)
  # ask user to abort or not
  if (!startsWith(tolower(readline("Would you like to continue? [y/n] ")), "y")) {
    return(invisible(NULL))
  }

  # update prefs, convert to JSON, and save file -------------------------------
  list_final_shortcuts <-
    i_list_current_shortcuts %>%
    purrr::update_list(!!!i_list_updated_shortcuts) %>%
    invert_list_names_and_values()

  if (isTRUE(.write_json)) {
    backup_file(rstudio_config_path("keybindings/addins.json"))
    write_json(
      list_final_shortcuts,
      path = rstudio_config_path("keybindings/addins.json")
    )

    # adding other files to 'keybindings' folder if they do not exist ------------
    c("keybindings/editor_bindings.json", "keybindings/rstudio_bindings.json") %>%
      purrr::walk(
        function(.x) {
          if (!fs::file_exists(rstudio_config_path(.x))) {
            write_json(NULL, path = rstudio_config_path(.x))
          }
        }
      )

    cli::cli_alert_success("File {.val {rstudio_config_path('keybindings/addins.json')}} updated.")
    cli::cli_ul("Restart RStudio for updates to take effect.")
    return(invisible(NULL))
  }
  else {
    return(list_final_shortcuts)
  }
}


#' Invert list names and values
#'
#' Takes a named list, and returns a named list with the names and values
#' have been switched.
#' @param x named list
#'
#' @return
#' @keywords internal
#' @noRd
invert_list_names_and_values <- function(x) {
  if (rlang::is_empty(x)) return(x)
  names(x) %>% as.list() %>% stats::setNames(unlist(x))
}
