# Color and Fill Scales ---------------------------------------------------

#' Scales for NFL Team Colors
#'
#' @description These functions map NFL team names to their team colors in
#'   color and fill aesthetics
#' @inheritParams ggplot2::scale_fill_manual
#' @param type One of `"primary"` or `"secondary"` to decide which colortype to use.
#' @param values If `NULL` (the default) use the internal team color vectors. Otherwise
#'   a set of aesthetic values to map data values to. The values
#'   will be matched in order (usually alphabetical) with the limits of the
#'   scale, or with `breaks` if provided. If this is a named vector, then the
#'   values will be matched based on the names instead. Data values that don't
#'   match will be given `na.value`.
#' @param guide A function used to create a guide or its name. If `NULL` (the default)
#'   no guide will be plotted for this scale. See [ggplot2::guides()] for more information.
#' @param alpha Factor to modify color transparency via a call to [`scales::alpha()`].
#'   If `NA` (the default) no transparency will be applied. Can also be a vector of
#'   alphas. All alpha levels must be in range `[0,1]`.
#' @name scale_nfl
#' @aliases NULL
#' @examples
#' \donttest{
#' library(nflplotR)
#' library(ggplot2)
#'
#' team_abbr <- valid_team_names()
#' # remove conference logos from this example
#' team_abbr <- team_abbr[!team_abbr %in% c("AFC", "NFC", "NFL")]
#'
#' df <- data.frame(
#'   random_value = runif(length(team_abbr), 0, 1),
#'   teams = team_abbr
#' )
#' ggplot(df, aes(x = teams, y = random_value)) +
#'   geom_col(aes(color = teams, fill = teams), width = 0.5) +
#'   scale_color_nfl(type = "secondary") +
#'   scale_fill_nfl(alpha = 0.4) +
#'   theme_minimal() +
#'   theme(axis.text.x = element_text(angle = 45, hjust = 1))
#' }
NULL

#' @rdname scale_nfl
#' @export
scale_color_nfl <- function(type = c("primary", "secondary"),
                            values = NULL,
                            ...,
                            aesthetics = "colour",
                            breaks = ggplot2::waiver(),
                            na.value = "grey50",
                            guide = NULL,
                            alpha = NA) {

  type <- rlang::arg_match(type)

  if(is.null(values)){
    values <- switch(type,
      "primary" = primary_colors,
      "secondary" = secondary_colors
    )
  }

  if(!is.na(alpha)) values <- scales::alpha(values, alpha = alpha)

  ggplot2::scale_color_manual(
    ...,
    values = values,
    aesthetics = aesthetics,
    breaks = breaks,
    na.value = na.value,
    guide = guide
  )
}

#' @rdname scale_nfl
#' @export
scale_colour_nfl <- scale_color_nfl


#' @rdname scale_nfl
#' @export
scale_fill_nfl <- function(type = c("primary", "secondary"),
                           values = NULL,
                           ...,
                           aesthetics = "fill",
                           breaks = ggplot2::waiver(),
                           na.value = "grey50",
                           guide = NULL,
                           alpha = NA) {

  type <- rlang::arg_match(type)

  if(is.null(values)){
    values <- switch(type,
      "primary" = primary_colors,
      "secondary" = secondary_colors
    )
  }

  if(!is.na(alpha)) values <- scales::alpha(values, alpha = alpha)

  ggplot2::scale_fill_manual(
    ...,
    values = values,
    aesthetics = aesthetics,
    breaks = breaks,
    na.value = na.value,
    guide = guide
  )
}


# Axis Scales -------------------------------------------------------------

#' Axis Scales for NFL Team Logos
#'
#' @description These functions map NFL team names to their team logos and make
#'   them available as axis labels
#' @details The scale translates the NFL team abbreviations into raw image
#'   html and places the html as axis labels. Because of the way ggplots are
#'   constructed, it is necessary to adjust the [`theme()`] after calling this
#'   scale. This can be done by calling [`theme_x_nfl()`] or [`theme_y_nfl()`]
#'   or alternatively by manually changing the relevant `axis.text` to
#'   [`ggtext::element_markdown()`]. However, this will only work if an underlying
#'   dependency, "gridtext", is installed with a newer version than 0.1.4
#' @inheritParams ggplot2::scale_x_discrete
#' @param size The logo size in pixels. It is applied as height for an x-scale
#'   and as width for an y-scale.
#' @name scale_axes_nfl
#' @return A discrete ggplot2 scale created with [ggplot2::scale_x_discrete()] or
#'   [ggplot2::scale_y_discrete()].
#' @aliases NULL
#' @seealso [`theme_x_nfl()`], [`theme_y_nfl()`]
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
#'   random_value = runif(length(team_abbr), 0, 1),
#'   teams = team_abbr
#' )
#'
#' if (utils::packageVersion("gridtext") > "0.1.4" && FALSE){
#'   # use logos for x-axis
#'   ggplot(df, aes(x = teams, y = random_value)) +
#'     geom_col(aes(color = teams, fill = teams), width = 0.5) +
#'     scale_color_nfl(type = "secondary") +
#'     scale_fill_nfl(alpha = 0.4) +
#'     scale_x_nfl() +
#'     theme_minimal() +
#'     # theme_*_nfl requires gridtext version > 0.1.4
#'     theme_x_nfl()
#'
#'   # use logos for y-axis
#'   ggplot(df, aes(y = teams, x = random_value)) +
#'     geom_col(aes(color = teams, fill = teams), width = 0.5) +
#'     scale_color_nfl(type = "secondary") +
#'     scale_fill_nfl(alpha = 0.4) +
#'     scale_y_nfl() +
#'     theme_minimal() +
#'     # theme_*_nfl requires gridtext version > 0.1.4
#'     theme_y_nfl()
#'}
#' #############################################################################
#' # Headshot Examples
#' #############################################################################
#' library(nflplotR)
#' library(ggplot2)
#'
#' # Silence an nflreadr message that is irrelevant here
#' old <- options(nflreadr.cache_warning = FALSE)
#'
#' dfh <- data.frame(
#'   random_value = runif(9, 0, 1),
#'   player_gsis = c("00-0033873",
#'                   "00-0026498",
#'                   "00-0035228",
#'                   "00-0031237",
#'                   "00-0036355",
#'                   "00-0019596",
#'                   "00-0033077",
#'                   "00-0012345",
#'                   "00-0031280")
#' )
#'
#' if (utils::packageVersion("gridtext") > "0.1.4" && FALSE){
#'   # use headshots for x-axis
#'   ggplot(dfh, aes(x = player_gsis, y = random_value)) +
#'     geom_col(width = 0.5) +
#'     scale_x_nfl_headshots() +
#'     theme_minimal() +
#'     # theme_*_nfl requires gridtext version > 0.1.4
#'     theme_x_nfl()
#'
#'   # use headshots for y-axis
#'   ggplot(dfh, aes(y = player_gsis, x = random_value)) +
#'     geom_col(width = 0.5) +
#'     scale_y_nfl_headshots() +
#'     theme_minimal() +
#'     # theme_*_nfl requires gridtext version > 0.1.4
#'     theme_y_nfl()
#'}
#' # Restore old options
#' options(old)
#' }
NULL

#' @rdname scale_axes_nfl
#' @export
scale_x_nfl <- function(...,
                        expand = ggplot2::waiver(),
                        guide = ggplot2::waiver(),
                        position = "bottom",
                        size = 12) {

  position <- rlang::arg_match0(position, c("top", "bottom"))

  ggplot2::scale_x_discrete(
    ...,
    labels = function(x) {
      logo_html(x, type = "height", size = size)
    },
    expand = expand,
    guide = guide,
    position = position
  )
}

#' @rdname scale_axes_nfl
#' @export
scale_y_nfl <- function(...,
                        expand = ggplot2::waiver(),
                        guide = ggplot2::waiver(),
                        position = "left",
                        size = 12) {

  position <- rlang::arg_match0(position, c("left", "right"))

  ggplot2::scale_y_discrete(
    ...,
    labels = function(x) {
      logo_html(x, type = "width", size = size)
    },
    expand = expand,
    guide = guide,
    position = position
  )
}

#' @rdname scale_axes_nfl
#' @export
scale_x_nfl_headshots <- function(...,
                                  expand = ggplot2::waiver(),
                                  guide = ggplot2::waiver(),
                                  position = "bottom",
                                  size = 20) {

  position <- rlang::arg_match0(position, c("top", "bottom"))

  ggplot2::scale_x_discrete(
    ...,
    labels = function(x) {
      headshot_html(x, type = "height", size = size)
    },
    expand = expand,
    guide = guide,
    position = position
  )
}

#' @rdname scale_axes_nfl
#' @export
scale_y_nfl_headshots <- function(...,
                                  expand = ggplot2::waiver(),
                                  guide = ggplot2::waiver(),
                                  position = "left",
                                  size = 30) {

  position <- rlang::arg_match0(position, c("left", "right"))

  ggplot2::scale_y_discrete(
    ...,
    labels = function(x) {
      headshot_html(x, type = "width", size = size)
    },
    expand = expand,
    guide = guide,
    position = position
  )
}
