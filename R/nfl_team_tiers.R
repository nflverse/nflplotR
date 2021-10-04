###
# Based on a suggestion by Timo Riske (https://twitter.com/PFF_Moo)
###

#' Create NFL Team Tiers
#'
#' @description This function sets up a ggplot to visualize NFL team tiers.
#'
#' @param data A data frame that has to include the variables `tier_no` (the
#'   number of the tier starting from the top tier no. 1) and `team_abbr` (the
#'   team abbreviation). `team_abbr` should be one of [`valid_team_names()`] and
#'   the function tries to clean team names internally by calling
#'   [`nflreadr::clean_team_abbrs()`].
#' @param season The season the team tiers are built for. This will be placed
#'   in the title of the plot.
#' @param week The week inside `season` the team tiers are built for. This will
#'   be placed in the title of the plot.
#' @param tier_desc A named vector consisting of the tier descriptions. The names
#'   must equal the tier numbers from `tier_no`
#' @param presort If `FALSE` (the default) the function assumes that the teams
#'   are already sorted within the tiers. Will otherwise sort alphabetically.
#' @param alpha The alpha channel of the logos, i.e. transparency level, as a
#'   numerical value between 0 and 1.
#' @param width The desired width of the logo in `npc` (Normalised Parent Coordinates).
#'
#' @examples
#' \donttest{
#' library(ggplot2)
#' library(dplyr, warn.conflicts = FALSE)
#' team_abbr <- valid_team_names()
#' # remove conference logos from this example
#' team_abbr <- team_abbr[!team_abbr %in% c("AFC", "NFC")]
#'
#' # Build the team tiers data frame
#' # This is completely random!
#' df <- data.frame(
#'   tier_no = sample(1:5, length(team_abbr), replace = TRUE),
#'   team_abbr = team_abbr
#' ) %>%
#'   dplyr::group_by(tier_no) %>%
#'   dplyr::mutate(tier_rank = sample(1:n(), n()))
#'
#' nfl_team_tiers(df, 2021, 4)
#' }
#' @export
nfl_team_tiers <- function(data,
                           season = NULL,
                           week = NULL,
                           tier_desc = c("1" = "Super Bowl",
                                         "2" = "Very Good",
                                         "3" = "Medium",
                                         "4" = "Bad",
                                         "5" = "What are they doing?"),
                           presort = FALSE,
                           alpha = 0.8,
                           width = 0.075){

  rlang::check_installed("sjmisc", "to build the nflplotR team tiers.")

  if (isTRUE(presort)) required_vars <- c("tier_no", "team_abbr")
  if (isFALSE(presort)) required_vars <- c("tier_no", "team_abbr", "tier_rank")

  if (!all(required_vars %in% names(data))){
    cli::cli_abort("The data frame {.var data} has to include the variables {.var {required_vars}}!")
  }

  bg <- "#1e1e1e"
  lines <- "#e0e0e0"

  title_string <- if (!is.null(season) && !is.null(week)){
    sprintf("NFL Team Tiers, %s as of Week %s", season, week)
  } else if (is.null(week)){
    sprintf("NFL Team Tiers, %s", season)
  } else {
    cli::cli_abort("Specifying the argument {.var week} without setting {.var season} does not make sense.")
  }

  tiers <- sort(unique(data$tier_no))

  if (isTRUE(presort)){
    data <- data %>%
      dplyr::group_by(.data$tier_no) %>%
      dplyr::arrange(.data$team_abbr) %>%
      dplyr::mutate(tier_rank = 1:dplyr::n()) %>%
      dplyr::ungroup()
  }

  data$team_abbr <- nflreadr::clean_team_abbrs(data$team_abbr, keep_non_matches = FALSE)

  ggplot2::ggplot(data, ggplot2::aes(y = .data$tier_no, x = .data$tier_rank)) +
    ggplot2::geom_hline(yintercept = seq(min(tiers) - 0.5, max(tiers) + 0.5, by = 1), color = lines) +
    nflplotR::geom_nfl_logos(ggplot2::aes(team_abbr = .data$team_abbr), width = width, alpha = alpha) +
    # ggplot2::geom_text(aes(label = team), color = "white") +
    ggplot2::scale_y_continuous(
      expand = ggplot2::expansion(add = 0.1),
      limits = rev(c(min(tiers) - 0.5, max(tiers) + 0.5)),
      breaks = rev(tiers),
      labels = function(x) sjmisc::word_wrap(tier_desc[x], 15),
      trans = "reverse"
    ) +
    ggplot2::labs(
      title = sprintf("NFL Team Tiers, %s as of Week %s", season, week),
      subtitle = "created with the #nflplotR Tiermaker"
    ) +
    ggplot2::theme_minimal(base_size = 11.5) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(color = "white", face = "bold"),
      plot.subtitle = ggplot2::element_text(color = "#8e8e93"),
      plot.title.position = "plot",
      axis.text.x = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_text(color = "white", face = "bold", size = ggplot2::rel(1.1)),
      axis.title = ggplot2::element_blank(),
      panel.grid = ggplot2::element_blank(),
      plot.background = ggplot2::element_rect(fill = bg, color = bg),
      panel.background = ggplot2::element_rect(fill = bg, color = bg)
    ) +
    NULL
}

