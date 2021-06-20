## code to prepare `DATASET` dataset goes here

df_rstudio_settings_table <-
  fetch_rstudio_settings_table()
attr(df_rstudio_settings_table, "date") <- Sys.Date()

usethis::use_data(df_rstudio_settings_table, overwrite = TRUE, internal = TRUE)
