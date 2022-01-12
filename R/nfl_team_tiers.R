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
#'   [`nflreadr::clean_team_abbrs()`]. If data includes the variable `tier_rank`,
#'   these ranks will be used within each tier. Otherwise, if `presort = FALSE`,
#'   the function will assume that data is already sorted and if `presort = TRUE`,
#'   teams will be sorted alphabetically within tiers.
#' @param title The title of the plot. If `NULL`, it will be omitted.
#' @param subtitle The subtitle of the plot. If `NULL`, it will be omitted.
#' @param caption The caption of the plot. If `NULL`, it will be omitted.
#' @param tier_desc A named vector consisting of the tier descriptions. The names
#'   must equal the tier numbers from `tier_no`
#' @param presort If `FALSE` (the default) the function assumes that the teams
#'   are already sorted within the tiers. Will otherwise sort alphabetically.
#' @param alpha The alpha channel of the logos, i.e. transparency level, as a
#'   numerical value between 0 and 1.
#' @param width The desired width of the logo in `npc` (Normalised Parent Coordinates).
#' @param no_line_below_tier Vector of tier numbers. The function won't draw tier
#'   separation lines below these tiers. This is intended to be used for tiers
#'   that shall be combined (see examples).
#' @param devel Determines if logos shall be rendered. If `FALSE` (the default),
#'   logos will be rendered on each run. If `TRUE` the team abbreviations will be
#'   plotted instead of the logos. This is much faster and helps with the plot
#'   development.
#' @examples
#' \donttest{
#' library(ggplot2)
#' library(dplyr, warn.conflicts = FALSE)
#' teams <- valid_team_names()
#' # remove conference logos from this example
#' teams <- teams[!teams %in% c("AFC", "NFC", "NFL")]
#'
#' # Build the team tiers data frame
#' # This is completely random!
#' df <- data.frame(
#'   tier_no = sample(1:5, length(teams), replace = TRUE),
#'   team_abbr = teams
#' ) %>%
#'   dplyr::group_by(tier_no) %>%
#'   dplyr::mutate(tier_rank = sample(1:n(), n()))
#'
#' # Plot team tiers
#' nfl_team_tiers(df)
#'
#' # Create a combined tier which is useful for tiers with lots of teams that
#' # should be split up in two or more rows. This is done by setting an empty
#' # string for the tier 5 description and removing the tier separation line
#' # below tier number 4.
#' # This example also shows how to turn off the subtitle and add a caption
#' nfl_team_tiers(df,
#'                subtitle = NULL,
#'                caption = "This is the caption",
#'                tier_desc = c("1" = "Super Bowl",
#'                              "2" = "Very Good",
#'                              "3" = "Medium",
#'                              "4" = "A Combined Tier",
#'                              "5" = ""),
#'                no_line_below_tier = 4)
#'
#' # For the development of the tiers, it can be useful to turn off logo image
#' # rendering as this can take quite a long time. By setting `devel = TRUE`, the
#' # logo images are replaced by team abbreviations which is much faster
#' nfl_team_tiers(df,
#'                tier_desc = c("1" = "Super Bowl",
#'                              "2" = "Very Good",
#'                              "3" = "",
#'                              "4" = "A Combined Tier",
#'                              "5" = ""),
#'                no_line_below_tier = c(2, 4),
#'                devel = TRUE)
#' }
#' @export
nfl_team_tiers <- function(data,
                           title = "NFL Team Tiers, 2021 as of Week 4",
                           subtitle = "created with the #nflplotR Tiermaker",
                           caption = NULL,
                           tier_desc = c("1" = "Super Bowl",
                                         "2" = "Very Good",
                                         "3" = "Medium",
                                         "4" = "Bad",
                                         "5" = "What are they doing?",
                                         "6" = "",
                                         "7" = ""),
                           presort = FALSE,
                           alpha = 0.8,
                           width = 0.075,
                           no_line_below_tier = NULL,
                           devel = FALSE){

  rlang::check_installed("sjmisc", "to build the nflplotR team tiers.")

  required_vars <- c("tier_no", "team_abbr")

  if (!all(required_vars %in% names(data))){
    cli::cli_abort("The data frame {.var data} has to include the variables {.var {required_vars}}!")
  }

  bg <- "#1e1e1e"
  lines <- "#e0e0e0"

  tiers <- sort(unique(data$tier_no))
  tierlines <- tiers[!tiers %in% no_line_below_tier] + 0.5
  tierlines <- c(min(tiers) - 0.5, tierlines)

  if (isTRUE(presort)){
    data <- data %>%
      dplyr::group_by(.data$tier_no) %>%
      dplyr::arrange(.data$team_abbr) %>%
      dplyr::mutate(tier_rank = 1:dplyr::n()) %>%
      dplyr::ungroup()
  }

  if (!"tier_rank" %in% names(data)){
    data <- data %>%
      dplyr::group_by(.data$tier_no) %>%
      dplyr::mutate(tier_rank = 1:dplyr::n()) %>%
      dplyr::ungroup()
  }

  data$team_abbr <- nflreadr::clean_team_abbrs(as.character(data$team_abbr), keep_non_matches = FALSE)

  p <- ggplot2::ggplot(data, ggplot2::aes(y = .data$tier_no, x = .data$tier_rank)) +
    ggplot2::geom_hline(yintercept = tierlines, color = lines)

  if(isFALSE(devel)) p <- p + nflplotR::geom_nfl_logos(ggplot2::aes(team_abbr = .data$team_abbr), width = width, alpha = alpha)
  if(isTRUE(devel))p <- p + ggplot2::geom_text(ggplot2::aes(label = .data$team_abbr), color = "white")

  p <- p +
    ggplot2::scale_y_continuous(
      expand = ggplot2::expansion(add = 0.1),
      limits = rev(c(min(tiers) - 0.5, max(tiers) + 0.5)),
      breaks = rev(tiers),
      labels = function(x) sjmisc::word_wrap(tier_desc[x], 15),
      trans = "reverse"
    ) +
    ggplot2::labs(title = title, subtitle = subtitle, caption = caption) +
    ggplot2::theme_minimal(base_size = 11.5) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(color = "white", face = "bold"),
      plot.subtitle = ggplot2::element_text(color = "#8e8e93"),
      plot.caption = ggplot2::element_text(color = "#8e8e93", hjust = 1),
      plot.title.position = "plot",
      axis.text.x = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_text(color = "white", face = "bold", size = ggplot2::rel(1.1)),
      axis.title = ggplot2::element_blank(),
      panel.grid = ggplot2::element_blank(),
      plot.background = ggplot2::element_rect(fill = bg, color = bg),
      panel.background = ggplot2::element_rect(fill = bg, color = bg)
    ) +
    NULL

  p
}

