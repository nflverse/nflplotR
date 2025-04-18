#' ggplot2 Layer for Visualizing NFL Player Headshots
#'
#' @description This geom is used to plot NFL player headshots instead
#'   of points in a ggplot. It requires x, y aesthetics as well as a valid NFL
#'   player gsis id.
#'
#' @inheritParams ggplot2::geom_point
#' @section Aesthetics:
#' `geom_nfl_headshots()` understands the following aesthetics (required aesthetics have no default value):
#' \describe{
#'   \item{`x`}{The x-coordinate. Required.}
#'   \item{`y`}{The y-coordinate. Required.}
#'   \item{`player_gsis`}{The players' NFL gsis id. Required.}
#'   \item{`alpha = NULL`}{The alpha channel, i.e. transparency level, as a numerical value between 0 and 1.}
#'   \item{`colour = NULL`}{The image will be colorized with this colour. Use the special character `"b/w"` to set it to black and white. For more information on valid colour names in ggplot2 see <https://ggplot2.tidyverse.org/articles/ggplot2-specs.html?q=colour#colour-and-fill>}
#'   \item{`angle = 0`}{The angle of the image as a numerical value between 0° and 360°.}
#'   \item{`hjust = 0.5`}{The horizontal adjustment relative to the given x coordinate. Must be a numerical value between 0 and 1.}
#'   \item{`vjust = 0.5`}{The vertical adjustment relative to the given y coordinate. Must be a numerical value between 0 and 1.}
#'   \item{`width = 1.0`}{The desired width of the image in `npc` (Normalised Parent Coordinates).
#'                           The default value is set to 1.0 which is *big* but it is necessary
#'                           because all used values are computed relative to the default.
#'                           A typical size is `width = 0.075` (see below examples).}
#'   \item{`height = 1.0`}{The desired height of the image in `npc` (Normalised Parent Coordinates).
#'                            The default value is set to 1.0 which is *big* but it is necessary
#'                            because all used values are computed relative to the default.
#'                            A typical size is `height = 0.1` (see below examples).}
#' }
#' @param ... Other arguments passed on to [ggplot2::layer()]. These are
#'   often aesthetics, used to set an aesthetic to a fixed value. See the below
#'   section "Aesthetics" for a full list of possible arguments.
#' @return A ggplot2 layer ([ggplot2::layer()]) that can be added to a plot
#'   created with [ggplot2::ggplot()].
#' @export
#' @examples
#' \donttest{
#' library(nflplotR)
#' library(ggplot2)
#' # Silence an nflreadr message that is irrelevant here
#' old <- options(nflreadr.cache_warning = FALSE)
#'
#' df <- data.frame(
#'   a = rep(1:3, 3),
#'   b = sort(rep(1:3, 3), decreasing = TRUE),
#'   player_gsis = c("00-0033873",
#'                   "00-0026498",
#'                   "00-0035228",
#'                   "00-0031237",
#'                   "00-0036355",
#'                   "00-0019596",
#'                   "00-0033077",
#'                   "00-0012345",
#'                   "00-0031280"),
#'   player_name = c("P.Mahomes",
#'                   "M.Stafford",
#'                   "K.Murray",
#'                   "T.Bridgewater",
#'                   "J.Herbert",
#'                   "T.Brady",
#'                   "D.Prescott",
#'                   "Non.Match",
#'                   "D.Carr")
#' )
#'
#' # set a custom fill colour for one player
#' df$colour <- ifelse(df$a == 2 & df$b == 2, NA, "b/w")
#'
#' # scatterplot of the headshots
#' ggplot(df, aes(x = a, y = b)) +
#'   geom_nfl_headshots(aes(player_gsis = player_gsis), height = 0.2) +
#'   geom_label(aes(label = player_name), nudge_y = -0.35, alpha = 0.5) +
#'   coord_cartesian(xlim = c(0.75, 3.25), ylim = c(0.7, 3.25)) +
#'   theme_void()
#'
#' # apply alpha as constant
#' ggplot(df, aes(x = a, y = b)) +
#'   geom_nfl_headshots(aes(player_gsis = player_gsis), height = 0.2, alpha = 0.5) +
#'   geom_label(aes(label = player_name), nudge_y = -0.35, alpha = 0.5) +
#'   coord_cartesian(xlim = c(0.75, 3.25), ylim = c(0.7, 3.25)) +
#'   theme_void()
#'
#' # apply colour as an aesthetic
#' ggplot(df, aes(x = a, y = b)) +
#'   geom_nfl_headshots(aes(player_gsis = player_gsis, colour = colour), height = 0.2) +
#'   geom_label(aes(label = player_name), nudge_y = -0.35, alpha = 0.5) +
#'   coord_cartesian(xlim = c(0.75, 3.25), ylim = c(0.7, 3.25)) +
#'   scale_colour_identity() +
#'   theme_void()
#'
#' # Restore old options
#' options(old)
#' }
geom_nfl_headshots <- function(mapping = NULL, data = NULL,
                               stat = "identity", position = "identity",
                               ...,
                               na.rm = FALSE,
                               show.legend = FALSE,
                               inherit.aes = TRUE) {

  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomNFLheads,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      na.rm = na.rm,
      ...
    )
  )
}

#' @rdname nflplotR-package
#' @export
GeomNFLheads <- ggplot2::ggproto(
  "GeomNFLheads", ggplot2::Geom,
  required_aes = c("x", "y", "player_gsis"),
  # non_missing_aes = c(""),
  default_aes = ggplot2::aes(
    alpha = NULL, colour = NULL, angle = 0, hjust = 0.5,
    vjust = 0.5, width = 1.0, height = 1.0
  ),
  draw_panel = function(data, panel_params, coord, na.rm = FALSE) {
    data <- coord$transform(data, panel_params)
    headshots <- load_headshots()

    grobs <- lapply(
      seq_along(data$player_gsis),
      build_grobs,
      alpha = data$alpha,
      colour = data$colour,
      data = data,
      type = "headshots",
      headshot_map = headshots
      )

    class(grobs) <- "gList"

    grid::gTree(children = grobs)
  },
  draw_key = function(...) grid::nullGrob()
)
