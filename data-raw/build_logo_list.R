# Save raw logos in internal data for more speed
teams_colors_logos <- nflreadr::load_teams() |>
  dplyr::bind_rows(
    tibble::tibble(
      team_abbr = c("AFC", "NFC"),
      team_logo_espn = c("https://github.com/nflverse/nflplotR/raw/main/data-raw/AFC.png",
                         "https://github.com/nflverse/nflplotR/raw/main/data-raw/NFC.png")
    )
  )

logo_list <- lapply(teams_colors_logos$team_abbr, function(x){
  url <- teams_colors_logos$team_logo_espn[teams_colors_logos$team_abbr == x]
  curl::curl_fetch_memory(url)$content
})

logo_list <- rlang::set_names(logo_list, teams_colors_logos$team_abbr)

use_data(logo_list, internal = TRUE, overwrite = TRUE)
