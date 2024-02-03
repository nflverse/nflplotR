# nflplotR (development version)

* The functions `geom_nfl_headshots()` and `gt_nfl_headshots()` better handle `NA` gsis IDs. (#48)
* The functions `gt_nfl_logos()` and `gt_nfl_wordmarks()` now keep non team name matches to allow the user to call `gt::sub_missing()`. (#48)
* The functions `gt_nfl_logos()` and `gt_nfl_wordmarks()` now correctly render images in gt row group labels. (#49)
* Deprecated the functions `scale_x_nfl`, `scale_y_nfl`, `scale_x_nfl_headshots`, `scale_y_nfl_headshots`, `theme_x_nfl`, `theme_y_nfl`. These function are slow and require a possibly unstable dependency. Please use the far superior `element_nfl_logo()` and friends instead. (#50)
* The function `geom_nfl_logos()` now plots the NFL logo, if `team_abbr == "NFL"`. (#51)
* Added the new function `gt_nfl_cols_label()` that renders logos and wordmarks in column labels of {gt} tables. (#52)
* The function `gt_nfl_cols_label()` now allows rendering of player headshots in column labels. Thanks Steven Patton @spatto12 for the PR. (#55)
* Adjust lists in documentation as the next R version checks for correctly formatted lists. (#56)

# nflplotR 1.2.0

## New Features

* Add new functions `gt_nfl_logos()` and `gt_nfl_wordmarks()` to render logos and wordmarks in `gt()` html tables. (#39)
* Add new function `gt_nfl_headshots()` to render player headshots in `gt()` html tables. (#41)
* Add new function `gt_render_image()` to render gt tables to an image in package function examples or reproducible examples. (#42)
* Add new function `nflverse_sitrep()` to compute a nflverse related situation report.

## Breaking Changes

* The functions `geom_from_path()`, `element_path()` as well as the ref line functions `geom_mean_line()` and `geom_median_line()` have been outsourced to the ggpath package. nflplotR re-exports them for compatibility reasons. However, the ref line functions needed modification in order to work properly with ggplot2 scale transformations. Those geoms now require the aesthetics `x0` and `y0` instead of `v_var` and `h_var` respectively. This means that nflplotR will break code (!) where ref line geoms are called with `v_var` and `h_var` aesthetics. This is a hard but necessary step to revise an irreparable mistake in the development of the original code. (#43)

## Minor Changes

* Update Eagles and Commanders wordmarks with latest versions from NFL. (#44)
* Update Bears logo (it's now the Bear) and secondary color to meet their brand guidelines. (#46)

Thank you to [&#x0040;Adeiko](https://github.com/Adeiko), and [&#x0040;tanho63](https://github.com/tanho63) for their questions, feedback, and contributions towards this release.



# nflplotR 1.1.0

* nflplotR will internally cache images used in all geoms and elements. The cache behavior can be controlled by setting `options("nflplotR.cache")` to one of `"memory"`, `"filesystem"`, or `"off"`. It is possible to clear the cache with the new function `.nflplotR_clear_cache()`. This functionality added the dependencies cachem, memoise and rappdirs.
* Resolved an issue where `geom_mean_lines()` and `geom_median_lines()` didn't draw lines when a scale transformation, e.g. `scale_*_reverse()`, was applied.
* Added new function `nfl_team_factor()` which creates ordered factors of NFL team names for facetted plots.

# nflplotR 1.0.1

* Updated the internal logo and wordmark files with the new Washington Commanders design. 
* Fixed some issues with `theme-elements` and updated examples.

# nflplotR 1.0.0

* Added the `geom_nfl_logos()` geom.
* Added the `geom_mean_lines()` and `geom_median_lines()` geoms. (v0.0.0.9002)
* `geom_nfl_logos()` now tries to clean the team abbreviations by calling `nflreadr::clean_team_abbrs()`
* Added the color and fill scales `scale_color_nfl()` and `scale_fill_nfl()`. (v0.0.0.9003)
* Added the axis scales `scale_x_nfl()` and `scale_y_nfl()` in combination with the theme update functions `theme_x_nfl()` and `theme_y_nfl()`. (v0.0.0.9004)
* Fixed an incompatible position argument in `scale_y_nfl()`. (v.0.0.9005)
* Added the function `ggpreview()` which allows to preview a ggplot in it's actual dimensions. (v.0.0.9006)
* `geom_nfl_logos()` now supports a `colour` aesthetic that colorizes the logos. (v0.0.9007)
* Added the function `nfl_team_tiers()` that build an NFL team tiers ggplot, thanks to Timo Riske for the suggestion. (v.0.0.9008)
* Fixed a bug (#10) in `geom_median_lines()` and `geom_mean_lines()` that caused `alpha` to not work properly. (v.0.0.9009)
* Improved `nfl_team_tiers()` by adding the opportunity to modify `title`, `subtitle`, `caption` of the plot. Added functionality to remove tier separation lines for combined tiers. Added functionality to run the function in "developer" mode which means, that team abbreviations will be plotted instead of logos (much faster). (v.0.0.9010)
* Added the `geom_nfl_headshots()` geom that plots headshots for valid gsis IDs. (v0.0.9011)
* Added the axis scales `scale_x_nfl_headshots()` and `scale_y_nfl_headshots()`. (v.0.0.9012)
* Updated internal data to use the new team colors in nflfastR. (v.0.0.9013)
* Added the `geom_nfl_wordmarks()` geom that plots NFL wordmarks using valid team abbreviations. (v.0.0.9014)
* Added the `geom_from_path()` geom that plots images from urls, local paths and more. (v.0.0.9015)
* Added the ggplot2 theme-elements `element_nfl_logo()`, `element_nfl_wordmark()`,
`element_nfl_headshot()`, and `element_path()` which translate NFL team abbreviations or player IDs into team logos and player headshots. These elements feature a major speed improvement over the axis scales `scale_x_nfl_headshots()` and `scale_y_nfl_headshots()` and make the package less dependent on an underlying package. (v.0.0.0.9016)
