#' Theme Elements for Image Grobs
#'
#' @description
#' In conjunction with the [ggplot2::theme] system, the following `element_`
#' functions enable images in non-data components of the plot, e.g. axis text.
#'
#'   - `element_nfl_logo()`: draws NFL team logos instead of their abbreviations.
#'   - `element_nfl_wordmark()`: draws NFL team wordmarks instead of their abbreviations.
#'   - `element_nfl_headshot()`: draws NFL player headshots instead of their GSIS IDs.
#'   - `element_path()`: draws images from valid image URLs instead of the URL.
#'
#' @inheritParams ggpath::element_path
#' @inheritDotParams ggpath::element_path
#'
#' @details The elements translate NFL team abbreviations or NFL player GSIS IDs
#'   into logo images or player headshots, respectively.
#' @param alpha The alpha channel, i.e. transparency level, as a numerical value
#'   between 0 and 1.
#' @param colour,color The image will be colorized with this color. Use the
#'   special character `"b/w"` to set it to black and white. For more information
#'   on valid color names in ggplot2 see
#'   <https://ggplot2.tidyverse.org/articles/ggplot2-specs.html?q=colour#colour-and-fill>.
#' @param hjust,vjust The horizontal and vertical adjustment respectively.
#'   Must be a numerical value between 0 and 1.
#' @param size The output grob size in `cm` (!).
#' @seealso [geom_nfl_logos()], [geom_nfl_headshots()], [geom_nfl_wordmarks()],
#'   and [geom_from_path()] for more information on valid team abbreviations,
#'   player IDs, and other parameters.
#' @seealso The examples on <https://nflplotr.nflverse.com/articles/nflplotR.html>
#' @return An S3 object of class `element`.
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
#'   theme(axis.text.x = element_nfl_logo())
#'
#' # use logos for y-axis
#' ggplot(df, aes(y = teams, x = random_value)) +
#'   geom_col(aes(color = teams, fill = teams), width = 0.5) +
#'   scale_color_nfl(type = "secondary") +
#'   scale_fill_nfl(alpha = 0.4) +
#'   theme_minimal() +
#'   theme(axis.text.y = element_nfl_logo())
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
#'   theme(axis.text.x = element_nfl_headshot(size = 1))
#'
#' # use headshots for y-axis
#' ggplot(dfh, aes(y = player_gsis, x = random_value)) +
#'   geom_col(width = 0.5) +
#'   theme_minimal() +
#'   theme(axis.text.y = element_nfl_headshot(size = 1))
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
element_nfl_logo <- function(alpha = NULL, colour = NA, hjust = NULL, vjust = NULL,
                             color = NULL, size = 0.5) {
  if (!is.null(color))  colour <- color
  structure(
    list(alpha = alpha, colour = colour, hjust = hjust, vjust = vjust, size = size),
    class = c("element_nfl_logo", "element_text", "element")
  )
}

#' @export
#' @rdname element
element_nfl_wordmark <- function(alpha = NULL, colour = NA, hjust = NULL, vjust = NULL,
                                 color = NULL, size = 0.5) {
  if (!is.null(color))  colour <- color
  structure(
    list(alpha = alpha, colour = colour, hjust = hjust, vjust = vjust, size = size),
    class = c("element_nfl_wordmark", "element_text", "element")
  )
}

#' @export
#' @rdname element
element_nfl_headshot <- function(alpha = NULL, colour = NA, hjust = NULL, vjust = NULL,
                                 color = NULL, size = 0.5) {
  if (!is.null(color))  colour <- color
  structure(
    list(alpha = alpha, colour = colour, hjust = hjust, vjust = vjust, size = size),
    class = c("element_nfl_headshot", "element_text", "element")
  )
}

#' @export
#' @rdname element
element_path <- function(...) ggpath::element_path(...)

#' @export
element_grob.element_nfl_logo <- function(element, label = "", x = NULL, y = NULL,
                                          alpha = NULL, colour = NULL,
                                          hjust = 0.5, vjust = 0.5,
                                          size = NULL, ...) {

  if (is.null(label)) return(ggplot2::zeroGrob())

  n <- max(length(x), length(y), 1)
  vj <- element$vjust %||% vjust
  hj <- element$hjust %||% hjust
  x <- x %||% unit(rep(hj, n), "npc")
  y <- y %||% unit(rep(vj, n), "npc")
  alpha <- alpha %||% element$alpha
  colour <- colour %||% rep(element$colour, n)
  size <- size %||% element$size

  grobs <- lapply(
    seq_along(label),
    axisImageGrob,
    alpha = alpha,
    colour = colour,
    label = label,
    x = x,
    y = y,
    hjust = hj,
    vjust = vj,
    type = "teams"
  )

  class(grobs) <- "gList"

  grid::gTree(
    gp = grid::gpar(),
    children = grobs,
    size = size,
    cl = "axisImageGrob"
  )
}
#' @export
element_grob.element_nfl_wordmark <- function(element, label = "", x = NULL, y = NULL,
                                              alpha = NULL, colour = NULL,
                                              hjust = 0.5, vjust = 0.5,
                                              size = NULL, ...) {

  if (is.null(label)) return(ggplot2::zeroGrob())

  n <- max(length(x), length(y), 1)
  vj <- element$vjust %||% vjust
  hj <- element$hjust %||% hjust
  x <- x %||% unit(rep(hj, n), "npc")
  y <- y %||% unit(rep(vj, n), "npc")
  alpha <- alpha %||% element$alpha
  colour <- colour %||% rep(element$colour, n)
  size <- size %||% element$size

  grobs <- lapply(
    seq_along(label),
    axisImageGrob,
    alpha = alpha,
    colour = colour,
    label = label,
    x = x,
    y = y,
    hjust = hj,
    vjust = vj,
    type = "wordmarks"
  )

  class(grobs) <- "gList"

  grid::gTree(
    gp = grid::gpar(),
    children = grobs,
    size = size,
    cl = "axisImageGrob"
  )
}

#' @export
element_grob.element_nfl_headshot <- function(element, label = "", x = NULL, y = NULL,
                                              alpha = NULL, colour = NULL,
                                              hjust = 0.5, vjust = 0.5,
                                              size = NULL, ...) {

  if (is.null(label)) return(ggplot2::zeroGrob())

  n <- max(length(x), length(y), 1)
  vj <- element$vjust %||% vjust
  hj <- element$hjust %||% hjust
  x <- x %||% unit(rep(hj, n), "npc")
  y <- y %||% unit(rep(vj, n), "npc")
  alpha <- alpha %||% element$alpha
  colour <- colour %||% rep(element$colour, n)
  size <- size %||% element$size

  grobs <- lapply(
    seq_along(label),
    axisImageGrob,
    alpha = alpha,
    colour = colour,
    label = label,
    x = x,
    y = y,
    hjust = hj,
    vjust = vj,
    type = "headshots"
  )

  class(grobs) <- "gList"

  grid::gTree(
    gp = grid::gpar(),
    children = grobs,
    size = size,
    cl = "axisImageGrob"
  )
}

axisImageGrob <- function(i, label, alpha, colour, x, y, hjust, vjust,
                          width = 1, height = 1,
                          type = c("teams", "headshots", "wordmarks")) {
  make_null <- FALSE
  type <- rlang::arg_match(type)
  if(type == "teams") {
    team_abbr <- label[i]
    image_to_read <- logo_list[[team_abbr]]
    if (is.na(team_abbr)) make_null <- TRUE
  } else if(type == "wordmarks") {
    team_abbr <- label[i]
    image_to_read <- wordmark_list[[team_abbr]]
    if (is.na(team_abbr)) make_null <- TRUE
  } else {
    gsis <- label[i]
    headshot_map <- load_headshots()
    image_to_read <- headshot_map$headshot_nfl[headshot_map$gsis_id == gsis]
    if(length(image_to_read) == 0) image_to_read <- na_headshot()
  }
  if (is.na(make_null)){
    return(grid::nullGrob())
  } else if (is.null(alpha[i])) {
    img <- reader_function(image_to_read)
    col <- colour[i]
    if (!is.null(col) && col %in% "b/w"){
      new <- magick::image_quantize(img, colorspace = 'gray')
    } else {
      opa <- ifelse(is.na(col) || is.null(col), 0, 100)
      col <- ifelse(is.na(col) || is.null(col), "none", col)
      new <- magick::image_colorize(img, opa, col)
    }
  } else if (length(alpha) == 1L) {
    if (as.numeric(alpha) <= 0 || as.numeric(alpha) >= 1) {
      cli::cli_abort("aesthetic {.var alpha} requires a value between {.val 0} and {.val 1}")
    }
    img <- reader_function(image_to_read)
    new <- magick::image_fx(img, expression = paste0(alpha, "*a"), channel = "alpha")
    col <- colour[i]
    if (!is.null(col) && col %in% "b/w"){
      new <- magick::image_quantize(new, colorspace = 'gray')
    } else {
      opa <- ifelse(is.na(col) || is.null(col), 0, 100)
      col <- ifelse(is.na(col) || is.null(col), "none", col)
      new <- magick::image_colorize(new, opa, col)
    }
  } else {
    if (any(as.numeric(alpha) < 0) || any(as.numeric(alpha) > 1)) {
      cli::cli_abort("aesthetics {.var alpha} require values between {.val 0} and {.val 1}")
    }
    img <- reader_function(image_to_read)
    new <- magick::image_fx(img, expression = paste0(alpha[i], "*a"), channel = "alpha")
    col <- colour[i]
    if (!is.null(col) && col %in% "b/w"){
      new <- magick::image_quantize(new, colorspace = 'gray')
    } else{
      opa <- ifelse(is.na(col) || is.null(col), 0, 100)
      col <- ifelse(is.na(col) || is.null(col), "none", col)
      new <- magick::image_colorize(new, opa, col)
    }
  }

  grid <- grid::rasterGrob(new, just = c(hjust, vjust))

  grid$vp <- grid::viewport(
    x = grid::unit(x[i], "npc"),
    y = grid::unit(y[i], "npc"),
    width = grid::unit(width, "npc"),
    height = grid::unit(height, "npc")
    # angle = data$angle[i],
  )

  grid

}

#' @export
grobHeight.axisImageGrob <- function(x, ...) grid::unit(x$size, "cm")

#' @export
grobWidth.axisImageGrob <- function(x, ...) grid::unit(x$size, "cm")
