# Render 'gt' Table to Temporary png File

Saves a gt table to a temporary png image file and uses magick to render
tables in reproducible examples like `reprex::reprex()` or in package
function examples (see details for further information).

## Usage

``` r
gt_render_image(gt_tbl, ...)
```

## Arguments

- gt_tbl:

  An object of class `gt_tbl` usually created by
  [`gt::gt()`](https://gt.rstudio.com/reference/gt.html)

- ...:

  Arguments passed on to
  [`webshot2::webshot()`](https://rstudio.github.io/webshot2/reference/webshot.html)
  and [`par()`](https://rdrr.io/r/graphics/par.html).

## Value

Returns `NULL` invisibly.

## Details

Rendering gt tables in function examples is not trivial because of the
behavior of an underlying dependency: chromote. It keeps a process
running even if the chromote session is closed. Unfortunately, this
causes R CMD Check errors related to open connections after example
runs. The only way to avoid this is setting the environment variable
`_R_CHECK_CONNECTIONS_LEFT_OPEN_` to `"false"`. How to do that depends
on where and how developers check their package. A good way to prevent
an example from being executed because the environment variable was not
set to `"false"` can be taken from the source code of this function.

## Examples

``` r
tbl <- gt::gt_preview(mtcars)
gt_render_image(tbl)
```
