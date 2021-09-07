#' ggplot2 Layer for Visualizing NFL Team Logos
#' @inheritParams ggplot2::geom_point
#' @export
#' @examples
#' \donttest{
#' library(ggplot2)
#'
#' team_abbr <- c("ARI", "ATL", "BAL", "BUF", "CAR", "CHI", "CIN", "CLE",
#'                "DAL", "DEN", "DET", "GB",  "HOU", "IND", "JAX", "KC",
#'                "LA",  "LAC", "LV",  "MIA", "MIN", "NE",  "NO",  "NYG",
#'                "NYJ", "PHI", "PIT", "SEA", "SF",  "TB",  "TEN", "WAS")
#'
#' df <- data.frame(
#'   a = runif(length(team_abbr)),
#'   b = runif(length(team_abbr)),
#'   teams = team_abbr
#' )
#'
#' df$alpha <- ifelse(df$teams %in% c("CLE", "PIT", "NE"), 1, 0.2)
#'
#'
#' library(ggplot2)
#'
#' team_abbr <- c("ARI", "ATL", "BAL", "BUF", "CAR", "CHI", "CIN", "CLE",
#'                "DAL", "DEN", "DET", "GB",  "HOU", "IND", "JAX", "KC",
#'                "LA",  "LAC", "LV",  "MIA", "MIN", "NE",  "NO",  "NYG",
#'                "NYJ", "PHI", "PIT", "SEA", "SF",  "TB",  "TEN", "WAS")
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
#'   geom_nfl_logos(aes(team_abbr = teams)) +
#'   geom_label(aes(label = team_abbr), nudge_y = -0.35, alpha = 0.5) +
#'   theme_void()
#'
#' # apply alpha via an aesthetic from inside the dataset `df`
#' ggplot(df, aes(x = a, y = b)) +
#'   geom_nfl_logos(aes(team_abbr = teams, alpha = alpha)) +
#'   geom_label(aes(label = team_abbr), nudge_y = -0.35, alpha = 0.5) +
#'   theme_void()
#'
#' # apply alpha as constant for all logos
#' ggplot(df, aes(x = a, y = b)) +
#'   geom_nfl_logos(aes(team_abbr = teams), alpha = 0.6) +
#'   geom_label(aes(label = team_abbr), nudge_y = -0.35, alpha = 0.5) +
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
    vjust = 0.5, width = 0.1, height = 0.1
  ),
  draw_panel = function(data, panel_params, coord, na.rm = FALSE) {
    data <- coord$transform(data, panel_params)

    grobs <- lapply(seq_along(data$team_abbr), function(i, urls, alpha, data) {
      team_abbr <- data$team_abbr[i]
      if (is.null(alpha)) {
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
