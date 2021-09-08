#' ggplot2 Layer for Visualizing NFL Team Logos
#'
#' @description This geom is used to plot NFL team and conference logos instead
#'   of points in a ggplot. It requires x, y aesthetics as well as a valid NFL
#'   team abbreviation. The latter can be checked with [`valid_team_names()`].
#'
#' @inheritParams ggplot2::geom_point
#' @section Aesthetics:
#' `geom_nfl_logos()` understands the following aesthetics (required aesthetics are in bold):
#' \itemize{
#'   \item{**x**}{ - The x-coordinate.}
#'   \item{**y**}{ - The y-coordinate.}
#'   \item{**team_abbr**}{ - The team abbreviation. Should be one of [`valid_team_names()`]. The function tries to clean team names internally by calling [`nflreadr::clean_team_abbrs()`]}
#'   \item{`alpha = NULL`}{ - The alpha channel, i.e. transparency level, as a numerical value between 0 and 1.}
#'   \item{`angle = 0`}{ - The angle of the image as a numerical value between 0° and 360°.}
#'   \item{`hjust = 0.5`}{ - The horizontal adjustment relative to the given x coordinate. Must be a numerical value between 0 and 1.}
#'   \item{`vjust = 0.5`}{ - The vertical adjustment relative to the given y coordinate. Must be a numerical value between 0 and 1.}
#'   \item{`width = 1.0`}{ - The desired width of the image in `npc` (Normalised Parent Coordinates).
#'                           The default value is set to 1.0 which is *big* but it is necessary
#'                           because all used values are computed relative to the default.
#'                           A typical size is `width = 0.075` (see below examples).}
#'   \item{`height = 1.0`}{ - The desired height of the image in `npc` (Normalised Parent Coordinates).
#'                            The default value is set to 1.0 which is *big* but it is necessary
#'                            because all used values are computed relative to the default.
#'                            A typical size is `height = 0.1` (see below examples).}
#' }
#' @param ... Other arguments passed on to [ggplot2::layer()]. These are
#'   often aesthetics, used to set an aesthetic to a fixed value. See the below
#'   section "Aesthetics" for a full list of possible arguments.
#' @export
#' @examples
#' \donttest{
#' library(nflplotR)
#' library(ggplot2)
#'
#' team_abbr <- valid_team_names()
#' # remove conference logos from this example
#' team_abbr <- team_abbr[!team_abbr %in% c("AFC", "NFC")]
#'
#' df <- data.frame(
#'   a = rep(1:8, 4),
#'   b = sort(rep(1:4, 8), decreasing = TRUE),
#'   teams = team_abbr
#' )
#'
#' # keep alpha == 1 for all teams including an "A"
#' matches <- grepl("A", team_abbr)
#' df$alpha <- ifelse(matches, 1, 0.2)
#'
#' # scatterplot of all logos
#' ggplot(df, aes(x = a, y = b)) +
#'   geom_nfl_logos(aes(team_abbr = teams), width = 0.075) +
#'   geom_label(aes(label = teams), nudge_y = -0.35, alpha = 0.5) +
#'   theme_void()
#'
#' # apply alpha via an aesthetic from inside the dataset `df`
#' ggplot(df, aes(x = a, y = b)) +
#'   geom_nfl_logos(aes(team_abbr = teams, alpha = alpha), width = 0.075) +
#'   geom_label(aes(label = teams), nudge_y = -0.35, alpha = 0.5) +
#'   theme_void()
#'
#' # apply alpha as constant for all logos
#' ggplot(df, aes(x = a, y = b)) +
#'   geom_nfl_logos(aes(team_abbr = teams), width = 0.075, alpha = 0.6) +
#'   geom_label(aes(label = teams), nudge_y = -0.35, alpha = 0.5) +
#'   theme_void()
#'
#' # it's also possible to plot conference logos
#' conf <- data.frame(a = 1:2, b = 0, teams = c("AFC", "NFC"))
#' ggplot(conf, aes(x = a, y = b)) +
#'   geom_nfl_logos(aes(team_abbr = teams), width = 0.3) +
#'   geom_label(aes(label = teams), nudge_y = -0.4, alpha = 0.5) +
#'   coord_cartesian(xlim = c(0.5,2.5), ylim = c(-0.75,.75)) +
#'   theme_void()
#' }
geom_nfl_logos <- function(mapping = NULL, data = NULL,
                           stat = "identity", position = "identity",
                           ...,
                           na.rm = FALSE,
                           show.legend = FALSE,
                           inherit.aes = TRUE) {

  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomNFL,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      na.rm = na.rm,
      ...
    )
  )
}

GeomNFL <- ggplot2::ggproto(
  "GeomNFL", ggplot2::Geom,
  required_aes = c("x", "y", "team_abbr"),
  # non_missing_aes = c(""),
  default_aes = ggplot2::aes(
    alpha = NULL, angle = 0, hjust = 0.5,
    vjust = 0.5, width = 1.0, height = 1.0
  ),
  draw_panel = function(data, panel_params, coord, na.rm = FALSE) {
    data <- coord$transform(data, panel_params)

    data$team_abbr <- nflreadr::clean_team_abbrs(data$team_abbr, keep_non_matches = FALSE)

    grobs <- lapply(seq_along(data$team_abbr), function(i, urls, alpha, data) {
      team_abbr <- data$team_abbr[i]
      if (is.na(team_abbr)){
        grid <- grid::nullGrob()
      } else if (is.null(alpha)) {
        grid <- grid::rasterGrob(magick::image_read(logo_list[[team_abbr]]))
      } else if (length(alpha) == 1L) {
        if (as.numeric(alpha) <= 0 || as.numeric(alpha) >= 1) {
          cli::cli_abort("aesthetic {.var alpha} requires a value between {.val 0} and {.val 1}")
        }
        img <- magick::image_read(logo_list[[team_abbr]])
        new <- magick::image_fx(img, expression = paste0(alpha, "*a"), channel = "alpha")
        grid <- grid::rasterGrob(new)
      } else {
        if (any(as.numeric(alpha) < 0) || any(as.numeric(alpha) > 1)) {
          cli::cli_abort("aesthetics {.var alpha} require values between {.val 0} and {.val 1}")
        }
        img <- magick::image_read(logo_list[[team_abbr]])
        new <- magick::image_fx(img, expression = paste0(alpha[i], "*a"), channel = "alpha")
        grid <- grid::rasterGrob(new)
      }

      grid$vp <- grid::viewport(
        x = grid::unit(data$x[i], "native"),
        y = grid::unit(data$y[i], "native"),
        width = grid::unit(data$width[i], "npc"),
        height = grid::unit(data$height[i], "npc"),
        just = c(data$hjust[i], data$vjust[i]),
        angle = data$angle[i],
        name = paste("geom_nfl.panel", data$PANEL[i],
          "row", i,
          sep = "."
        )
      )

      grid$name <- paste("nfl.grob", i, sep = ".")

      grid
    }, urls = urls, alpha = data$alpha, data = data)

    class(grobs) <- "gList"

    grid::gTree(children = grobs)
  },
  draw_key = function(...) grid::nullGrob()
)
