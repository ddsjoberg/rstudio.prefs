# rstudio.prefs (development version)

* Fix for `use_rstudio_secondary_repo()` when it is used to set the first secondary repository. (#14)

* Updated `use_rstudio_prefs()` and `use_rstudio_secondary_repo()` to use the {rstudioapi} package to read and write RStudio preferences instead of manually manipulating the preferences JSON file. (#12)

* Corrected the folder location of the app data folder from `RStudio` to `rstudio` on Unix. (#11)

# rstudio.prefs 0.1.8

* Updated URL where RStudio preferences are downloaded from in `fetch_rstudio_prefs()`.

* Updated pretty printing style.

* If no changes will be made, functions are now aborted before saving/backing-up the config files.

# rstudio.prefs 0.1.7

* Exporting utility function `repo_string_as_named_list()`.

* Fixing bug in `use_rstudio_secondary_repo()` where existing secondary repositories could not be deleted (i.e. set to `NULL`).

# rstudio.prefs 0.1.6

* Exporting utility functions `rstudio_config_path()` and `check_min_rstudio_version()`.

* Repositories may now be removed with `use_rstudio_secondary_repo(repo_name = NULL)`.

* Updated documentation for `use_rstudio_secondary_repo()` to indicate when the country will be set to US.

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
