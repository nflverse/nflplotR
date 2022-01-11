test_that("color and fill scales work", {
  library(ggplot2)

  team_abbr <- valid_team_names()
  # remove conference logos from this example
  team_abbr <- team_abbr[!team_abbr %in% c("AFC", "NFC", "NFL")]

  set.seed(20220105)

  df <- data.frame(
    random_value = runif(length(team_abbr), 0, 1),
    teams = team_abbr
  )
  p1 <- ggplot(df, aes(x = teams, y = random_value)) +
    geom_col(aes(color = teams, fill = teams), width = 0.5) +
    scale_color_nfl(type = "secondary") +
    scale_fill_nfl(alpha = 0.4) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

  vdiffr::expect_doppelganger("p1", p1)
})
