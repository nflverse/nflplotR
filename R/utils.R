#' Output Valid NFL Team Abbreviations
#'
#' @param exclude_duplicates If `TRUE` (the default) the list of valid team
#' abbreviations will exclude duplicates related to franchises that have been
#' moved
#' @export
#' @return A vector of type `"character"`.
#' @examples
#' # List valid team abbreviations excluding duplicates
#' valid_team_names()
#'
#' # List valid team abbreviations excluding duplicates
#' valid_team_names(exclude_duplicates = FALSE)
valid_team_names <- function(exclude_duplicates = TRUE){
 n <- sort(names(logo_list))
 if(isTRUE(exclude_duplicates)) n <- n[!n %in% c("LAR", "OAK", "SD", "STL")]
 n
}

logo_html <- function(team_abbr, type = c("height", "width"), size = 15){
  type <- rlang::arg_match(type)
  url <- logo_urls[team_abbr]
  sprintf("<img src='%s' %s = '%s'>", url, type, size)
}

headshot_html <- function(player_gsis, type = c("height", "width"), size = 25){
  type <- rlang::arg_match(type)
  headshot_map <- load_headshots()
  player_gsis <- ifelse(player_gsis %in% headshot_map$gsis_id, player_gsis, "NA_ID")
  headshot_map <- rbind(
    headshot_map,
    list(gsis_id = "NA_ID", headshot_nfl = na_headshot())
  )
  joined <- merge(
    data.frame(gsis_id = player_gsis),
    headshot_map,
    by = "gsis_id",
    all.x = TRUE,
    sort = FALSE
  )
  url <- joined$headshot_nfl
  url <- ifelse(grepl(".png", url), url, paste0(url, ".png"))
  sprintf("<img src='%s' %s = '%s'>", url, type, size)
}

is_installed <- function(pkg) requireNamespace(pkg, quietly = TRUE)

is_gsis <- function(id) grepl("00-00[0-9]{5}", id, perl = TRUE)

load_headshots <- function() nflreadr::rds_from_url("https://github.com/nflverse/nflplotR/releases/download/nflplotr_infrastructure/headshot_gsis_map.rds")

na_headshot <- function() "https://static.www.nfl.com/image/private/t_player_profile_landscape_2x/f_auto/league/rfuw3dh4aah4l4eeuubp.png"

#' Clear nflplotR Cache
#'
#' This function clears the memoised cache of all functions memoised by `nflplotR`.
#'
#' @export
#' @return Invisibly `NULL`
#' @examples
#' .nflplotR_clear_cache()
.nflplotR_clear_cache <- function(){

  functions <- list(
    reader_function
  )

  lapply(functions, memoise::forget)

  cli::cli_alert_success("nflplotR cache cleared!")

  invisible(NULL)
}

#' Get a Situation Report on System, nflverse Package Versions and Dependencies
#'
#' See [`nflreadr::nflverse_sitrep`] for details.
#'
#' @name nflverse_sitrep
#' @importFrom nflreadr nflverse_sitrep
#' @export
#' @return Situation report of R and package/dependencies.
NULL

# No code coverage here ---------------------------------------------------

# nocov start
release_bullets <- function() {
  c(
    '`devtools::check_mac_release()`',
    '`nflfastR:::my_rhub_check()`',
    '`pkgdown::check_pkgdown()`',
    '`nflfastR:::nflverse_thanks()`',
    NULL
  )
}
# nocov end
