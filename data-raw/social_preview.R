library(nflplotR)
library(ggplot2)

team_abbr <- valid_team_names()
# remove conference logos from this example
team_abbr <- team_abbr[!team_abbr %in% c("AFC", "NFC")]

df <- data.frame(
  a = rep(1:8, 4),
  b = sort(rep(1:4, 8), decreasing = TRUE),
  teams = team_abbr
)

p <- ggplot(df, aes(x = a, y = b)) +
  geom_nfl_logos(aes(team_abbr = teams), width = 0.09, alpha = 0.2) +
  annotate("text", x = 4.5, y = 2.5, label = "nflplotR", family = "Kanit", size = 7, color = "#ffffff") +
  annotate("text", x = 8.7, y = 0.5, label = "Part of the #nflverse", hjust = 1, size = 1.2, color = "#ffffff") +
  annotate("text", x = 6.5, y = 2, label = "by @mrcaseb ", hjust = 1, size = 1.2, color = "#ffffff") +
  theme_void() +
  coord_cartesian(xlim = c(0.5,8.5), ylim = c(0.5,4.5))

# ggpreview(p, width = 1280, height = 640, units = "px", dpi = 600,  bg = "#222222")

ggsave("man/figures/social_preview.png",
       p, width = 1280, height = 640, units = "px", dpi = 600,
       bg = "#222222")



# GT ----------------------------------------------------------------------

teams <- nflplotR::valid_team_names()
# remove conference logos from this example
teams <- c(teams[!teams %in% c("AFC", "NFC", "NFL")], c("AFC", "NFC", "NFL"))
# create dataframe with all 32 team names
df <- data.frame(
  team_a = teams[1:9],
  logo_a = teams[1:9],
  wordmark_a = teams[1:9],
  team_b = teams[10:18],
  logo_b = teams[10:18],
  wordmark_b = teams[10:18],
  team_c = teams[19:27],
  logo_c = teams[19:27],
  wordmark_c = teams[19:27],
  team_d = teams[28:36],
  logo_d = teams[28:36],
  wordmark_d = teams[28:36]
)
gt_preview <- df |>
  gt::gt() |>
  nflplotR::gt_nfl_logos(columns = gt::starts_with("logo")) |>
  nflplotR::gt_nfl_wordmarks(columns = gt::starts_with("wordmark")) |>
  gt::cols_label(
    gt::starts_with("team") ~ "TEAM",
    gt::starts_with("logo") ~ "LOGO",
    gt::starts_with("wordmark") ~ "WORDMARK"
  ) |>
  nflseedR:::table_theme() |>
  gt::sub_missing(missing_text = "") |>
  gt::tab_style(
    style = gt::cell_borders(sides = "left", weight = gt::px(1)),
    locations = gt::cells_body(columns = c(team_b, team_c, team_d))
  ) |>
  gt::tab_header("NFL Logos & Wordmarks in nflplotR", "by @mrcaseb")

gt::gtsave(gt_preview, "man/figures/social_preview_gt.png", zoom = 3)
