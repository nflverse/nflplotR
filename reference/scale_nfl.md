# Scales for NFL Team Colors

These functions map NFL team names to their team colors in color and
fill aesthetics

## Usage

``` r
scale_color_nfl(
  type = c("primary", "secondary"),
  values = NULL,
  ...,
  aesthetics = "colour",
  breaks = ggplot2::waiver(),
  na.value = "grey50",
  guide = NULL,
  alpha = NA
)

scale_colour_nfl(
  type = c("primary", "secondary"),
  values = NULL,
  ...,
  aesthetics = "colour",
  breaks = ggplot2::waiver(),
  na.value = "grey50",
  guide = NULL,
  alpha = NA
)

scale_fill_nfl(
  type = c("primary", "secondary"),
  values = NULL,
  ...,
  aesthetics = "fill",
  breaks = ggplot2::waiver(),
  na.value = "grey50",
  guide = NULL,
  alpha = NA
)
```

## Arguments

- type:

  One of `"primary"` or `"secondary"` to decide which colortype to use.

- values:

  If `NULL` (the default) use the internal team color vectors. Otherwise
  a set of aesthetic values to map data values to. The values will be
  matched in order (usually alphabetical) with the limits of the scale,
  or with `breaks` if provided. If this is a named vector, then the
  values will be matched based on the names instead. Data values that
  don't match will be given `na.value`.

- ...:

  Arguments passed on to
  [`discrete_scale`](https://ggplot2.tidyverse.org/reference/discrete_scale.html)

  `limits`

  :   One of:

      - `NULL` to use the default scale values

      - A character vector that defines possible values of the scale and
        their order

      - A function that accepts the existing (automatic) values and
        returns new ones. Also accepts rlang
        [lambda](https://rlang.r-lib.org/reference/as_function.html)
        function notation.

  `drop`

  :   Should unused factor levels be omitted from the scale? The
      default, `TRUE`, uses the levels that appear in the data; `FALSE`
      includes the levels in the factor. Please note that to display
      every level in a legend, the layer should use
      `show.legend = TRUE`.

  `na.translate`

  :   Unlike continuous scales, discrete scales can easily show missing
      values, and do so by default. If you want to remove missing values
      from a discrete scale, specify `na.translate = FALSE`.

  `name`

  :   The name of the scale. Used as the axis or legend title. If
      [`waiver()`](https://ggplot2.tidyverse.org/reference/waiver.html),
      the default, the name of the scale is taken from the first mapping
      used for that aesthetic. If `NULL`, the legend title will be
      omitted.

  `minor_breaks`

  :   One of:

      - `NULL` for no minor breaks

      - [`waiver()`](https://ggplot2.tidyverse.org/reference/waiver.html)
        for the default breaks (none for discrete, one minor break
        between each major break for continuous)

      - A numeric vector of positions

      - A function that given the limits returns a vector of minor
        breaks. Also accepts rlang
        [lambda](https://rlang.r-lib.org/reference/as_function.html)
        function notation. When the function has two arguments, it will
        be given the limits and major break positions.

  `labels`

  :   One of the options below. Please note that when `labels` is a
      vector, it is highly recommended to also set the `breaks` argument
      as a vector to protect against unintended mismatches.

      - `NULL` for no labels

      - [`waiver()`](https://ggplot2.tidyverse.org/reference/waiver.html)
        for the default labels computed by the transformation object

      - A character vector giving labels (must be same length as
        `breaks`)

      - An expression vector (must be the same length as breaks). See
        ?plotmath for details.

      - A function that takes the breaks as input and returns labels as
        output. Also accepts rlang
        [lambda](https://rlang.r-lib.org/reference/as_function.html)
        function notation.

  `guide`

  :   A function used to create a guide or its name. See
      [`guides()`](https://ggplot2.tidyverse.org/reference/guides.html)
      for more information.

  `call`

  :   The `call` used to construct the scale for reporting messages.

  `super`

  :   The super class to use for the constructed scale

- aesthetics:

  Character string or vector of character strings listing the name(s) of
  the aesthetic(s) that this scale works with. This can be useful, for
  example, to apply colour settings to the `colour` and `fill`
  aesthetics at the same time, via `aesthetics = c("colour", "fill")`.

- breaks:

  One of:

  - `NULL` for no breaks

  - [`waiver()`](https://ggplot2.tidyverse.org/reference/waiver.html)
    for the default breaks (the scale limits)

  - A character vector of breaks

  - A function that takes the limits as input and returns breaks as
    output

- na.value:

  The aesthetic value to use for missing (`NA`) values

- guide:

  A function used to create a guide or its name. If `NULL` (the default)
  no guide will be plotted for this scale. See
  [`ggplot2::guides`](https://ggplot2.tidyverse.org/reference/guides.html)
  for more information.

- alpha:

  Factor to modify color transparency via a call to
  [`scales::alpha`](https://scales.r-lib.org/reference/alpha.html). If
  `NA` (the default) no transparency will be applied. Can also be a
  vector of alphas. All alpha levels must be in range `[0,1]`.

## Examples

``` r
# \donttest{
library(nflplotR)
library(ggplot2)

team_abbr <- valid_team_names()
# remove conference logos from this example
team_abbr <- team_abbr[!team_abbr %in% c("AFC", "NFC", "NFL")]

df <- data.frame(
  random_value = runif(length(team_abbr), 0, 1),
  teams = team_abbr
)
ggplot(df, aes(x = teams, y = random_value)) +
  geom_col(aes(color = teams, fill = teams), width = 0.5) +
  scale_color_nfl(type = "secondary") +
  scale_fill_nfl(alpha = 0.4) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# }
```
