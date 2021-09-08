#' ggplot2 Layer for Horizontal and Vertical Reference Lines
#'
#' @description These geoms can be used to draw horizontal or vertical reference
#'   lines in a ggplot. They use the data in the aesthetics `v_var` and `h_var`
#'   to compute their `median` or `mean` and draw the as a line.
#'
#' @inheritParams ggplot2::geom_hline
#' @section Aesthetics:
#' `geom_median_lines()` and `geom_mean_lines()` understand the following
#' aesthetics (at least one of the bold aesthetics is required):
#' \itemize{
#'   \item{**v_var**}{ - The variable for which to compute the median/mean that is drawn as vertical line.}
#'   \item{**h_var**}{ - TThe variable for which to compute the median/mean that is drawn as horizontal line.}
#'   \item{`alpha = NA`}{ - The alpha channel, i.e. transparency level, as a numerical value between 0 and 1.}
#'   \item{`color = "red"`}{ - The color of the drawn lines.}
#'   \item{`linetype = 2`}{ - The linetype of the drawn lines.}
#'   \item{`size = 0.5`}{ - The size of the drawn lines.}
#' }
#' @seealso The underlying ggplot2 geoms [`geom_hline()`] and [`geom_vline()`]
#' @export
#' @examples
#' library(nflplotR)
#' library(ggplot2)
#'
#' # inherit top level aesthetics
#' ggplot(mtcars, aes(x = disp, y = mpg, h_var = mpg, v_var = disp)) +
#'   geom_point() +
#'   geom_median_lines() +
#'   geom_mean_lines(color = "blue") +
#'   theme_minimal()
#'
#' # draw horizontal line only
#' ggplot(mtcars, aes(x = disp, y = mpg, h_var = mpg)) +
#'   geom_point() +
#'   geom_median_lines() +
#'   geom_mean_lines(color = "blue") +
#'   theme_minimal()
#'
#' # draw vertical line only
#' ggplot(mtcars, aes(x = disp, y = mpg, v_var = disp)) +
#'   geom_point() +
#'   geom_median_lines() +
#'   geom_mean_lines(color = "blue") +
#'   theme_minimal()
#'
#' # choose your own value
#' ggplot(mtcars, aes(x = disp, y = mpg)) +
#'   geom_point() +
#'   geom_median_lines(v_var = 400, h_var = 15) +
#'   geom_mean_lines(v_var = 150, h_var = 30, color = "blue") +
#'   theme_minimal()
geom_median_lines <- function(mapping = NULL, data = NULL,
                              ...,
                              na.rm = FALSE,
                              show.legend = NA,
                              inherit.aes = TRUE) {

  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = ggplot2::StatIdentity,
    geom = GeomMedianLines,
    position = ggplot2::PositionIdentity,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      na.rm = na.rm,
      fun = median,
      ...
    )
  )
}

GeomMedianLines <- ggplot2::ggproto("GeomMedianLines", ggplot2::Geom,
  optional_aes = c("v_var", "h_var"),
  default_aes = ggplot2::aes(
    colour = "red", size = 0.5, linetype = 2, alpha = NA
  ),
  draw_panel = function(data, panel_params, coord, na.rm = FALSE, ...) {
    data <- data_h <- data_v <- coord$transform(data, panel_params)

    args <- names(data)

    if (all(!c("v_var", "h_var") %in% args)){
      cli::cli_abort("{.var geom_median_lines()} requires at least one of the following aesthetics: {.var v_var}, {.var h_var}")
    }
    if (!"v_var" %in% args) data$v_var <- NA
    if (!"h_var" %in% args) data$h_var <- NA

    data_v$xintercept <- median(data$v_var, na.rm = na.rm, ...)
    data_h$yintercept <- median(data$h_var, na.rm = na.rm, ...)

    message("test")

    if (!"v_var" %in% args){
      ggplot2::GeomHline$draw_panel(unique(data_h), panel_params, coord)
    } else if (!"h_var" %in% args) {
      ggplot2::GeomVline$draw_panel(unique(data_v), panel_params, coord)
    } else{
      grid::gList(
        ggplot2::GeomHline$draw_panel(unique(data_h), panel_params, coord),
        ggplot2::GeomVline$draw_panel(unique(data_v), panel_params, coord)
      )
    }
  },

  draw_key = ggplot2::draw_key_path
)
