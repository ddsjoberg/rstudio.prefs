pretty_print_updates <- function(old, new) {
  # create data frame with old and new preferences -----------------------------
  df_updates <-
    # data frame of old prefs
    tibble::tibble(
      pref = names(old) %>% intersect(names(new)),
      old_value = old[names(new)] %>% unname() %>% lapply(as.character) %>% unlist()
    ) %>%
    dplyr::full_join(
      # data frame of new prefs
      tibble::tibble(
        pref = names(new),
        new_value = new  %>% unname() %>% lapply(as.character) %>% unlist()
      ),
      by = "pref"
    ) %>%
    dplyr::mutate(
      old_value = ifelse(is.na(.data$old_value), "*", .data$old_value),
      new_value = ifelse(is.na(.data$new_value), "*", .data$new_value)
    )

  # pad each column with trailing spaces ---------------------------------------
  length_total <- df_updates %>% lapply(function(x) nchar(x) %>% max())
  length_total[["pref"]] <- length_total[["pref"]] + 3
  length_total[["old_value"]] <- length_total[["old_value"]] + 1
  for (i in seq_len(nrow(df_updates))) {
    for (col in names(df_updates)) {
      df_updates[i, col] <-
        paste0(
          df_updates[i, col],
          rep_len(" ", length_total[[col]] - nchar(df_updates[i, col])) %>%
            paste(collapse = "")
        )
    }
  }

  # print updates --------------------------------------------------------------
  df_updates %>%
    dplyr::mutate(message = paste0("- ",
                                   .data$pref, "[",
                                   .data$old_value, " --> ",
                                   .data$new_value,
                                   "]")) %>%
    dplyr::pull(.data$message) %>%
    paste(collapse = "\n") %>%
    cat()
}

# # CRAN ===============================
# - R6            [* -> 2.5.0]
# - Rcpp          [* -> 1.0.6]
# - askpass       [* -> 1.1]
# - base64enc     [* -> 0.1-3]
# - brew          [* -> 1.0-6]





