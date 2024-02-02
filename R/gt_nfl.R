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
#' @param type One of `"logo"` or `"wordmark"` selecting whether to render
#'    a team's logo or wordmark image.
#'
#' @return An object of class `gt_tbl`.
#' @seealso The player headshot rendering function [gt_nfl_headshots()].
#' @seealso The article that describes how nflplotR works with the {gt} package
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
    columns = columns,
    height = height,
    locations = locations,
    type = "wordmark"
  )
}


#' @rdname gt_nfl_logos
#' @export
gt_nfl_cols_label <- function(gt_object,
                              columns = gt::everything(),
                              height = 30,
                              type = c("logo", "wordmark")){

  type <- rlang::arg_match(type)

  if (is.numeric(height)) {
    height <- paste0(height, "px")
  }

  gt::cols_label_with(
    data = gt_object,
    columns = {{ columns }},
    fn = function(x){
      team_abbr <- nflreadr::clean_team_abbrs(as.character(x), keep_non_matches = FALSE)
      # Create the image URI
      uri <- get_image_uri(team_abbr = team_abbr, type = type)
      # Generate the Base64-encoded image and place it within <img> tags
      out <- paste0("<img src=\"", uri, "\" style=\"height:", height, ";\">")
      # If the image uri returns NA we didn't find a match. We will return the
      # actual value then to avoid removing a label
      out[is.na(uri)] <- x[is.na(uri)]
      gt::html(out)
    }
  )
}

gt_headshot_cols_label <- function(gt_object,
                              columns = gt::everything(),
                              height = 45){
  
  if (is.numeric(height)) {
    height <- paste0(height, "px")
  }
  
  gt::cols_label_with(
    data = gt_object,
    columns = {{ columns }},
    
    fn = function(gsis){
      headshot_map <- nflplotR:::load_headshots()
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
      gt::html(img_tags)
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
      out <- paste0("<img src=\"", uri, "\" style=\"height:", height, ";\">")
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
#'  to `"true"`. How to do that depends on where and how developers check their
#'  package. A good way to prevent an example from being executed because the
#'  environment variable was not set can be taken from the source code of this
#'  function.
#' @return Returns `NULL` invisibly.
#' @export
#' @examplesIf identical(Sys.getenv("_R_CHECK_CONNECTIONS_LEFT_OPEN_"), "false")
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
  output <- gt::gtsave(gt_tbl, temp_file, ...) %>%
    utils::capture.output(type = "message") %>%
    invisible()
  # if the output is something other than the annoying webshot message, print it
  if(!grepl("screenshot completed", output)) print(output)
  # get rid of the file when function exits
  on.exit(unlink(temp_file))
  # remove margin from plots so we render the table only
  old <- graphics::par(ask = FALSE, mai = c(0,0,0,0), ...)
  plot(magick::image_read(temp_file))
  # restore old margins
  graphics::par(old)
  invisible(NULL)
}
