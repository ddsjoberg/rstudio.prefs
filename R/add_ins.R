#' Normalize Path Add-in
#'
#' Wrapper to execute [fs::path_norm()] as a shortcut on
#' highlighted text. The updated text will be converted in place to a path
#' normalized for the environment currently in use.
#' For instance, \ or \\\ will be converted to / on Windows machines.
#' See below for process of setting shortcut.
#' @details
#' Add keyboard shortcut for `make_path_norm()` in RStudio, use the
#' `use_rstudio_keyboard_shortcut()` function. Do add it manually,
#' follow the instructions below.
#' * Install rstudio.prefs, and restart RStudio
#' * Select "Tools" --> "Modify Keyboard Shortcuts...".
#' * In Search box, type "Make Path Normal".
#' * Click in the "Shortcut" column on the "Make Path Normal" row.
#' * Press intended shortcut keys (suggested: `Ctrl+Shift+/`) to set shortcut.
#' * NOTE: It is possible to override a previously specified key combination with this selection.
#' @seealso [fs::path_norm]
#' @export
#' @returns normalized path string
#' @examples
#' if (interactive()) {
#'   # set a keyboard shortcut for path normalization
#'   rstudio.prefs::use_rstudio_keyboard_shortcut(
#'     "Ctrl+Shift+/" = "rstudio.prefs::make_path_norm"
#'   )
#' }
make_path_norm <- function() {
  context <- rstudioapi::getActiveDocumentContext()
  for (con in rev(context$selection))
    rstudioapi::modifyRange(con$range,
                            fs::path_norm(con$text) %>%
                              {ifelse(. == ".", "", .)},
                            context$id)
}

