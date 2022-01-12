test_that("logo element works", {
  library(ggplot2)

  team_abbr <- c("LAC", "KC")

  set.seed(20220105)

  df <- data.frame(
    random_value = runif(length(team_abbr), 0, 1),
    teams = team_abbr
  )

  # use logos for x-axis
  p1 <- ggplot(df, aes(x = teams, y = random_value)) +
    geom_col(width = 0.01) +
    theme_void() +
    theme(axis.text.x = element_nfl_logo())

  # use logos for y-axis
  p2 <- ggplot(df, aes(y = teams, x = random_value)) +
    geom_col(width = 0.01) +
    theme_void() +
    theme(axis.text.y = element_nfl_logo())

  vdiffr::expect_doppelganger("p1", p1)
  vdiffr::expect_doppelganger("p2", p2)
})
