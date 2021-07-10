# rstudio.prefs

<!-- badges: start -->
[![Codecov test coverage](https://codecov.io/gh/ddsjoberg/rstudio.prefs/branch/main/graph/badge.svg)](https://codecov.io/gh/ddsjoberg/rstudio.prefs?branch=main)
[![R-CMD-check](https://github.com/ddsjoberg/rstudio.prefs/workflows/R-CMD-check/badge.svg)](https://github.com/ddsjoberg/rstudio.prefs/actions)
[![r-universe](https://ddsjoberg.r-universe.dev/badges/rstudio.prefs)](https://ddsjoberg.r-universe.dev/ui#builds)
<!-- [![CRAN status](https://www.r-pkg.org/badges/version/rstudio.prefs)](https://CRAN.R-project.org/package=rstudio.prefs) -->
<!-- badges: end -->

As of RStudio v1.3, the preferences in the Global Options dialog (and a number of other preferences that aren’t) are now saved in simple, plain-text JSON files.
The {rstudio.prefs} package provides an interface for working with these RStudio JSON preference files to easily make modifications without using the point-and-click option menus.
This is particularly helpful when working on teams to ensure a **unified experience** across machines and utilizing settings for **best practices**.

## Installation

You can install {rstudio.prefs} from [GitHub](https://github.com/ddsjoberg/rstudio.prefs) with:

``` r
# install.packages('devtools')
devtools::install_github("ddsjoberg/rstudio.prefs")
```
## Examples

Update the RStudio default preferences.
Full list of modifiable settings here: https://docs.rstudio.com/ide/server-pro/session-user-settings.html

``` r
library(rstudio.prefs)

use_rstudio_prefs(
  always_save_history = FALSE,
  save_workspace = FALSE,
  load_workspace = FALSE,
  rainbow_parentheses = TRUE
)save_workspace
#> - always_save_history   [TRUE   --> FALSE]
#> - save_workspace        [TRUE   --> FALSE]
#> - load_workspace        [TRUE   --> FALSE]
#> - rainbow_parentheses   [FALSE  --> TRUE ]
#> 
#> Would you like to continue? [y/n] y
#> v File 'C:/Users/sjobergd/AppData/Roaming/RStudio/rstudio-prefs 2021-06-20.json' saved as backup.
#> v File 'C:/Users/sjobergd/AppData/Roaming/RStudio/rstudio-prefs.json' updated.
#> * Restart RStudio for updates to take effect.
```

Add secondary repositories to the **ROpenSci** and **ddsjoberg** R-Universes.
This is also helpful for adding secondary RStudio Package Manager repositories.

``` r
use_rstudio_secondary_repo(
  ropensci = "https://ropensci.r-universe.dev",
  ddsjoberg = "https://ddsjoberg.r-universe.dev"
)
#> - ropensci    [*  --> https://ropensci.r-universe.dev ]
#> - ddsjoberg   [*  --> https://ddsjoberg.r-universe.dev]
#> 
#> Would you like to continue? [y/n] y
#> v File 'C:/Users/sjobergd/AppData/Roaming/RStudio/rstudio-prefs 2021-06-20.json' saved as backup.
#> v File 'C:/Users/sjobergd/AppData/Roaming/RStudio/rstudio-prefs.json' updated.
#> * Restart RStudio for updates to take effect.
```

Use `use_rstudio_keyboard_shortcut()` to programmatically add keyboard shortcuts for add-ins.

```r
use_rstudio_keyboard_shortcut(
  "Ctrl+Shift+/" = "starter::make_path_norm"
)
#> - Ctrl+Shift+/   [*  --> starter::make_path_norm]
#> 
#> Would you like to continue? [y/n] y
#> v File 'C:/Users/sjobergd/AppData/Roaming/RStudio/keybindings/addins 2021-06-20.json' saved as backup.
#> v File 'C:/Users/sjobergd/AppData/Roaming/RStudio/keybindings/addins.json' updated.
#> * Restart RStudio for updates to take effect.
```
