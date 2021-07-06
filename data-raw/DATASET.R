## code to prepare `DATASET` dataset goes here

devtools::load_all(".")
df_rstudio_prefs <-
  fetch_rstudio_prefs()
attr(df_rstudio_prefs, "date") <- Sys.Date()

usethis::use_data(df_rstudio_prefs, overwrite = TRUE, internal = TRUE)
