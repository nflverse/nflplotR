# Save raw logos in internal data for more speed
teams_colors_logos <- nflreadr::load_teams(current = FALSE) |>
  dplyr::bind_rows(
    tibble::tibble(
      team_abbr = c("AFC", "NFC", "NFL"),
      team_logo_espn = c("https://github.com/nflverse/nflplotR/raw/main/data-raw/AFC.png",
                         "https://github.com/nflverse/nflplotR/raw/main/data-raw/NFC.png",
                         "https://raw.githubusercontent.com/nflverse/nflfastR-data/master/NFL.png")
    )
  )

logo_list <- lapply(teams_colors_logos$team_abbr, function(x){
  url <- teams_colors_logos$team_logo_espn[teams_colors_logos$team_abbr == x]
  curl::curl_fetch_memory(url)$content
})

logo_list <- rlang::set_names(logo_list, teams_colors_logos$team_abbr)

primary_colors <- teams_colors_logos$team_color
names(primary_colors) <- teams_colors_logos$team_abbr

secondary_colors <- teams_colors_logos$team_color2
names(secondary_colors) <- teams_colors_logos$team_abbr

logo_urls <- teams_colors_logos$team_logo_espn
names(logo_urls) <- teams_colors_logos$team_abbr

# Save raw logos in internal data for more speed
wordmarks <- nflreadr::load_teams() |> dplyr::select(team_abbr, team_wordmark)
wordmark_list <- lapply(wordmarks$team_wordmark, function(url){
  curl::curl_fetch_memory(url)$content
})

wordmark_list <- rlang::set_names(wordmark_list, wordmarks$team_abbr)

usethis::use_data(logo_list, primary_colors, secondary_colors, logo_urls, wordmark_list, internal = TRUE, overwrite = TRUE)
