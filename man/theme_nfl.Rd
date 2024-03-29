% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/theme_nfl.R
\name{theme_nfl}
\alias{theme_x_nfl}
\alias{theme_y_nfl}
\title{Theme for NFL Team Logos}
\usage{
theme_x_nfl()

theme_y_nfl()
}
\value{
A ggplot2 theme created with \code{\link[ggplot2:theme]{ggplot2::theme()}}.
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#deprecated}{\figure{lifecycle-deprecated.svg}{options: alt='[Deprecated]'}}}{\strong{[Deprecated]}}

These functions are convenience wrappers around a theme call
that activates markdown in x-axis and y-axis labels
using \code{\link[ggtext:element_markdown]{ggtext::element_markdown()}}.
}
\details{
These functions are a wrapper around the function calls
\code{ggplot2::theme(axis.text.x = ggtext::element_markdown())} as well as
\code{ggplot2::theme(axis.text.y = ggtext::element_markdown())}.
They are made to be used in conjunction with \code{\link[=scale_x_nfl]{scale_x_nfl()}} and
\code{\link[=scale_y_nfl]{scale_y_nfl()}} respectively.
}
\examples{
\donttest{
library(nflplotR)
library(ggplot2)

team_abbr <- valid_team_names()
# remove conference logos from this example
team_abbr <- team_abbr[!team_abbr \%in\% c("AFC", "NFC", "NFL")]

df <- data.frame(
  random_value = runif(length(team_abbr), 0, 1),
  teams = team_abbr
)
if (utils::packageVersion("gridtext") > "0.1.4"){
  ggplot(df, aes(x = teams, y = random_value)) +
    geom_col(aes(color = teams, fill = teams), width = 0.5) +
    scale_color_nfl(type = "secondary") +
    scale_fill_nfl(alpha = 0.4) +
    scale_x_nfl() +
    theme_minimal() +
    # theme_*_nfl requires gridtext version > 0.1.4
    theme_x_nfl()
}
}
}
\seealso{
\code{\link[=theme_x_nfl]{theme_x_nfl()}}, \code{\link[=theme_y_nfl]{theme_y_nfl()}}
}
\keyword{internal}
