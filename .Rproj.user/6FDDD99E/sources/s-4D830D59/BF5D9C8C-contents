#' Fetch table of RStudio Settings
#'
#' Settings are fetched from
#' https://docs.rstudio.com/ide/server-pro/session-user-settings.html
#'
#' @return tibble
#' @export
#'
#' @examples
#'
#' fetch_rstudio_settings_table()

fetch_rstudio_settings_table <- function() {
  url <- "https://docs.rstudio.com/ide/server-pro/session-user-settings.html"
  tryCatch(
    url %>%
      rvest::read_html() %>%
      rvest::html_nodes("table") %>%
      rvest::html_table(fill = TRUE) %>%
      purrr::pluck(1) %>%
      dplyr::mutate(
        r_type =
          dplyr::case_when(
            .data$Type %in% "boolean" ~ "logical",
            .data$Type %in% "integer" ~ "integer",
            .data$Type %in% "number" ~ "numeric",
            startsWith(.data$Type, "string") ~ "character"
          )
      ) %>%
      # nto sure how to deal with the other types, so ignoring
      dplyr::filter(!is.na(.data$r_type)),
    error = function(e) {
      paste("Error downloading most recent RStudio settings",
            "from {.field {url}}") %>%
      cli::cli_alert_danger()
      paste("Using settings downloaded",
            "{.val {as.character(attr(df_rstudio_settings_table, 'date'))}}") %>%
      cli::cli_alert_success()
      df_rstudio_settings_table
    }
  )
}
