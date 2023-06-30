#' ggplot2 Layer for Horizontal and Vertical Reference Lines
#'
#' @description These geoms can be used to draw horizontal or vertical reference
#'   lines in a ggplot. They use the data in the aesthetics `x0` and `y0`
#'   to compute their `median` or `mean` and draw them as a line.
#'
#' @inherit ggpath::geom_mean_lines
#' @inheritDotParams ggpath::geom_mean_lines
#' @inheritDotParams ggpath::geom_median_lines
#'
#' @seealso The underlying ggplot2 geoms [`geom_hline()`] and [`geom_vline()`]
#' @details These functions have been outsourced to the ggpath package.
#' See [`ggpath::geom_median_lines`] and [`ggpath::geom_mean_lines`] for details.
#'
#' @name geom_lines
NULL

#' @rdname geom_lines
#' @export
geom_median_lines <- function(...) ggpath::geom_median_lines(...)

#' @rdname geom_lines
#' @export
geom_mean_lines <- function(...) ggpath::geom_mean_lines(...)
