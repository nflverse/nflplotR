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
