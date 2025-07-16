test_that("wordmark geom works", {
  # skip because of the multithread problem
  skip_on_cran()
  library(ggplot2)

  teams_a <- c("KC", "MIA", "TB", "ARI", "LAC", "IND", "TEN", "PIT",
               "NO", "CLE", "CIN", "MIN", "DAL", "JAX", "ATL", "BAL")

  teams_b <- c("BUF", "CAR", "CHI", "DEN", "DET", "GB", "HOU", "LA",
               "LV", "NE", "NYG", "NYJ", "PHI", "SEA", "SF", "WAS")

  df_a <- data.frame(
    a = rep(1:4, 2),
    b = sort(rep(1:4, 4), decreasing = TRUE),
    teams = teams_a
  )

  df_b <- data.frame(
    a = rep(1:4, 2),
    b = sort(rep(1:4, 4), decreasing = TRUE),
    teams = teams_b
  )

  # keep alpha == 1 for all teams including an "A"
  matches <- grepl("A", df_a$teams)
  df_a$alpha <- ifelse(matches, 1, 0.2)

  # set a custom fill colour for the non "A" teams
  matches <- grepl("A", df_b$teams)
  df_b$colour <- ifelse(matches, NA, "gray")

  # apply alpha via an aesthetic from inside the dataset `df_a`
  p1 <- ggplot(df_a, aes(x = a, y = b)) +
    geom_nfl_wordmarks(aes(team_abbr = teams, alpha = alpha), width = 0.12) +
    geom_label(aes(label = teams), nudge_y = -0.20, alpha = 0.5, fill = "transparent") +
    scale_x_continuous(expand = expansion(add = 0.5)) +
    scale_alpha_identity() +
    theme_void()

  # apply colour via an aesthetic from inside the dataset `df_b`
  p2 <- ggplot(df_b, aes(x = a, y = b)) +
    geom_nfl_wordmarks(aes(team_abbr = teams, colour = colour), width = 0.12) +
    geom_label(aes(label = teams), nudge_y = -0.20, alpha = 0.5, fill = "transparent") +
    scale_x_continuous(expand = expansion(add = 0.5)) +
    scale_alpha_identity() +
    scale_color_identity() +
    theme_void()

  vdiffr::expect_doppelganger("p1", p1)
  vdiffr::expect_doppelganger("p2", p2)

  # Team name mismatch
  p3 <- data.frame(a = c("LAC", "LARRR"), b = 1:2, c = 10:11) |>
    ggplot(aes(x = b, y = c)) +
    geom_nfl_wordmarks(aes(team_abbr = a), width = 0.4, hjust = 0)

  expect_snapshot(out <- ggplotGrob(p3))
})
