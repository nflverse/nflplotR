test_that("nfl team factors work", {
  # skip this on cran because we load images from github which could fail
  skip_on_cran()

  library(ggplot2)

  set.seed(20220128)

  # unsorted vector including NFL team abbreviations
  teams <- c("LAC", "LV", "CLE", "BAL", "DEN", "PIT", "CIN", "KC")

  # load some sample data from the ggplot2 package
  plot_data <- mpg

  # add a new column by randomly sampling the above defined teams vector
  plot_data$team <- sample(teams, nrow(mpg), replace = TRUE) |>
    nfl_team_factor(rev(team_abbr))

  # Now we plot the data and facet by team abbreviation. ggplot automatically
  # converts the team names to a factor and sorts it alphabetically
  p1 <- ggplot(plot_data, aes(displ, hwy)) +
    geom_point() +
    facet_wrap(~team, ncol = 4) +
    theme_minimal()

  # We'll change the order of facets by making another team name column and
  # converting it to an ordered factor. Again, this defaults to sort by division
  # and nick name in ascending order.
  plot_data$ordered_team <- sample(teams, nrow(mpg), replace = TRUE) |>
    nfl_team_factor()

  # Let's check how the facets are ordered now.
  p2 <- ggplot(plot_data, aes(displ, hwy)) +
    geom_point() +
    facet_wrap(~ordered_team, ncol = 4) +
    theme_minimal()

  vdiffr::expect_doppelganger("p1", p1)
  vdiffr::expect_doppelganger("p2", p2)
})
