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
