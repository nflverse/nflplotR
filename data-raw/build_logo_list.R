# Save raw logos in internal data for more speed
teams_colors_logos <- nflreadr::load_teams()

logo_list <- lapply(teams_colors_logos$team_abbr, function(x){
  url <- teams_colors_logos$team_logo_espn[teams_colors_logos$team_abbr == x]
  curl::curl_fetch_memory(url)$content
})

logo_list <- rlang::set_names(logo_list, teams_colors_logos$team_abbr)

use_data(logo_list, internal = TRUE, overwrite = TRUE)

