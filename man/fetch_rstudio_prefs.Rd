% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fetch_rstudio_prefs.R
\name{fetch_rstudio_prefs}
\alias{fetch_rstudio_prefs}
\title{Fetch table of RStudio Preferences}
\usage{
fetch_rstudio_prefs()
}
\value{
tibble
}
\description{
Preferences are fetched from
\url{https://docs.rstudio.com/ide/server-pro/session-user-settings.html}
}
\section{Details}{

Only preferences of type \code{"boolean"}, \code{"string"}, \code{"number"}, \code{"integer"},
and \code{"array"}
are fetched from the table.
TODO: Research how type \code{"object"} are passed and include
in the fetched preferences table.
}

\examples{

fetch_rstudio_prefs()
}
