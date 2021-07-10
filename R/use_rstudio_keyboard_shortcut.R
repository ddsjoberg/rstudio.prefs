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
#' @returns NULL, updates RStudio `addins.json` file
#' @author Daniel D. Sjoberg
#'
#' @examples
#' if (interactive()) {
#'   use_rstudio_keyboard_shortcut(
#'     "Ctrl+Shift+/" = "rstudio.prefs::make_path_norm"
#'   )
#' }

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

  # checking inputs ------------------------------------------------------------
  check_shortcut_consistency(i_list_updated_shortcuts)

  # import existing addins -----------------------------------------------------
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
    write_json(
      list_final_shortcuts,
      path = rstudio_config_path("keybindings/addins.json"),
      .backup = .backup
    )

    # adding other files to 'keybindings' folder if they do not exist ----------
    c("keybindings/editor_bindings.json", "keybindings/rstudio_bindings.json") %>%
      purrr::walk(
        function(.x) {
          if (!fs::file_exists(rstudio_config_path(.x))) {
            write_json(NULL, path = rstudio_config_path(.x), .backup = FALSE)
          }
        }
      )
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

check_shortcut_consistency <- function(x) {
  if (!rlang::is_named(x)) {
    stop("Each argument must be named.", call. = FALSE)
  }
  if (purrr::some(x, ~!rlang::is_string(.))) {
    stop("Each argument value must be a string")
  }
  if (purrr::some(x, ~!rlang::is_function(rlang::parse_expr(.)))) {
    stop("Each argument value must be a string of a function name.")
  }
}
