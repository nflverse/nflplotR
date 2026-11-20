# Preview ggplot in Specified Dimensions

This function previews a ggplot in its actual dimensions in order to see
how it will look when saved. It is also significantly faster than the
default preview in RStudio for ggplots created using nflplotR.

## Usage

``` r
ggpreview(
  plot = ggplot2::last_plot(),
  width = NA,
  height = NA,
  asp = NULL,
  dpi = 300,
  device = "png",
  units = c("in", "cm", "mm", "px"),
  scale = 1,
  limitsize = TRUE,
  bg = NULL,
  ...
)
```

## Arguments

- plot:

  Plot to save, defaults to last plot displayed.

- width, height:

  Plot size in units expressed by the `units` argument. If not supplied,
  uses the size of the current graphics device.

- asp:

  The aspect ratio of the plot calculated as `width / height`. If this
  is a numeric value (and not `NULL`) the `height` of the plot will be
  recalculated to `height = width / asp`.

- dpi:

  Plot resolution. Also accepts a string input: "retina" (320), "print"
  (300), or "screen" (72). Only applies when converting pixel units, as
  is typical for raster output types.

- device:

  Device to use. Can either be a device function (e.g.
  [png](https://rdrr.io/r/grDevices/png.html)), or one of "eps", "ps",
  "tex" (pictex), "pdf", "jpeg", "tiff", "png", "bmp", "svg" or "wmf"
  (windows only). If `NULL` (default), the device is guessed based on
  the `filename` extension.

- units:

  One of the following units in which the `width` and `height` arguments
  are expressed: `"in"`, `"cm"`, `"mm"` or `"px"`.

- scale:

  Multiplicative scaling factor.

- limitsize:

  When `TRUE` (the default),
  [`ggsave()`](https://ggplot2.tidyverse.org/reference/ggsave.html) will
  not save images larger than 50x50 inches, to prevent the common error
  of specifying dimensions in pixels.

- bg:

  Background colour. If `NULL`, uses the `plot.background` fill value
  from the plot theme.

- ...:

  Other arguments passed on to the graphics device function, as
  specified by `device`.

## Value

No return value, called for side effects.

## Examples

``` r
library(nflplotR)
library(ggplot2)

team_abbr <- valid_team_names()
# remove conference logos from this example
team_abbr <- team_abbr[!team_abbr %in% c("AFC", "NFC", "NFL")]

df <- data.frame(
  random_value = runif(length(team_abbr), 0, 1),
  teams = team_abbr
)

# use logos for x-axis
# note that the plot is assigned to the object "p"
p <- ggplot(df, aes(x = teams, y = random_value)) +
  geom_col(aes(color = teams, fill = teams), width = 0.5) +
  scale_color_nfl(type = "secondary") +
  scale_fill_nfl(alpha = 0.4) +
  theme_minimal() +
  theme(axis.text.x = element_nfl_logo())

# preview p with defined width and aspect ratio (only available in RStudio)
if (rstudioapi::isAvailable()){
  ggpreview(p, width = 5, asp = 16/9)
}
```
