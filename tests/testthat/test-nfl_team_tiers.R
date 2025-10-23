test_that("team tiers work", {
  # skip because of data.table multithreading
  skip_on_cran()

  library(ggplot2)
  teams <- nflplotR::valid_team_names()
  # remove conference logos from this example
  teams <- teams[!teams %in% c("AFC", "NFC", "NFL")]
  set.seed(32)

  teams <- sample(teams)
  # Build the team tiers data
  # This is completely random!
  dt <- data.table::data.table(
    tier_no = sample(1:5, length(teams), replace = TRUE),
    team_abbr = teams
  )[, tier_rank := sample(1:.N, .N), by = "tier_no"]

  # Check dev mode only because logos are tested elsewhere
  p1 <- nfl_team_tiers(
    dt,
    tier_desc = c(
      "1" = "Super Bowl",
      "2" = "Very Good",
      "3" = "",
      "4" = "A Combined Tier",
      "5" = ""
    ),
    no_line_below_tier = c(2, 4),
    devel = TRUE
  )

  vdiffr::expect_doppelganger("p1", p1)
})
