#' ggplot2 Layer for Visualizing Images from URLs or Local Paths
#'
#' @description This geom is used to plot images instead
#'   of points in a ggplot. It requires x, y aesthetics as well as a path.
#'   It has been outsourced to ggpath and is re-exported in nflplotR for
#'   compatibility reasons.
#'
#' @inherit ggpath::geom_from_path
#' @inheritDotParams ggpath::geom_from_path
#' @details This function has been outsourced to the ggpath package.
#' See [`ggpath::geom_from_path`] for details.
#' @export
#' @examplesIf requireNamespace("rsvg", quietly = TRUE)
#' # example code
#'
#' \donttest{
#' library(ggplot2)
#' library(nflplotR)
#'
#' # create x-y-coordinates of a pentagon and add nflverse logo urls
#' df <- data.frame(
#'   a = c(sin(2 * pi * (0:4) / 5), 0),
#'   b = c(cos(2 * pi * (0:4) / 5), 0),
#'   url = c(
#'     "https://github.com/nflverse/nflfastR/raw/master/man/figures/logo.png",
#'     "https://github.com/nflverse/nflseedR/raw/master/man/figures/logo.png",
#'     "https://github.com/nflverse/nfl4th/raw/master/man/figures/logo.png",
#'     "https://github.com/nflverse/nflreadr/raw/main/data-raw/logo.svg",
#'     "https://github.com/nflverse/nflplotR/raw/main/man/figures/logo.png",
#'     "https://github.com/nflverse/nflverse/raw/main/man/figures/logo.png"
#'   )
#' )
#'
#' # plot images directly from url
#' ggplot(df, aes(x = a, y = b)) +
#'   geom_from_path(aes(path = url), width = 0.15) +
#'   coord_cartesian(xlim = c(-2, 2), ylim = c(-1.3, 1.5)) +
#'   theme_void()
#'
#' # plot images directly from url and apply transparency
#' ggplot(df, aes(x = a, y = b)) +
#'   geom_from_path(aes(path = url), width = 0.15, alpha = 0.5) +
#'   coord_cartesian(xlim = c(-2, 2), ylim = c(-1.3, 1.5)) +
#'   theme_void()
#'
#' # It is also possible and recommended to use the underlying Geom inside a
#' # ggplot2 annotation
#' ggplot() +
#'   annotate(
#'     ggpath::GeomFromPath,
#'     x = 0,
#'     y = 0,
#'     path = "https://github.com/nflverse/nflplotR/raw/main/man/figures/logo.png",
#'     width = 0.4
#'   ) +
#'   theme_minimal()
#' }
geom_from_path <- function(...) ggpath::geom_from_path(...)
