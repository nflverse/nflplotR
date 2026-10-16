#' Theme Elements for Image Grobs
#'
#' @description
#' In conjunction with the [ggplot2::theme] system, the following `element_`
#' functions enable images in non-data components of the plot, e.g. axis text.
#'
#'   - `element_nfl_logo()`: draws NFL team logos instead of their abbreviations.
#'   - `element_nfl_wordmark()`: draws NFL team wordmarks instead of their abbreviations.
#'   - `element_nfl_headshot()`: draws NFL player headshots instead of their GSIS IDs.
#'   - [`ggpath::element_path()`]:  draws images from valid image URLs instead of the URL.
#'
#' @details The elements translate NFL team abbreviations or NFL player GSIS IDs
#'   into logo images or player headshots, respectively.
#'
#' @inheritParams ggpath::element_path
#' @seealso [geom_nfl_logos()], [geom_nfl_headshots()], [geom_nfl_wordmarks()],
#'   and [geom_from_path()] for more information on valid team abbreviations,
#'   player IDs, and other parameters.
#' @seealso The examples on <https://nflplotr.nflverse.com/articles/nflplotR.html>
#' @return An S7 object of class `element`.
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
#'
#' # use logos for x-axis
#' ggplot(df, aes(x = teams, y = random_value)) +
#'   geom_col(aes(color = teams, fill = teams), width = 0.5) +
#'   scale_color_nfl(type = "secondary") +
#'   scale_fill_nfl(alpha = 0.4) +
#'   theme_minimal() +
#'   theme(axis.text.x.bottom = element_nfl_logo())
#'
#' # use logos for y-axis
#' ggplot(df, aes(y = teams, x = random_value)) +
#'   geom_col(aes(color = teams, fill = teams), width = 0.5) +
#'   scale_color_nfl(type = "secondary") +
#'   scale_fill_nfl(alpha = 0.4) +
#'   theme_minimal() +
#'   theme(axis.text.y.left = element_nfl_logo())
#'
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
#' # use headshots for x-axis
#' ggplot(dfh, aes(x = player_gsis, y = random_value)) +
#'   geom_col(width = 0.5) +
#'   theme_minimal() +
#'   theme(axis.text.x.bottom = element_nfl_headshot(size = 1))
#'
#' # use headshots for y-axis
#' ggplot(dfh, aes(y = player_gsis, x = random_value)) +
#'   geom_col(width = 0.5) +
#'   theme_minimal() +
#'   theme(axis.text.y.left = element_nfl_headshot(size = 1))
#'
#' # Restore old options
#' options(old)
#'
#' #############################################################################
#' # Wordmarks and other Images
#' #############################################################################
#'
#' library(ggplot2)
#'
#' dt <- data.table::as.data.table(mtcars)[,
#'   `:=`(
#'     team = sample(c("LAC", "BUF", "DAL", "ARI"), nrow(mtcars), TRUE),
#'     player = sample(
#'       c("00-0033873", "00-0035228", "00-0036355", "00-0019596"),
#'       nrow(mtcars),
#'       TRUE
#'     )
#'   )
#' ]
#'
#' ggplot(dt, aes(x = mpg, y = disp)) +
#'   geom_point() +
#'   facet_wrap(vars(team)) +
#'   labs(
#'     title = tools::toTitleCase("These are random teams and data"),
#'     subtitle = "I just want to show how the nflplotR theme elements work",
#'     caption = "https://github.com/nflverse/nflseedR/raw/master/man/figures/caption.png"
#'   ) +
#'   theme_minimal() +
#'   theme(
#'     plot.title.position = "plot",
#'     plot.title = element_text(face = "bold"),
#'     axis.title = element_blank(),
#'     # make wordmarks of team abbreviations
#'     strip.text = element_nfl_wordmark(size = 1),
#'     # load image from url in caption
#'     plot.caption = element_path(hjust = 1, size = 0.4)
#'   )
#' }
#' @name element
#' @aliases NULL
NULL

#' @export
#' @rdname element
element_nfl_logo <- S7::new_class("element_nfl_logo", ggpath::element_path)

#' @export
#' @rdname element
element_nfl_wordmark <- S7::new_class(
  "element_nfl_wordmark",
  ggpath::element_path
)

#' @export
#' @rdname element
element_nfl_headshot <- S7::new_class(
  "element_nfl_headshot",
  ggpath::element_path
)

#' @export
#' @importFrom ggpath element_path
ggpath::element_path

S7::method(element_grob, element_nfl_logo) <- function(
  element,
  label = "",
  x = NULL,
  y = NULL,
  ...,
  lookup_list = logo_list
) {
  abbrs <- suppressWarnings(
    nflreadr::clean_team_abbrs(as.character(label), keep_non_matches = TRUE)
  )

  image_list <- lookup_list[abbrs]

  image_missing <- vapply(image_list, is.null, FUN.VALUE = logical(1L))

  if (any(image_missing)) {
    label_missing <- abbrs[image_missing]
    cli::cli_alert_warning(
      "Can't find team abbreviation{?s} {.val {label_missing}}. \\
      Will insert empty graphic object{?s}."
    )
  }

  # This will likely break in a future ggplot2 release as they
  # currently work with a weird mix of S3 and S7. element_grob is a S3 generic
  # but the methods are S7. However, I can't call the method from ggpath with
  # S7::method(element_grob, ggpath::element_path)(...)
  # I think this should work and probably will work at some point in the future
  # in the meantime I change the class of element to dispatch to the ggpath
  # method for further processing.
  class(element) <- c(
    "ggpath::element_path",
    "ggplot2::element_text",
    "ggplot2::element",
    "S7_object"
  )

  ggplot2::element_grob(
    element = element,
    label = image_list,
    x = x,
    y = y
  )
}

S7::method(element_grob, element_nfl_wordmark) <- function(
  element,
  label = "",
  x = NULL,
  y = NULL,
  ...
) {
  # see comment on weird S3/S7 mix in the above method
  # Note that I dispatch to the nflplotR method here before we move on
  # to ggpath
  class(element) <- c(
    "nflplotR::element_nfl_logo",
    "ggpath::element_path",
    "ggplot2::element_text",
    "ggplot2::element",
    "S7_object"
  )

  ggplot2::element_grob(
    element = element,
    label = label,
    x = x,
    y = y,
    ...,
    lookup_list = wordmark_list
  )
}

S7::method(element_grob, element_nfl_headshot) <- function(
  element,
  label = "",
  x = NULL,
  y = NULL,
  ...
) {
  headshots_df <- load_headshots()
  headshots <- setNames(headshots_df$headshot_nfl, headshots_df$gsis_id)

  image_urls <- headshots[label]

  if (any(is.na(image_urls))) {
    label_missing <- label[is.na(image_urls)]
    cli::cli_alert_warning(
      "No headshot available for gsis ID{?s} {.val {label_missing}}. \\
      Will insert placeholder{?s}."
    )
    image_urls[is.na(image_urls)] <- na_headshot()
  }

  # see comment on weird S3/S7 mix in the above method
  class(element) <- c(
    "ggpath::element_path",
    "ggplot2::element_text",
    "ggplot2::element",
    "S7_object"
  )

  ggplot2::element_grob(
    element = element,
    label = image_urls,
    x = x,
    y = y
  )
}
