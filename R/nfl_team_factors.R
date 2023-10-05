#' Create Ordered NFL Team Name Factor
#'
#' @param teams A vector of NFL team abbreviations that should be included in
#'   [`valid_team_names()`]. The function tries to clean team names internally
#'   by calling [`nflreadr::clean_team_abbrs()`].
#' @param ... One or more unquoted column names of [`nflreadr::load_teams()`]
#'   to sort by. If empty, the function will sort by division and nick name in
#'   ascending order. This is intended to be used for faceted plots where team
#'   wordmarks are used in strip texts, i.e. `element_nfl_wordmark()`.
#'   See examples for more details.
#'
#' @return Object of class `"factor"`
#' @export
#' @examples
#' \donttest{
#' # unsorted vector including NFL team abbreviations
#' teams <- c("LAC", "LV", "CLE", "BAL", "DEN", "PIT", "CIN", "KC")
#'
#' # defaults to sort by division and nick name in ascending order
#' nfl_team_factor(teams)
#'
#' # can sort by every column in nflreadr::load_teams()
#' nfl_team_factor(teams, team_abbr)
#'
#' # descending order by using base::rev()
#' nfl_team_factor(teams, rev(team_abbr))
#'
#' ######### HOW TO USE IN PRACTICE #########
#'
#' library(ggplot2)
#' library(magrittr)
#' # load some sample data from the ggplot2 package
#' plot_data <- mpg
#' # add a new column by randomly sampling the above defined teams vector
#' plot_data$team <- sample(teams, nrow(mpg), replace = TRUE)
#'
#' # Now we plot the data and facet by team abbreviation. ggplot automatically
#' # converts the team names to a factor and sorts it alphabetically
#' ggplot(plot_data, aes(displ, hwy)) +
#'   geom_point() +
#'   facet_wrap(~team, ncol = 4) +
#'   theme_minimal()
#'
#' # We'll change the order of facets by making another team name column and
#' # converting it to an ordered factor. Again, this defaults to sort by division
#' # and nick name in ascending order.
#' plot_data$ordered_team <- sample(teams, nrow(mpg), replace = TRUE) %>%
#'   nfl_team_factor()
#'
#' # Let's check how the facets are ordered now.
#' ggplot(plot_data, aes(displ, hwy)) +
#'   geom_point() +
#'   facet_wrap(~ordered_team, ncol = 4) +
#'   theme_minimal()
#'
#' # The facet order looks weird because the defaults is meant to be used with
#' # NFL team wordmarks. So let's use the actual wordmarks and look at the result.
#' ggplot(plot_data, aes(displ, hwy)) +
#'   geom_point() +
#'   facet_wrap(~ordered_team, ncol = 4) +
#'   theme_minimal() +
#'   theme(strip.text = element_nfl_wordmark())
#'
#' }
nfl_team_factor <- function(teams, ...){
  # clean the names a bit to make them match the nflreadr team names
  teams <- nflreadr::clean_team_abbrs(teams)
  n_args <- rlang::dots_n(...)

  # load nflreadr teams and make it a data.table
  nfl_teams <- nflreadr::load_teams() %>% data.table::setDT()
  div_split <- data.table::tstrsplit(nfl_teams$team_division, " ")
  nfl_teams$team_division_rev <- paste(div_split[[2]], div_split[[1]])

  # character vector of team names in teams in desired order
  levels <-
    if (n_args == 0L){# default to ascending order of division and nick name
      nfl_teams[team_abbr %in% teams][order(team_division, team_nick)]$team_abbr
    } else {# use supplied order in dots
      nfl_teams[team_abbr %in% teams][order(...)]$team_abbr
    }

  factor(
    x = teams,
    levels = levels,
    ordered = TRUE
  )
}

# silence global variable NOTES
utils::globalVariables(
  names = c("team_abbr", "team_division", "team_nick"),
  package = "nflplotR"
)
