
use_rstudio_prefs <- function(...) {
  check_min_rstudio_version("1.3")

  # save lists of existing and updated prefs -----------------------------------
  list_updated_prefs <- list(...)
  list_current_prefs <-
    jsonlite::fromJSON(rstudio_config_path("rstudio-prefs.json"))

  # check each element of list is length one -----------------------------------
  check_prefs_consistency(list_updated_prefs)

  # print updates that will be made --------------------------------------------
  pretty_print_updates(list_current_prefs, list_updated_prefs)
  # ask user to abort or not
  if (interactive() &&
      !startsWith(tolower(readline("Would you like to continue? [y/n]")), "y")) {
    return(invisible(NULL))
  }

  # update prefs, convert to JSON, and save file -------------------------------
  browser()
  list_current_prefs %>%
    purrr::update_list(!!!list_updated_prefs) %>%
    jsonlite::write_json(
      path = rstudio_config_path("rstudio-prefs.json"),
      pretty = TRUE,
      auto_unbox = TRUE
    )

  cli::cli_ul("Restart RStudio for updates to take effect.")
}


