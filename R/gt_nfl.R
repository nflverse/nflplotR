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
#' table <- df %>%
#'   gt() %>%
#'   gt_nfl_logos(columns = gt::starts_with("logo")) %>%
#'   gt_nfl_wordmarks(columns = gt::starts_with("wordmark"))
#' }
gt_nfl_logos <- function(gt_object,
                         columns,
                         height = 30,
                         locations = NULL){
  gt_nflplotR_image(
    gt_object = gt_object,
    columns = columns,
    height = height,
    locations = locations,
    type = "logos"
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
    columns = columns,
    height = height,
    locations = locations,
    type = "wordmarks"
  )
}

gt_nflplotR_image <- function(gt_object,
                              columns,
                              height = 30,
                              locations = NULL,
                              type = c("logos", "wordmarks")){

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
      paste0("<img src=\"", uri, "\" style=\"height:", height, ";\">")
    }
  )

}

# Taken from gt package and modified for nflplotR purposes
# Get image URIs from image lists as a vector Base64-encoded image strings
get_image_uri <- function(team_abbr, type = c("logos", "wordmarks")) {

  lookup_list <- switch (type,
    "logos" = logo_list,
    "wordmarks" = wordmark_list
  )

  vapply(
    team_abbr,
    FUN.VALUE = character(1),
    USE.NAMES = FALSE,
    FUN = function(team) {
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
#' table <- gt(df) %>%
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
          ret <- headshot_map$headshot_nfl[headshot_map$gsis_id == id]
          if(length(ret) == 0) ret <- na_headshot()
          ret
        }
      )
      gt::web_image(image_urls, height = height)
    }
  )
}

#' Render 'gt' Table to Temporary png File
#'
#' Saves a gt table to a temporary png image file and uses magick to render
#' tables in reproducible examples like `reprex::reprex()` or in package
#' function examples.
#'
#' @param gt_tbl An object of class `gt_tbl` usually created bt [gt::gt()]
#' @param ... Arguments passed on to [webshot2::webshot()] and [par()].
#'
#' @return Returns `NULL` invisibly.
#' @export
#' @examples
#' \donttest{
#' # Don't run this on CRAN because an underlying dependency (chromote)
#' # keeps open connections which causes R CMD check errors.
#' # This code will run in CI workflows. To avoid problems in those workflows,
#' # you can set the environment variable "_R_CHECK_CONNECTIONS_LEFT_OPEN_" to
#' # "false"
#' if (Sys.getenv("NOT_CRAN") == "true") {
#' tbl <- gt::gt_preview(mtcars)
#' gt_render_image(tbl)
#' }
#' }
# \dontshow{
# # Hack to suppress R CMD check error about connections
# Sys.setenv("_R_CHECK_CONNECTIONS_LEFT_OPEN_" = "FALSE")
# }
gt_render_image <- function(gt_tbl, ...){
  # gt_tbl <- gt::gt_preview(mtcars)
  if(!inherits(gt_tbl, "gt_tbl")){
    cli::cli_abort("The argument {.arg gt_tbl} is not an object of class {.cls gt_tbl}")
  }
  rlang::check_installed("gt", "to render images in gt tables.")
  temp_file <- tempfile(fileext = ".png")
  # webshot2 sends a message that can't be suppressed with suppressMessages()
  # so we capture the output and return it invisibly
  gt::gtsave(gt_tbl, temp_file, ...) %>%
    utils::capture.output(type = "message") %>%
    invisible()
  on.exit(unlink(temp_file))
  old <- graphics::par(ask = FALSE, mai = c(0,0,0,0), ...)
  plot(magick::image_read(temp_file))
  graphics::par(old)
  invisible(NULL)
}
