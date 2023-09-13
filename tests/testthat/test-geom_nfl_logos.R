test_that("logo geom works", {
  # skip because of the multithread problem
  skip_on_cran()
  library(ggplot2)

  teams_a <- c("DEN", "KC", "LA", "CAR", "LAC", "IND", "DAL", NA_character_, "ARI", "WAS", "MIN", "TB")
  teams_b <- c("CHI", "JAX", "PIT", "CIN", "DET", "NYJ", "CLE", "NE", "AFC", "SEA", "GB", "PHI")
  teams_c <- c("ATL", "BAL", "BUF", "HOU", "LV", "MIA", "NFC", "NO", "NYG", "SF", "TEN", NA_character_)

  df_a <- na.omit(data.frame(
    a = rep(1:4, 3),
    b = sort(rep(1:3, 4), decreasing = TRUE),
    teams = teams_a
  ))

  df_b <- data.frame(
    a = rep(1:4, 3),
    b = sort(rep(1:3, 4), decreasing = TRUE),
    teams = teams_b
  )

  df_c <- na.omit(data.frame(
    a = rep(1:4, 3),
    b = sort(rep(1:3, 4), decreasing = TRUE),
    teams = teams_c
  ))

  # keep alpha == 1 for all teams including an "A"
  matches <- grepl("A", df_a$teams)
  df_a$alpha <- ifelse(matches, 1, 0.2)

  # set a custom fill colour for the non "A" teams
  matches <- grepl("A", df_b$teams)
  df_b$colour <- ifelse(matches, NA, "gray")

  # apply alpha via an aesthetic from inside the dataset `df_a`
  p1 <- ggplot(df_a, aes(x = a, y = b)) +
    geom_nfl_logos(aes(team_abbr = teams, alpha = alpha), width = 0.04) +
    geom_label(aes(label = teams), nudge_y = -0.35, alpha = 0.5) +
    scale_alpha_identity() +
    theme_void()

  # apply alpha and colour via an aesthetic from inside the dataset `df_b`
  p2 <- ggplot(df_b, aes(x = a, y = b)) +
    geom_nfl_logos(aes(team_abbr = teams, colour = colour), width = 0.04) +
    geom_label(aes(label = teams), nudge_y = -0.35, alpha = 0.5) +
    scale_color_identity() +
    theme_void()

  p3 <- ggplot(df_c, aes(x = a, y = b)) +
    geom_nfl_logos(aes(team_abbr = teams), width = 0.04) +
    geom_label(aes(label = teams), nudge_y = -0.4, alpha = 0.5) +
    theme_void()

  vdiffr::expect_doppelganger("p1", p1)
  vdiffr::expect_doppelganger("p2", p2)
  vdiffr::expect_doppelganger("p3", p3)
})
