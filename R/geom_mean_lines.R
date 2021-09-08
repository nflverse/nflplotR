#' @export
#' @rdname geom_median_lines
geom_mean_lines <- function(mapping = NULL, data = NULL,
                            ...,
                            na.rm = FALSE,
                            show.legend = NA,
                            inherit.aes = TRUE) {

  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = ggplot2::StatIdentity,
    geom = GeomMeanLines,
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

GeomMeanLines <- ggplot2::ggproto("GeomMeanLines", ggplot2::Geom,
  optional_aes = c("v_var", "h_var"),
  default_aes = ggplot2::aes(
    colour = "red", size = 0.5, linetype = 2, alpha = NA
  ),
  draw_panel = function(data, panel_params, coord, na.rm = FALSE, ...) {
    data <- data_h <- data_v <- coord$transform(data, panel_params)

    args <- names(data)

    if (all(!c("v_var", "h_var") %in% args)) {
      cli::cli_abort("{.var geom_median_lines()} requires at least one of the following aesthetics: {.var v_var}, {.var h_var}")
    }
    if (!"v_var" %in% args) data$v_var <- NA
    if (!"h_var" %in% args) data$h_var <- NA

    data_v$xintercept <- mean(data$v_var, na.rm = na.rm, ...)
    data_h$yintercept <- mean(data$h_var, na.rm = na.rm, ...)

    message("test")

    if (!"v_var" %in% args) {
      ggplot2::GeomHline$draw_panel(unique(data_h), panel_params, coord)
    } else if (!"h_var" %in% args) {
      ggplot2::GeomVline$draw_panel(unique(data_v), panel_params, coord)
    } else {
      grid::gList(
        ggplot2::GeomHline$draw_panel(unique(data_h), panel_params, coord),
        ggplot2::GeomVline$draw_panel(unique(data_v), panel_params, coord)
      )
    }
  },
  draw_key = ggplot2::draw_key_path
)
