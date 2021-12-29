#' Theme elements
#'
#' @description
#' In conjunction with the \link{theme} system, the `element_` functions
#' specify the display of how non-data components of the plot are drawn.
#'
#'   - `element_blank()`: draws nothing, and assigns no space.
#'   - `element_rect()`: borders and backgrounds.
#'   - `element_line()`: lines.
#'   - `element_text()`: text.
#'
#' `rel()` is used to specify sizes relative to the parent,
#' `margin()` is used to specify the margins of elements.
#'
#' @param fill Fill colour.
#' @param colour,color Line/border colour. Color is an alias for colour.
#' @param size Line/border size in mm; text size in pts.
#' @param inherit.blank Should this element inherit the existence of an
#'   `element_blank` among its parents? If `TRUE` the existence of
#'   a blank element among its parents will cause this element to be blank as
#'   well. If `FALSE` any blank parent element will be ignored when
#'   calculating final element state.
#' @return An S3 object of class `element`, `rel`, or `margin`.
#' @examples
#' plot <- ggplot(mpg, aes(displ, hwy)) + geom_point()
#'
#' plot + theme(
#'   panel.background = element_blank(),
#'   axis.text = element_blank()
#' )
#'
#' plot + theme(
#'   axis.text = element_text(colour = "red", size = rel(1.5))
#' )
#'
#' plot + theme(
#'   axis.line = element_line(arrow = arrow())
#' )
#'
#' plot + theme(
#'   panel.background = element_rect(fill = "white"),
#'   plot.margin = margin(2, 2, 2, 2, "cm"),
#'   plot.background = element_rect(
#'     fill = "grey90",
#'     colour = "black",
#'     size = 1
#'   )
#' )
#' @name element
#' @aliases NULL
NULL

#' @export
# @rdname element
element_image <- function(family = NULL, face = NULL, colour = NULL,
                          size = NULL, hjust = NULL, vjust = NULL, angle = NULL, lineheight = NULL,
                          color = NULL, margin = NULL, debug = NULL, inherit.blank = FALSE) {

  if (!is.null(color))  colour <- color
  if (is.null(arrow)) arrow <- FALSE
  structure(
    list(family = family, face = face, colour = colour, size = size,
         hjust = hjust, vjust = vjust, angle = angle, lineheight = lineheight,
         margin = margin, debug = debug, inherit.blank = inherit.blank),
    class = c("element_image", "element_text", "element")
  )
}

#' @export
element_grob.element_image <- function(element, label = "", x = NULL, y = NULL,
                                       type = "nfl_teams", colour = NULL, width = NULL, height = NULL,
                                       hjust = NULL, vjust = NULL, angle = NULL, lineheight = NULL,
                                       margin = NULL, margin_x = FALSE, margin_y = FALSE, ...) {

  if (is.null(label))
    return(ggplot2::zeroGrob())

  # n <- length(label)
  # print(n)
  print(label)
  # img <- magick::image_read("https://github.com/nflverse/nflplotR/raw/main/man/figures/logo.png")
  # print(img)
  # grobs <- grid::rasterGrob(img)
  # print(grobs)
  # return(
  #   grid::gTree(
  #     gp = grid::gpar(),
  #     children = do.call(grid::gList, grobs),
  #     cl = "sebs_axis"
  #   )
  # )

  grobs <- lapply(
    seq_along(label),
    axisImageGrob,
    alpha = NULL,
    colour = NULL,
    data = data.frame(team_abbr = label, angle = 0, hjust = 0.5,
                      vjust = 0.5, width = 1.0, height = 1.0),
    type = "teams"
  )

  class(grobs) <- "gList"

  return(
    grid::gTree(
      gp = grid::gpar(),
      children = grobs,
      cl = "axisImageGrob"
  ))

  vj <- vjust %||% element$vjust
  hj <- hjust %||% element$hjust
  margin <- margin %||% element$margin

  angle <- angle %||% element$angle %||% 0

  # The gp settings can override element_gp
  gp <- gpar(fontsize = size, col = colour,
             fontfamily = family, fontface = face,
             lineheight = lineheight)
  element_gp <- gpar(fontsize = element$size, col = element$colour,
                     fontfamily = element$family, fontface = element$face,
                     lineheight = element$lineheight)

  titleGrob(label, x, y, hjust = hj, vjust = vj, angle = angle,
            gp = modify_list(element_gp, gp), margin = margin,
            margin_x = margin_x, margin_y = margin_y, debug = element$debug, ...)
}

#' Draw formatted text labels
#'
#' This grob acts mostly as a drop-in replacement for [`grid::textGrob()`]
#' but provides more sophisticated formatting. The grob can handle basic
#' markdown and HTML formatting directives, and it can also draw
#' boxes around each piece of text. Note that this grob **does not** draw
#' [plotmath] expressions.
#'
#'@export
axisImageGrob <- function(i, alpha, colour, data, type = c("teams", "headshots", "wordmarks", "path")) {
  make_null <- FALSE
  type <- rlang::arg_match(type)
  if(type == "teams") {
    team_abbr <- data$team_abbr[i]
    image_to_read <- logo_list[[team_abbr]]
    if (is.na(team_abbr)) make_null <- TRUE
  } else if(type == "wordmarks") {
    team_abbr <- data$team_abbr[i]
    image_to_read <- wordmark_list[[team_abbr]]
    if (is.na(team_abbr)) make_null <- TRUE
  } else if (type == "path"){
    image_to_read <- data$path[i]
  } else {
    gsis <- data$player_gsis[i]
    headshot_map <- load_headshots()
    image_to_read <- headshot_map$headshot_nfl[headshot_map$gsis_id == gsis]
    if(length(image_to_read) == 0) image_to_read <- na_headshot()
  }
  if (is.na(make_null)){
    grid <- grid::nullGrob()
  } else if (is.null(alpha)) {
    img <- magick::image_read(image_to_read)
    col <- colour[i]
    if (!is.null(col) && col %in% "b/w"){
      new <- magick::image_quantize(img, colorspace = 'gray')
    } else{
      opa <- ifelse(is.na(col) || is.null(col), 0, 100)
      col <- ifelse(is.na(col) || is.null(col), "none", col)
      new <- magick::image_colorize(img, opa, col)
    }
    grid <- grid::rasterGrob(new)
  } else if (length(alpha) == 1L) {
    if (as.numeric(alpha) <= 0 || as.numeric(alpha) >= 1) {
      cli::cli_abort("aesthetic {.var alpha} requires a value between {.val 0} and {.val 1}")
    }
    img <- magick::image_read(image_to_read)
    new <- magick::image_fx(img, expression = paste0(alpha, "*a"), channel = "alpha")
    col <- colour[i]
    if (!is.null(col) && col %in% "b/w"){
      new <- magick::image_quantize(new, colorspace = 'gray')
    } else{
      opa <- ifelse(is.na(col) || is.null(col), 0, 100)
      col <- ifelse(is.na(col) || is.null(col), "none", col)
      new <- magick::image_colorize(new, opa, col)
    }
    grid <- grid::rasterGrob(new)
  } else {
    if (any(as.numeric(alpha) < 0) || any(as.numeric(alpha) > 1)) {
      cli::cli_abort("aesthetics {.var alpha} require values between {.val 0} and {.val 1}")
    }
    img <- magick::image_read(image_to_read)
    new <- magick::image_fx(img, expression = paste0(alpha[i], "*a"), channel = "alpha")
    col <- colour[i]
    if (!is.null(col) && col %in% "b/w"){
      new <- magick::image_quantize(new, colorspace = 'gray')
    } else{
      opa <- ifelse(is.na(col) || is.null(col), 0, 100)
      col <- ifelse(is.na(col) || is.null(col), "none", col)
      new <- magick::image_colorize(new, opa, col)
    }
    grid <- grid::rasterGrob(new)
  }

  grid$vp <- grid::viewport(
    x = grid::unit(0.5, "npc"),
    y = grid::unit(0.5, "npc"),
    width = grid::unit(data$width[i], "npc"),
    height = grid::unit(data$height[i], "npc"),
    just = c(data$hjust[i], data$vjust[i]),
    angle = data$angle[i],
    # name = paste("geom_nfl.panel", data$PANEL[i],
    #              "row", i,
    #              sep = "."
    # )
  )

  grid$name <- paste("nfl.grob", i, sep = ".")

  grid
}

#' @export
grobHeight.axisImageGrob <- function(x, ...) unit(6, "lines")

#' @export
heightDetails.axisImageGrob <- function(x, ...) unit(6, "lines")
