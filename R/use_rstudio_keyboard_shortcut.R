#' Set RStudio Keyboard Shortcuts
#'
#' This function updates the RStudio keyboard shortcuts saved in
#' the `addins.json` file.
#'
#' @param ... series of RStudio keyboard shortcuts to update
#' @inheritParams use_rstudio_prefs
#'
#' @export
#' @author Daniel D. Sjoberg
#'
#' @examples
#' \donttest{\dontrun{
#' use_rstudio_keyboard_shortcut(
#'   `mskRutils::make_path_norm` = "Ctrl+Shift+/"
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
  list_updated_shortcuts <- rlang::dots_list(...)

  # import existing addings ----------------------------------------------------
  if (!fs::dir_exists(rstudio_config_path("keybindings"))) {
    fs::dir_create(rstudio_config_path("keybindings"))
  }
  list_current_shortcuts <-
    switch(fs::file_exists(rstudio_config_path("keybindings/addins.json")),
      jsonlite::fromJSON(rstudio_config_path("keybindings/addins.json"))
    ) %||%
    list()

  # print updates that will be made --------------------------------------------
  pretty_print_updates(list_current_shortcuts, list_updated_shortcuts)
  # ask user to abort or not
  if (!startsWith(tolower(readline("Would you like to continue? [y/n] ")), "y")) {
    return(invisible(NULL))
  }

  # update prefs, convert to JSON, and save file -------------------------------
  list_final_shortcuts <-
    list_current_shortcuts %>%
    purrr::update_list(!!!list_updated_shortcuts)

  if (isTRUE(.write_json)) {
    backup_file(rstudio_config_path("keybindings/addins.json"))
    jsonlite::write_json(
      list_final_shortcuts,
      path = rstudio_config_path("keybindings/addins.json"),
      pretty = TRUE,
      auto_unbox = TRUE
    )

    # adding other files to 'keybindings' folder if they do not exist ------------
    if (!fs::file_exists(rstudio_config_path("keybindings/editor_bindings.json"))) {
      jsonlite::write_json(
        NULL,
        path = rstudio_config_path("keybindings/editor_bindings.json"),
        pretty = TRUE,
        auto_unbox = TRUE
      )
    }
    if (!fs::file_exists(rstudio_config_path("keybindings/rstudio_bindings.json"))) {
      jsonlite::write_json(
        NULL,
        path = rstudio_config_path("keybindings/rstudio_bindings.json"),
        pretty = TRUE,
        auto_unbox = TRUE
      )
    }
    cli::cli_alert_success("File {.val {rstudio_config_path('keybindings/addins.json')}} updated.")
    cli::cli_ul("Restart RStudio for updates to take effect.")
    return(invisible(NULL))
  }
  else {
    return(list_final_shortcuts)
  }
}
