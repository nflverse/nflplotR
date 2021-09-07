#' Output Valid NFL Team Abbreviations
#'
#' @param exclude_duplicates If `TRUE` (the default) the list of valid team
#' abbreviations will exclude duplicates related to franchises that have been
#' moved
#' @export
#' @examples
#' # List valid team abbreviations excluding duplicates
#' valid_team_names()
#'
#' # List valid team abbreviations excluding duplicates
#' valid_team_names(exclude_duplicates = FALSE)
valid_team_names <- function(exclude_duplicates = TRUE){
 n <- sort(names(logo_list))
 if(isTRUE(exclude_duplicates)) n <- n[!n %in% c("LAR", "OAK", "SD", "STL")]
 n
}
