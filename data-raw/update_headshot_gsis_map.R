# nflplotR loads a mapping file to map headshot urls to gsis IDs with
# the unexported function load_headshots()
# This mapping needs an update every year to add rookie headshots
# Run this code early in the season to get those rookie data

# CREATE RELEASE (no need to rerun)

if (FALSE) {
  piggyback::pb_release_create(
    repo = "nflverse/nflplotR",
    tag = "nflplotr_infrastructure",
    name = "nflplotR Infrastructure",
    body = "Data for internal nflplotR usage"
  )
}

if (FALSE) {
  seasons_to_update <- 1999:nflreadr::most_recent_season()
} else {
  seasons_to_update <- nflreadr::most_recent_season()
}

# LOAD ROSTER AND RELEASE RELEVANT DATA BY SEASON
purrr::walk(
  seasons_to_update,
  function (s) {
    r <- nflapi::nflapi_roster(s) |>
      nflapi::nflapi_roster_parse() |>
      dplyr::select(
        gsis_id = player_gsis_id,
        headshot_nfl = player_headshot
      ) |>
      dplyr::filter(!is.na(gsis_id), !is.na(headshot_nfl)) |>
      dplyr::mutate(
        headshot_nfl = stringr::str_replace(headshot_nfl, "\\{formatInstructions\\}", "f_auto,q_auto")
      )

    nflversedata::nflverse_save(
      r,
      file_name = glue::glue("headshot_gsis_map_{s}"),
      nflverse_type = "nflplotR headshot gsis map",
      release_tag = "nflplotr_infrastructure",
      file_types = "rds",
      repo = "nflverse/nflplotR"
    )
  },
  .progress = TRUE
)

# NOW COMBINE ALL SEASONS INTO ONE FILE

combined_map <- purrr::map(
  seasons_to_update,
  function(s){
    load_from <- glue::glue("https://github.com/nflverse/nflplotR/releases/download/nflplotr_infrastructure/headshot_gsis_map_{s}.rds")
    nflreadr::rds_from_url(load_from)
  },
  .progress = TRUE
) |>
  purrr::list_rbind() |>
  dplyr::distinct()

nflversedata::nflverse_save(
  combined_map,
  file_name = "headshot_gsis_map",
  nflverse_type = "nflplotR headshot gsis map",
  release_tag = "nflplotr_infrastructure",
  file_types = "rds",
  repo = "nflverse/nflplotR"
)
