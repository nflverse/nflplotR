# Create Ordered NFL Team Name Factor

Create Ordered NFL Team Name Factor

## Usage

``` r
nfl_team_factor(teams, ...)
```

## Arguments

- teams:

  A vector of NFL team abbreviations that should be included in
  [`valid_team_names()`](https://nflplotr.nflverse.com/reference/valid_team_names.md).
  The function tries to clean team names internally by calling
  [`nflreadr::clean_team_abbrs()`](https://nflreadr.nflverse.com/reference/clean_team_abbrs.html).

- ...:

  One or more unquoted column names of
  [`nflreadr::load_teams()`](https://nflreadr.nflverse.com/reference/load_teams.html)
  to sort by. If empty, the function will sort by division and nick name
  in ascending order. This is intended to be used for faceted plots
  where team wordmarks are used in strip texts, i.e.
  [`element_nfl_wordmark()`](https://nflplotr.nflverse.com/reference/element.md).
  See examples for more details.

## Value

Object of class `"factor"`

## Examples

``` r
# \donttest{
# unsorted vector including NFL team abbreviations
teams <- c("LAC", "LV", "CLE", "BAL", "DEN", "PIT", "CIN", "KC")

# defaults to sort by division and nick name in ascending order
nfl_team_factor(teams)
#> [1] LAC LV  CLE BAL DEN PIT CIN KC 
#> Levels: CIN < CLE < BAL < PIT < DEN < LAC < KC < LV

# can sort by every column in nflreadr::load_teams()
nfl_team_factor(teams, team_abbr)
#> [1] LAC LV  CLE BAL DEN PIT CIN KC 
#> Levels: BAL < CIN < CLE < DEN < KC < LAC < LV < PIT

# descending order by using base::rev()
nfl_team_factor(teams, rev(team_abbr))
#> [1] LAC LV  CLE BAL DEN PIT CIN KC 
#> Levels: PIT < LV < LAC < KC < DEN < CLE < CIN < BAL

######### HOW TO USE IN PRACTICE #########

library(ggplot2)
# load some sample data from the ggplot2 package
plot_data <- mpg
# add a new column by randomly sampling the above defined teams vector
plot_data$team <- sample(teams, nrow(mpg), replace = TRUE)

# Now we plot the data and facet by team abbreviation. ggplot automatically
# converts the team names to a factor and sorts it alphabetically
ggplot(plot_data, aes(displ, hwy)) +
  geom_point() +
  facet_wrap(~team, ncol = 4) +
  theme_minimal()


# We'll change the order of facets by making another team name column and
# converting it to an ordered factor. Again, this defaults to sort by division
# and nick name in ascending order.
plot_data$ordered_team <- nfl_team_factor(sample(teams, nrow(mpg), replace = TRUE))

# Let's check how the facets are ordered now.
ggplot(plot_data, aes(displ, hwy)) +
  geom_point() +
  facet_wrap(~ordered_team, ncol = 4) +
  theme_minimal()


# The facet order looks weird because the defaults is meant to be used with
# NFL team wordmarks. So let's use the actual wordmarks and look at the result.
ggplot(plot_data, aes(displ, hwy)) +
  geom_point() +
  facet_wrap(~ordered_team, ncol = 4) +
  theme_minimal() +
  theme(strip.text = element_nfl_wordmark())


# }
```
