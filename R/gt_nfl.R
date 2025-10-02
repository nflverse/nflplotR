#' Render Logos and Wordmarks in 'gt' Tables
#'
#' @description Translate NFL team abbreviations into logos and wordmarks and
#'   render these images in html tables with the 'gt' package.
#' @param gt_object A table object that is created using the [gt::gt()] function.
#' @param columns The columns for which the image translation should be applied.
#'   Argument has no effect if `locations` is not `NULL`.
#' @param height The absolute height (px) of the image in the table cell.
#' @param locations If `NULL` (the default), the function will render
#'   logos/wordmarks in argument `columns`.
#'   Otherwise, the cell or set of cells to be associated with the team name
#'   transformation. Only the [gt::cells_body()], [gt::cells_stub()],
#'   [gt::cells_column_labels()], and [gt::cells_row_groups()] helper functions
#'   can be used here. We can enclose several of these calls within a `list()`
#'   if we wish to make the transformation happen at different locations.
#'
#' @return An object of class `gt_tbl`.
#' @seealso The player headshot rendering function [gt_nfl_headshots()].
#' @seealso The article that describes how nflplotR works with the 'gt' package
#'    <https://nflplotr.nflverse.com/articles/gt.html>
#' @export
#' @section Output of below example:
#' \if{html}{\figure{logo_tbl.png}{options: width=75\%}}
#' @examples
#' \donttest{
#' library(gt)
#' library(nflplotR)
#' teams <- valid_team_names()
#' # remove conference logos from this example
#' teams <- teams[!teams %in% c("AFC", "NFC", "NFL")]
#' # create dataframe with all 32 team names
#' df <- data.frame(
#'   team_a = head(teams, 16),
#'   logo_a = head(teams, 16),
#'   wordmark_a = head(teams, 16),
#'   team_b = tail(teams, 16),
#'   logo_b = tail(teams, 16),
#'   wordmark_b = tail(teams, 16)
#' )
#' # create gt table and translate team names to logo/wordmark images
#' table <- df |>
#'   gt() |>
#'   gt_nfl_logos(columns = gt::starts_with("logo")) |>
#'   gt_nfl_wordmarks(columns = gt::starts_with("wordmark"))
#' }
gt_nfl_logos <- function(gt_object,
                         columns,
                         height = 30,
                         locations = NULL){
  gt_nflplotR_image(
    gt_object = gt_object,
    columns = {{ columns }},
    height = height,
    locations = locations,
    type = "logo"
  )
}

#' @rdname gt_nfl_logos
#' @export
gt_nfl_wordmarks <- function(gt_object,
                             columns,
                             height = 30,
                             locations = NULL){
  gt_nflplotR_image(
    gt_object = gt_object,
    columns = {{ columns }},
    height = height,
    locations = locations,
    type = "wordmark"
  )
}

#' Render Logos, Wordmarks, and Headshots in 'gt' Table Column Labels
#'
#' @description Translate NFL team abbreviations into logos and wordmarks or
#'  NFL player gsis IDs to player headshots and render these images in
#'  column labels of 'gt' tables.
#'
#' @inheritParams gt_nfl_logos
#' @param ... Currently not in use
#' @param type One of `"logo"`, `"wordmark"`, or `"headshot"` selecting whether
#'   to render a team's logo or wordmark image, or a player's headshot.
#'
#' @return An object of class `gt_tbl`.
#' @seealso The article that describes how nflplotR works with the 'gt' package
#'    <https://nflplotr.nflverse.com/articles/gt.html>
#' @seealso The logo and wordmark rendering functions [gt_nfl_logos()] and
#'   [gt_nfl_wordmarks()].
#' @seealso The player headshot rendering function [gt_nfl_headshots()].
#' @export
#' @section Output of below example:
#' \if{html}{\figure{cols_label.png}{options: width=75\%}}
#' @examples
#' \donttest{
#' library(gt)
#' label_df <- data.frame(
#'   "00-0036355" = 1,
#'   "00-0033873" = 2,
#'   "LAC" = 11,
#'   "KC" = 12,
#'   check.names = FALSE
#' )
#'
#' # create gt table and translate player IDs and team abbreviations
#' # into headshots, logos, and wordmarks
#' table <- gt::gt(label_df) |>
#'   nflplotR::gt_nfl_cols_label(
#'     columns = gt::starts_with("00"),
#'     type = "headshot"
#'   ) |>
#'   nflplotR::gt_nfl_cols_label("LAC", type = "wordmark") |>
#'   nflplotR::gt_nfl_cols_label("KC", type = "logo")
#' }
gt_nfl_cols_label <- function(gt_object,
                              columns = gt::everything(),
                              ...,
                              height = 30,
                              type = c("logo", "wordmark", "headshot")){

  type <- rlang::arg_match(type)

  if (is.numeric(height)) {
    height <- paste0(height, "px")
  }

  gt::cols_label_with(
    data = gt_object,
    columns = {{ columns }},
    fn = function(x){
      if (type == "headshot"){
        headshots <- load_headshots()
        lookup <- headshots$headshot_nfl
        names(lookup) <- headshots$gsis_id
        image_url <- lookup[x]
        out <- gt::web_image(image_url, height = height)
        out[is.na(image_url)] <- x[is.na(image_url)]
      } else {
        team_abbr <- nflreadr::clean_team_abbrs(as.character(x), keep_non_matches = FALSE)
        # Create the image URI
        uri <- get_image_uri(team_abbr = team_abbr, type = type)
        # Generate the Base64-encoded image and place it within <img> tags
        out <- paste0(
          "<img src=\"",
          uri,
          "\" style=\"height:",
          height,
          ";\" alt=\"The ",
          team_abbr,
          " NFL logo\">"
        )
        # If the image uri returns NA we didn't find a match. We will return the
        # actual value then to avoid removing a label
        out[is.na(uri)] <- x[is.na(uri)]
      }
      gt::html(out)
    }
  )
}

gt_nflplotR_image <- function(gt_object,
                              columns,
                              height = 30,
                              locations = NULL,
                              type = c("logo", "wordmark")){

  rlang::check_installed("gt (>= 0.8.0)", "to render images in gt tables.")

  type <- match.arg(type)

  if(is.null(locations)){
    locations <- gt::cells_body({{ columns }})
  }

  if (is.numeric(height)) {
    height <- paste0(height, "px")
  }

  gt::text_transform(
    data = gt_object,
    locations = locations,
    fn = function(x){
      team_abbr <- nflreadr::clean_team_abbrs(as.character(x), keep_non_matches = FALSE)
      # Create the image URI
      uri <- get_image_uri(team_abbr = team_abbr, type = type)
      # Generate the Base64-encoded image and place it within <img> tags
      out <- paste0(
        "<img src=\"",
        uri,
        "\" style=\"height:",
        height,
        ";\" alt=\"The ",
        team_abbr,
        " NFL logo\">"
      )
      out <- lapply(out, gt::html)
      # If the image uri returns NA we didn't find a match. We will return the
      # actual value then to allow the user to call gt::sub_missing()
      out[is.na(uri)] <- x[is.na(uri)]
      out
    }
  )

}

# Taken from gt package and modified for nflplotR purposes
# Get image URIs from image lists as a vector Base64-encoded image strings
get_image_uri <- function(team_abbr, type = c("logo", "wordmark")) {

  lookup_list <- switch (type,
    "logo" = logo_list,
    "wordmark" = wordmark_list
  )

  vapply(
    team_abbr,
    FUN.VALUE = character(1),
    USE.NAMES = FALSE,
    FUN = function(team) {
      # every non match will return NULL which is when we want NA
      if (is.null(lookup_list[[team]])) return(NA_character_)
      paste0(
        "data:", "image/png",
        ";base64,", base64enc::base64encode(lookup_list[[team]])
      )
    }
  )
}


#' Render Player Headshots in 'gt' Tables
#'
#' @description Translate NFL player gsis IDs to player headshots and
#'   render these images in html tables with the 'gt' package.
#'
#' @inheritParams gt_nfl_logos
#'
#' @return An object of class `gt_tbl`.
#' @seealso The logo and wordmark rendering functions [gt_nfl_logos()] and
#'   [gt_nfl_wordmarks()].
#' @export
#' @section Output of below example:
#' \if{html}{\figure{headshot_tbl.png}{options: width=50\%}}
#' @examples
#' \donttest{
#' library(nflplotR)
#' library(gt)
#' # Silence an nflreadr message that is irrelevant here
#' old <- options(nflreadr.cache_warning = FALSE)
#' df <- data.frame(
#'   player_gsis = c("00-0033873",
#'                   "00-0026498",
#'                   "00-0035228",
#'                   "00-0031237",
#'                   "00-0036355",
#'                   "00-0019596",
#'                   "00-0033077",
#'                   "00-0012345",
#'                   "00-0031280"),
#'   player_name = c("P.Mahomes",
#'                   "M.Stafford",
#'                   "K.Murray",
#'                   "T.Bridgewater",
#'                   "J.Herbert",
#'                   "T.Brady",
#'                   "D.Prescott",
#'                   "Non.Match",
#'                   "D.Carr")
#' )
#'
#' # Replace player IDs with headshot images
#' table <- gt(df) |>
#'   gt_nfl_headshots("player_gsis")
#'
#' # Restore old options
#' options(old)
#' }
gt_nfl_headshots <- function(gt_object,
                             columns,
                             height = 30,
                             locations = NULL){
  rlang::check_installed("gt (>= 0.8.0)", "to render images in gt tables.")

  if(is.null(locations)){
    locations <- gt::cells_body({{ columns }})
  }

  gt::text_transform(
    data = gt_object,
    locations = locations,
    fn = function(gsis){
      headshot_map <- load_headshots()
      image_urls <- vapply(
        gsis,
        FUN.VALUE = character(1),
        USE.NAMES = FALSE,
        FUN = function(id) {
          if(is.na(id) | !is_gsis(id)) return(NA_character_)
          ret <- headshot_map$headshot_nfl[headshot_map$gsis_id == id]
          if(length(ret) == 0) ret <- na_headshot()
          ret
        }
      )
      img_tags <- gt::web_image(image_urls, height = height)
      # gt::web_image inserts a placeholder for NAs
      # We want the actual input instead because users might call
      # gt::sub_missing which defaults to "---"
      img_tags[is.na(image_urls)] <- gsis[is.na(image_urls)]
      img_tags
    }
  )
}

#' Render 'gt' Table to Temporary png File
#'
#' Saves a gt table to a temporary png image file and uses magick to render
#' tables in reproducible examples like `reprex::reprex()` or in package
#' function examples (see details for further information).
#'
#' @param gt_tbl An object of class `gt_tbl` usually created by [gt::gt()]
#' @param ... Arguments passed on to [webshot2::webshot()] and [par()].
#' @details Rendering gt tables in function examples is not trivial because
#'  of the behavior of an underlying dependency: chromote. It keeps a process
#'  running even if the chromote session is closed. Unfortunately, this causes
#'  R CMD Check errors related to open connections after example runs. The only
#'  way to avoid this is setting the environment variable `_R_CHECK_CONNECTIONS_LEFT_OPEN_`
#'  to `"false"`. How to do that depends on where and how developers check their
#'  package. A good way to prevent an example from being executed because the
#'  environment variable was not set to `"false"` can be taken from the source
#'  code of this function.
#' @return Returns `NULL` invisibly.
#' @export
#' @examplesIf identical(Sys.getenv("_R_CHECK_CONNECTIONS_LEFT_OPEN_"), "false") && identical(Sys.getenv("IN_PKGDOWN"), "true")
#' tbl <- gt::gt_preview(mtcars)
#' gt_render_image(tbl)
gt_render_image <- function(gt_tbl, ...){
  if(!inherits(gt_tbl, "gt_tbl")){
    cli::cli_abort("The argument {.arg gt_tbl} is not an object of class {.cls gt_tbl}")
  }
  rlang::check_installed("gt", "to render images in gt tables.")
  temp_file <- tempfile(fileext = ".png")
  # webshot2 sends a message that can't be suppressed with suppressMessages()
  # so we capture the output and return it invisibly
  output <- gt::gtsave(gt_tbl, temp_file, quiet = TRUE, ...)
  # get rid of the file when function exits
  on.exit(unlink(temp_file))
  # remove margin from plots so we render the table only
  old <- graphics::par(ask = FALSE, mai = c(0,0,0,0), ...)
  plot(magick::image_read(temp_file))
  # restore old margins
  graphics::par(old)
  invisible(NULL)
}

#' Format Columns of 'gt' Tables as Percentage Bars
#'
#' Add context to your data by placing the actual values on a percentile bar.
#' The percentile bar is additionally colored with a colorscale based on a user
#' supplied color palette.
#'
#' @param gt_tbl A table object that is created using the [gt::gt()] function.
#' @param col_value Column name of the value to be printed.
#' @param col_pct Column name of 0 - 100 values controlling the fill width.
#' @inheritParams gt::extract_cells
#' @param hide_col_pct If `TRUE`, the column in `col_pct` will be hidden in the
#'   resulting table.
#' @param value_padding_left Left padding of the printed text.
#' @param value_padding_right Right padding of the printed text.
#' @param value_dark_color The color of the dark text option.
#'  The function will calculate color contrast ratios with
#'  [colorspace::contrast_ratio] and, based on this, decide whether the dark or
#'  light option is more readable. NOTE: this uses colors from `fill_palette`
#'  and not the color from `background_fill.color` as background because it is
#'  not trivial to figure out the actual background of the text.
#' @param value_light_color The color of the light text option.
#'  The function will calculate color contrast ratios with
#'  [colorspace::contrast_ratio] and, based on this, decide whether the dark or
#'  light option is more readable. NOTE: this uses colors from `fill_palette`
#'  and not the color from `background_fill.color` as background because it is
#'  not trivial to figure out the actual background of the text.
#' @param fill_palette The colors that values will be mapped to. This can also
#'  be one of `"hulk"`, `"hulk_teal"`, or `"blue_orange"` which will trigger
#'  internal color palettes. Argument passed on to [scales::col_numeric].
#' @param fill_palette.reverse Whether the vector of colors in `fill_palette`
#'  should be reversed. Argument passed on to [scales::col_numeric].
#' @param fill_na.color Fill color in case of `NA` values. Argument passed on to
#'  [scales::col_numeric].
#' @param fill_pct.domain The possible values that colors in `fill_palette` can
#'  be mapped to.
#' @param fill_border.color Border color of color filled area.
#' @param fill_border.radius Border radius of color filled area.
#' @param background_border.color Border color of background.
#' @param background_border.radius Border radius of background.
#' @param background_fill.color Fill color of background.
#' @param background_fill.width Width of background.
#'
#' @details
#' The function allows extensive styling of the bars and text. All styling
#' parameters are interpreted as style properties of a html span tag. For more
#' info on CSS properties, see <https://www.w3schools.com/cssref/index.php>.
#'
#' ## Some notes about styling
#'
#' Since this is meant to be an extension of an already existing 'gt' table,
#' you'll have to do some styling outside of this function, esp. the horizontal
#' alignment and direction will be controlled by `gt::cols_align` (see example).
#'
#' Make sure to play around with `fill_border.radius` and
#' `background_border.radius`. Results will depend on final column width and
#' percentiles. Very short percentile bars, i.e. small values in `col_pct`,
#' might result in bars crossing the border because when combined with a
#' big border radius.
#'
#' Text alignment depending on the colored bar isn't as easy as one might think.
#' Try percent values in `value_padding_left` or `value_padding_right` to avoid
#' overlapping of text values and the outline of the colored bars.
#'
#' For more information and examples, see the article that describes how
#' nflplotR works with the 'gt' package
#' <https://nflplotr.nflverse.com/articles/gt.html>.
#'
#' @seealso The article that describes how nflplotR works with the 'gt' package
#'    <https://nflplotr.nflverse.com/articles/gt.html>
#' @returns An object of class `gt_tbl`.
#' @export
#' @section Output of below example:
#' \if{html}{\figure{pct_tbl.png}{options: width=66\%}}
#' @examples
#' # Make a data.table of mtcars and select only disp and hp
#' data <- data.table::as.data.table(mtcars)[, list(disp, hp)]
#'
#' # Add the percentile of hp in the distribution of hp values
#' data[, pct := round(stats::ecdf(hp)(hp) * 100, 1)]
#'
#' # set seed to keep it reproducible
#' set.seed(20)
#'
#' # take random sample (to avoid a big table) and add the percent bars for hp
#' # using the percentiles in the pct variable
#' table <- data[sample(.N, 10)] |>
#'   gt::gt() |>
#'   nflplotR::gt_pct_bar(
#'     "hp",
#'     "pct",
#'     hide_col_pct = FALSE,
#'     value_padding_left = "10px",
#'   ) |>
#'   gt::cols_align("left", hp) |>
#'   gt::cols_width(hp ~ gt::px(250))
gt_pct_bar <- function(
  gt_tbl,
  col_value,
  col_pct,
  rows = gt::everything(),
  hide_col_pct = FALSE,
  # control style of value
  value_padding_left = "0px",
  value_padding_right = "0px",
  value_dark_color = "black",
  value_light_color = "white",
  # control style of fill bar
  fill_palette = "hulk",
  fill_palette.reverse = FALSE,
  fill_na.color = "#808080",
  fill_pct.domain = 0:100,
  fill_border.color = "transparent",
  fill_border.radius = "10px",
  # control style of background
  background_border.color = "thin solid black",
  background_border.radius = "12px",
  background_fill.color = "#b1b1b1",
  background_fill.width = "100%"
) {
  rlang::check_installed("colorspace (>= 2.0)", "to calculate color contrast ratios.")
  # Extract percent values from table data
  # rows allows us to apply a filter
  pct <- as.numeric(gt::extract_cells(
    data = gt_tbl,
    columns = {{ col_pct }},
    rows = {{ rows }}
  ))

  # Catch percent values outside c(0, 100)
  if (!all(data.table::inrange(pct, 0, 100))) {
    outside <- pct[!data.table::inrange(pct, 0, 100)]
    cli::cli_abort(
      "The following {cli::qty(length(outside))} value{?s} of column \\
      {.val {col_pct}} {cli::qty(length(outside))} {?is/are} outside of the \\
      valid range 0 - 100: {.val {outside}}"
    )
  }

  # If all percent values are in range c(0, 1),
  # the user likely forgot to multiply by 100
  if (all(data.table::inrange(pct, 0, 1))) {
    cli::cli_warn(
      "All values in column {.val {col_pct}} are in range 0 - 1. \\
      Did you forget to multiply by 100?"
    )
  }

  # Use one of 3 internal color palettes for special literals
  if (
    length(fill_palette) == 1 &&
    fill_palette %in% c("hulk", "hulk_teal", "blue_orange")
  ) {
    fill_palette <- color_palettes[[fill_palette]]
  }

  # Calculate the actual color palette based on the supplied colors and domain
  fill_color <- scales::col_numeric(
    palette = fill_palette,
    domain = fill_pct.domain,
    na.color = fill_na.color,
    reverse = fill_palette.reverse
  )(pct)

  out <- gt::text_transform(
    data = gt_tbl,
    locations = gt::cells_body(columns = {{ col_value }}, rows = {{ rows }}),
    fn = function(x) {
      paste0(
        # Draw the background box.
        # Defaults to full width, black outline and grayish fill
        # vectorized over all args (length 1 is recycled)
        .pct_bar_background(
          border = background_border.color,
          border_radius = background_border.radius,
          background_color = background_fill.color,
          width = background_fill.width
        ),
        # Draw a colored box with dynamic width and fill color
        # vectorized over all args (length 1 is recycled)
        .pct_bar_foreground(
          width = pct,
          border = fill_border.color,
          border_radius = fill_border.radius,
          background_color = fill_color
        ),
        # Add text
        # vectorized over all args (length 1 is recycled)
        .pct_bar_text(
          text = x,
          padding_left = value_padding_left,
          padding_right = value_padding_right,
          text_color = .better_contrast(
            background_colors = fill_color,
            light_text = value_light_color,
            dark_text = value_dark_color
          )
        )
      )
    }
  )

  # Hide percentage column if user wants to
  if (isTRUE(hide_col_pct)) {
    out <- gt::cols_hide(out, col_pct)
  }

  out
}

.pct_bar_background <- function(
  border = "thin solid black",
  border_radius = "12px",
  background_color = "#b1b1b1",
  width = "100%"
) {
  paste0(
    "<span style=\"",
    "display:inline-block;",
    "border:", border, ";",
    "border-radius:", border_radius, ";",
    "background-color:", background_color, ";",
    "width:", width,
    "\"/span>"
  )
}

.pct_bar_foreground <- function(
    width,
    border = "transparent",
    border_radius = "10px",
    background_color = "#b1b1b1"
) {
  paste0(
    "<span style=\"",
    "display:inline-block;",
    "border:", border, ";",
    "border-radius:", border_radius, ";",
    "background-color:", background_color, ";",
    "width:", width, "%",
    "\"/span>"
  )
}

.pct_bar_text <- function(
    text,
    padding_left = "0%",
    padding_right = "0%",
    text_color = "white"
) {
  paste0(
    "<span style=\"",
    # "display:inline-block;",
    # "unicode-bidi:bidi-override;",
    "color:", text_color, ";",
    "padding-left:", padding_left, ";",
    "padding-right:", padding_right, ";",
    "width:100%",
    "\">",
    text,
    "</span>"
  )
}

# Calculate color contrast ratios and return the color that yields the better
# contrast
.better_contrast <- function(background_colors, light_text, dark_text){
  cr_light <- abs(colorspace::contrast_ratio(background_colors, light_text))
  cr_dark <- abs(colorspace::contrast_ratio(background_colors, dark_text))

  data.table::fifelse(
    cr_light > cr_dark, light_text, dark_text
  )
}

# The following functions are not used because I couldn't figure out an easy way
# to make the property collapsing vectorized

.concat_properties <- function(...){
  props <- list(...)
  paste(names(props), props, sep = ":", collapse = ";")
}

.span_tag <- function(..., value = NULL){
  out <- paste0(
    "<span style=\"",
    concat_properties(...)
  )
  out <- if (is.null(value)){
    paste0(out, "\"/span>")
  } else {
    paste0(
      out,
      "\">",
      value,
      "</span>"
    )
  }
  out
}
