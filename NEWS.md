# nflplotR (development version)

* Added the `geom_nfl_logos()` geom.
* Added the `geom_mean_lines()` and `geom_median_lines()` geoms. (v0.0.0.9002)
* `geom_nfl_logos()` now tries to clean the team abbreviations by calling `nflreadr::clean_team_abbrs()`
* Added the color and fill scales `scale_color_nfl()` and `scale_fill_nfl()`. (v0.0.0.9003)
* Added the axis scales `scale_x_nfl()` and `scale_y_nfl()` in combination with the theme update functions `theme_x_nfl()` and `theme_y_nfl()`. (v0.0.0.9004)
* Fixed an incompatible position argument in `scale_y_nfl()`. (v.0.0.9005)
* Added the function `ggpreview()` which allows to preview a ggplot in it's actual dimensions. (v.0.0.9006)
* `geom_nfl_logos()` now supports a `colour` aesthetic that colorizes the logos. (v0.0.9007)
* Added the function `nfl_team_tiers()` that build an NFL team tiers ggplot, thanks to [Timo Riske](https://twitter.com/PFF_Moo) for the suggestion. (v.0.0.9008)
