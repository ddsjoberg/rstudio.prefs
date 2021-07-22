# rstudio.prefs 0.1.5

* Updates to documentation.

* Improved error messaging.

* Added additional unit tests.

* Removed type 'array' from `fetch_rstudio_prefs()`. This type needs further testing before it's rolled out. Users can still pass array updates, but they will see a note about proceeding with caution.

* Updates to the way the preferences are printed to the console before being written to file.

* Updates to the consistency checks in `use_rstudio_keyboard_shortcut()`.

# rstudio.prefs 0.1.4

* Added RStudio add-in function `make_path_norm()`.

* Documentation updates and tidying up for CRAN release.

# rstudio.prefs 0.1.3

* Function `fetch_rstudio_settings_table()` has been renamed to `fetch_rstudio_prefs()`. The function now returns tibble with lowercase column names and a `is_scalar` column has been added indicating whether the preference setting should be length one.

# rstudio.prefs 0.1.2

* Updated API for `use_rstudio_keyboard_shortcut()` to use the keyboard shortcut as the named argument and the function that will be executed as the argument value.

* Performing a check that the directory exists before attempting to write JSON file. If directory does not exist, it is created.

* Bug fix for file back-up. If file does not already exist, the back-up attempt is skipped.

# rstudio.prefs 0.1.1

* Bug fix when none of the new preferences are currently listed in the preferences JSON file.

# rstudio.prefs 0.1.0

* First release
