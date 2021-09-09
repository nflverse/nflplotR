#' Scales for NFL Team Colors
#'
#' @description These functions allows you to map college football team names as levels to the color and fill aesthetics
#' @inheritParams ggplot2::scale_fill_manual
#' @param type One of `"primary"` or `"secondary"` to decide which colortype to use.
#' @param values If `NULL` (the default) use the internal team color vectors. Otherwise
#'   a set of aesthetic values to map data values to. The values
#'   will be matched in order (usually alphabetical) with the limits of the
#'   scale, or with `breaks` if provided. If this is a named vector, then the
#'   values will be matched based on the names instead. Data values that don't
#'   match will be given `na.value`.
#'
#' @name scale_nfl
#' @aliases NULL
#' @examples
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
#' ggplot(df, aes(x = teams, y = random_value)) +
#'   geom_col(aes(color = teams, fill = teams), width = 0.5) +
#'   scale_color_nfl(type = "secondary") +
#'   scale_fill_nfl() +
#'   theme_minimal() +
#'   theme(axis.text.x = element_text(angle = 45, hjust = 1))
NULL

#' @rdname scale_nfl
#' @export
scale_color_nfl <- function(type = c("primary", "secondary"),
                            values = NULL,
                            ...,
                            aesthetics = "colour",
                            breaks = ggplot2::waiver(),
                            na.value = "grey50",
                            guide = NULL) {

  type <- rlang::arg_match(type)

  if(is.null(values)){
    values <- switch(type,
      "primary" = primary_colors,
      "secondary" = secondary_colors
    )
  }

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
                           guide = NULL) {

  type <- rlang::arg_match(type)

  if(is.null(values)){
    values <- switch(type,
      "primary" = primary_colors,
      "secondary" = secondary_colors
    )
  }

  ggplot2::scale_fill_manual(
    ...,
    values = values,
    aesthetics = aesthetics,
    breaks = breaks,
    na.value = na.value,
    guide = guide
  )
}