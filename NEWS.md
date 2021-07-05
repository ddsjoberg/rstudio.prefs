# rstudio.prefs 0.1.2

* Updated API for `use_rstudio_keyboard_shortcut()` to use the keyboard shortcut as the named argument and the function that will be executed as the argument value.

* Performing a check that the directory exists before attempting to write JSON file. If directory does not exist, it is created.

* Bug fix for file back-up. If file does not already exist, the back-up attempt is skipped.

# rstudio.prefs 0.1.1

* Bug fix when none of the new preferences are currently listed in the preferences JSON file.

# rstudio.prefs 0.1.0

* First release
