# nflplotR (development version)

* Added the `geom_nfl_logos()` geom.
* Added the `geom_mean_lines()` and `geom_median_lines()` geoms. (v0.0.0.9002)
* `geom_nfl_logos()` now tries to clean the team abbreviations by calling `nflreadr::clean_team_abbrs()`
* Added the color and fill scales `scale_color_nfl()` and `scale_fill_nfl()`. (v0.0.0.9003)
* Added the axis scales `scale_x_nfl()` and `scale_y_nfl()` in combination with the theme update functions `theme_x_nfl()` and `theme_y_nfl()`. (v0.0.0.9004)
