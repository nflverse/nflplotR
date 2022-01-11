test_that("team tiers work", {
  library(ggplot2)
  library(dplyr, warn.conflicts = FALSE)
  team_abbr <- valid_team_names()
  # remove conference logos from this example
  team_abbr <- team_abbr[!team_abbr %in% c("AFC", "NFC", "NFL")]

  set.seed(20220105)

  # Build the team tiers data frame
  # This is completely random!
  df <- data.frame(
    tier_no = sample(1:5, length(team_abbr), replace = TRUE),
    team_abbr = team_abbr
  ) %>%
    dplyr::group_by(tier_no) %>%
    dplyr::mutate(tier_rank = sample(1:n(), n()))

  # Check dev mode only because logos are tested elsewhere
  p1 <- nfl_team_tiers(df,
                       tier_desc = c("1" = "Super Bowl",
                                     "2" = "Very Good",
                                     "3" = "",
                                     "4" = "A Combined Tier",
                                     "5" = ""),
                       no_line_below_tier = c(2, 4),
                       devel = TRUE)

  vdiffr::expect_doppelganger("p1", p1)
})
