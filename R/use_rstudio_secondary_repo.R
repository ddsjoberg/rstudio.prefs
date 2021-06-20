#' Set RStudio Secondary Repository
#'
#' This function updates the RStudio preferences saved in
#' the `rstudio-prefs.json` file to include the secondary repositories
#' passed my the user. If a new name for an existing repository is
#' passed by the user, the name will be updated in the JSON file.
#'
#' @param ... series of secondary repositories
#' `ropensci = "https://ropensci.r-universe.dev"`
#' @inheritParams use_rstudio_prefs
#'
#' @export
#' @author Daniel D. Sjoberg
#'
#' @examples
#' \donttest{\dontrun{
#' use_rstudio_secondary_repo(
#'   ropensci = "https://ropensci.r-universe.dev"
#' )
#' }}

use_rstudio_secondary_repo <- function(..., write_json = TRUE) {
  # check whether fn may be used -----------------------------------------------
  check_min_rstudio_version("1.3")
  if (!interactive()) {
    "{.code use_rstudio_secondary_repo()} must be run interactively." %>%
      cli::cli_alert_danger()
    return(invisible())
  }

  # save lists of existing and updated prefs -----------------------------------
  user_passed_updated_repos <- rlang::dots_list(...)
  list_current_prefs <-
    jsonlite::fromJSON(rstudio_config_path("rstudio-prefs.json"))

  # if no secondary repos exist, create the structure for them -----------------
  if (is.null(list_current_prefs$cran_mirror)) {
    current_repos <- list()
    # i took these values from my own settings...may need to be modfied for broader use
    list_current_prefs$cran_mirror <-
      list("name" = "Global (CDN)",
           "host" = "RStudio",
           "url" = "https://cran.rstudio.com/",
           "repos" = "",
           "country" = "us",
           "secondary" = NULL)
  }
  # parse the secondary repo string --------------------------------------------
  current_repos <-
    repo_string_as_named_list(list_current_prefs$cran_mirror$secondary)

  # if one of the new repos has the same value but new name as a previous
  # then add a new NULL value to the updates list
  user_passed_updated_repos <-
    current_repos[unlist(current_repos) %in% unlist(user_passed_updated_repos)] %>%
    purrr::map(~NULL) %>%
    purrr::update_list(!!!user_passed_updated_repos)

  # print updates that will be made --------------------------------------------
  pretty_print_updates(current_repos, user_passed_updated_repos)
  # ask user to abort or not
  if (!startsWith(tolower(readline("Would you like to continue? [y/n] ")), "y")) {
    return(invisible(NULL))
  }

  # create final list of repos -------------------------------------------------
  list_current_prefs$cran_mirror$secondary <-
    current_repos %>%
    purrr::update_list(!!!user_passed_updated_repos) %>%
    purrr::imap_chr(~paste0(.y, "|", .x)) %>%
    paste(collapse = "|")

  # write updated JSON file ----------------------------------------------------
  if (isTRUE(write_json)) {
    jsonlite::write_json(
      list_current_prefs,
      path = rstudio_config_path("rstudio-prefs.json"),
      pretty = TRUE,
      auto_unbox = TRUE
    )
    cli::cli_ul("Restart RStudio for updates to take effect.")
    return(invisible(NULL))
  }
  else {
    return(list_current_prefs)
  }
}


repo_string_as_named_list <- function(x) {
  if (is.null(x)) return(list())
  # split string by |
  xx <- strsplit(x, "|", fixed = TRUE) %>% unlist()

  # use every other element as the value and the name and return as list
  xx[!seq_len(length(xx)) %% 2] %>%
    stats::setNames(xx[seq_len(length(xx)) %% 2]) %>%
    as.list()
}
