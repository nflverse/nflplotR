# Render Player Headshots in 'gt' Tables

Translate NFL player gsis IDs to player headshots and render these
images in html tables with the 'gt' package.

## Usage

``` r
gt_nfl_headshots(gt_object, columns, height = 30, locations = NULL)
```

## Arguments

- gt_object:

  A table object that is created using the
  [`gt::gt()`](https://gt.rstudio.com/reference/gt.html) function.

- columns:

  The columns for which the image translation should be applied.
  Argument has no effect if `locations` is not `NULL`.

- height:

  The absolute height (px) of the image in the table cell.

- locations:

  If `NULL` (the default), the function will render logos/wordmarks in
  argument `columns`. Otherwise, the cell or set of cells to be
  associated with the team name transformation. Only the
  [`gt::cells_body()`](https://gt.rstudio.com/reference/cells_body.html),
  [`gt::cells_stub()`](https://gt.rstudio.com/reference/cells_stub.html),
  [`gt::cells_column_labels()`](https://gt.rstudio.com/reference/cells_column_labels.html),
  and
  [`gt::cells_row_groups()`](https://gt.rstudio.com/reference/cells_row_groups.html)
  helper functions can be used here. We can enclose several of these
  calls within a [`list()`](https://rdrr.io/r/base/list.html) if we wish
  to make the transformation happen at different locations.

## Value

An object of class `gt_tbl`.

## Output of below example

![](figures/headshot_tbl.png)

## See also

The logo and wordmark rendering functions
[`gt_nfl_logos()`](https://nflplotr.nflverse.com/reference/gt_nfl_logos.md)
and
[`gt_nfl_wordmarks()`](https://nflplotr.nflverse.com/reference/gt_nfl_logos.md).

## Examples

``` r
# \donttest{
library(nflplotR)
library(gt)
# Silence an nflreadr message that is irrelevant here
old <- options(nflreadr.cache_warning = FALSE)
df <- data.frame(
  player_gsis = c("00-0033873",
                  "00-0026498",
                  "00-0035228",
                  "00-0031237",
                  "00-0036355",
                  "00-0019596",
                  "00-0033077",
                  "00-0012345",
                  "00-0031280"),
  player_name = c("P.Mahomes",
                  "M.Stafford",
                  "K.Murray",
                  "T.Bridgewater",
                  "J.Herbert",
                  "T.Brady",
                  "D.Prescott",
                  "Non.Match",
                  "D.Carr")
)

# Replace player IDs with headshot images
table <- gt(df) |>
  gt_nfl_headshots("player_gsis")

# Restore old options
options(old)
# }
```
