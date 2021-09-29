library(hexSticker)
library(showtext)
library(tidyverse)
library(nflplotR)
library(ggplot2)

## Loading Google fonts (http://www.google.com/fonts)
font_add_google("Kanit")
## Automatically use showtext to render text for future devices
showtext_auto()

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
  coord_cartesian(xlim = c(0.5,8.5), ylim = c(0.5,4.5)) +
  theme_void() +
  theme_transparent()

sticker(
  p,
  package = "nflplotR",
  p_family = "Kanit",
  # p_fontface = "regular",
  p_y = 0.6,
  p_size = 20,
  s_x = 1,
  s_y = 1,
  s_width = 1.9,
  s_height = 1.2,
  spotlight = TRUE,
  l_y = 1.75,
  l_alpha = 0.2,
  l_width = 5,
  h_fill = "#222222",
  h_color = "black",
  h_size = 0.8,
  filename = "data-raw/logo.svg",
  url = "https://nflplotr.nflverse.com",
  u_color = "white",
  u_size = 5,
  dpi = 600
)

# usethis::use_logo("data-raw/logo.png")
