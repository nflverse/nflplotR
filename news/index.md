# Changelog

## nflplotR (development version)

- Added new experimental function
  [`gt_pct_bar()`](https://nflplotr.nflverse.com/reference/gt_pct_bar.md).
  A helper that adds filled percentage bars to ‘gt’ table to add context
  to values. ([\#76](https://github.com/nflverse/nflplotR/issues/76),
  [\#77](https://github.com/nflverse/nflplotR/issues/77))

## nflplotR 1.5.0

CRAN release: 2025-09-18

- Rewrite theme elements in S7 to fully work with ggplot2 v4. This means
  nflplotR now requires ggplot2 v4! nflplotR is a ggplot2 extension and
  if ggplot2 version jumps make breaking changes, then it’s best for the
  extension to not try to be downwards compatible. The theme system is
  now fully powered by ggpath.
  ([\#73](https://github.com/nflverse/nflplotR/issues/73))
- Updated the New York Jets logo (again) to their new secondary logo
  introduced in the 2024 off-season. This aligns with the logo used
  across nfl dot com and it has been voted for in a poll.
  ([\#68](https://github.com/nflverse/nflplotR/issues/68))
- The theme elements
  [`element_nfl_logo()`](https://nflplotr.nflverse.com/reference/element.md)
  and
  [`element_nfl_wordmark()`](https://nflplotr.nflverse.com/reference/element.md)
  now clean team abbreviations by calling
  [`nflreadr::clean_team_abbrs()`](https://nflreadr.nflverse.com/reference/clean_team_abbrs.html)
  and insert empty grobs for mismatches.
- All geoms and theme elements will print more informative warnings
  about team abbreviation, or player ID mismatches.
- The gt logo rendering functions now add alt text for accessibility and
  to silence an annoying pkgdown warning.
  ([\#69](https://github.com/nflverse/nflplotR/issues/69))
- nflplotR now requires R 4.1 because magick needs this R version. This
  also follows the [Tidyverse R version support
  rules](https://www.tidyverse.org/blog/2019/04/r-version-support/).
  ([\#71](https://github.com/nflverse/nflplotR/issues/71))

## nflplotR 1.4.0

CRAN release: 2024-08-21

- Updated the New York Jets logo to their new design introduced in the
  2024 off-season.
  ([\#62](https://github.com/nflverse/nflplotR/issues/62))
- Drop dependency to package rappdirs and create an optional user cache
  with base R’s implementation. To support older R versions, nflplotR
  now imports the backports package.
  ([\#64](https://github.com/nflverse/nflplotR/issues/64))
- nflplotR v1.3.0 deprecated the functions `scale_x_nfl`, `scale_y_nfl`,
  `scale_x_nfl_headshots`, `scale_y_nfl_headshots`, `theme_x_nfl`,
  `theme_y_nfl`. They are completely removed from the source now.
  ([\#64](https://github.com/nflverse/nflplotR/issues/64))

## nflplotR 1.3.1

CRAN release: 2024-03-25

- Adjusted internals by CRAN request. No visible changes for the user.
  ([\#60](https://github.com/nflverse/nflplotR/issues/60))

## nflplotR 1.3.0

CRAN release: 2024-02-23

### New Features

- Added the new function
  [`gt_nfl_cols_label()`](https://nflplotr.nflverse.com/reference/gt_nfl_cols_label.md)
  that renders logos and wordmarks in column labels of {gt} tables.
  ([\#52](https://github.com/nflverse/nflplotR/issues/52))

### Bug Fixes & Minor Improvements

- The functions
  [`geom_nfl_headshots()`](https://nflplotr.nflverse.com/reference/geom_nfl_headshots.md)
  and
  [`gt_nfl_headshots()`](https://nflplotr.nflverse.com/reference/gt_nfl_headshots.md)
  better handle `NA` gsis IDs.
  ([\#48](https://github.com/nflverse/nflplotR/issues/48))
- The functions
  [`gt_nfl_logos()`](https://nflplotr.nflverse.com/reference/gt_nfl_logos.md)
  and
  [`gt_nfl_wordmarks()`](https://nflplotr.nflverse.com/reference/gt_nfl_logos.md)
  now keep non team name matches to allow the user to call
  [`gt::sub_missing()`](https://gt.rstudio.com/reference/sub_missing.html).
  ([\#48](https://github.com/nflverse/nflplotR/issues/48))
- The functions
  [`gt_nfl_logos()`](https://nflplotr.nflverse.com/reference/gt_nfl_logos.md)
  and
  [`gt_nfl_wordmarks()`](https://nflplotr.nflverse.com/reference/gt_nfl_logos.md)
  now correctly render images in gt row group labels.
  ([\#49](https://github.com/nflverse/nflplotR/issues/49))
- The function
  [`geom_nfl_logos()`](https://nflplotr.nflverse.com/reference/geom_nfl_logos.md)
  now plots the NFL logo, if `team_abbr == "NFL"`.
  ([\#51](https://github.com/nflverse/nflplotR/issues/51))
- The function
  [`gt_nfl_cols_label()`](https://nflplotr.nflverse.com/reference/gt_nfl_cols_label.md)
  now allows rendering of player headshots in column labels. Thanks
  Steven Patton[@spatto12](https://github.com/spatto12) for the PR.
  ([\#55](https://github.com/nflverse/nflplotR/issues/55))
- Adjust lists in documentation as the next R version checks for
  correctly formatted lists.
  ([\#56](https://github.com/nflverse/nflplotR/issues/56))
- [`gt_nfl_logos()`](https://nflplotr.nflverse.com/reference/gt_nfl_logos.md)
  and
  [`gt_nfl_wordmarks()`](https://nflplotr.nflverse.com/reference/gt_nfl_logos.md)
  now correctly allow unquoted column names in the `columns` argument.
  ([\#57](https://github.com/nflverse/nflplotR/issues/57))

### Deprecation

- Deprecated the functions `scale_x_nfl`, `scale_y_nfl`,
  `scale_x_nfl_headshots`, `scale_y_nfl_headshots`, `theme_x_nfl`,
  `theme_y_nfl`. These function are slow and require a possibly unstable
  dependency. Please use the far superior
  [`element_nfl_logo()`](https://nflplotr.nflverse.com/reference/element.md)
  and friends instead.
  ([\#50](https://github.com/nflverse/nflplotR/issues/50))

## nflplotR 1.2.0

CRAN release: 2023-09-18

### New Features

- Add new functions
  [`gt_nfl_logos()`](https://nflplotr.nflverse.com/reference/gt_nfl_logos.md)
  and
  [`gt_nfl_wordmarks()`](https://nflplotr.nflverse.com/reference/gt_nfl_logos.md)
  to render logos and wordmarks in
  [`gt()`](https://gt.rstudio.com/reference/gt.html) html tables.
  ([\#39](https://github.com/nflverse/nflplotR/issues/39))
- Add new function
  [`gt_nfl_headshots()`](https://nflplotr.nflverse.com/reference/gt_nfl_headshots.md)
  to render player headshots in
  [`gt()`](https://gt.rstudio.com/reference/gt.html) html tables.
  ([\#41](https://github.com/nflverse/nflplotR/issues/41))
- Add new function
  [`gt_render_image()`](https://nflplotr.nflverse.com/reference/gt_render_image.md)
  to render gt tables to an image in package function examples or
  reproducible examples.
  ([\#42](https://github.com/nflverse/nflplotR/issues/42))
- Add new function
  [`nflverse_sitrep()`](https://nflplotr.nflverse.com/reference/nflverse_sitrep.md)
  to compute a nflverse related situation report.

### Breaking Changes

- The functions
  [`geom_from_path()`](https://nflplotr.nflverse.com/reference/geom_from_path.md),
  [`element_path()`](https://mrcaseb.github.io/ggpath/reference/element_path.html)
  as well as the ref line functions `geom_mean_line()` and
  `geom_median_line()` have been outsourced to the ggpath package.
  nflplotR re-exports them for compatibility reasons. However, the ref
  line functions needed modification in order to work properly with
  ggplot2 scale transformations. Those geoms now require the aesthetics
  `x0` and `y0` instead of `v_var` and `h_var` respectively. This means
  that nflplotR will break code (!) where ref line geoms are called with
  `v_var` and `h_var` aesthetics. This is a hard but necessary step to
  revise an irreparable mistake in the development of the original code.
  ([\#43](https://github.com/nflverse/nflplotR/issues/43))

### Minor Changes

- Update Eagles and Commanders wordmarks with latest versions from NFL.
  ([\#44](https://github.com/nflverse/nflplotR/issues/44))
- Update Bears logo (it’s now the Bear) and secondary color to meet
  their brand guidelines.
  ([\#46](https://github.com/nflverse/nflplotR/issues/46))

Thank you to [@Adeiko](https://github.com/Adeiko), and
[@tanho63](https://github.com/tanho63) for their questions, feedback,
and contributions towards this release.

## nflplotR 1.1.0

CRAN release: 2022-08-11

- nflplotR will internally cache images used in all geoms and elements.
  The cache behavior can be controlled by setting
  `options("nflplotR.cache")` to one of `"memory"`, `"filesystem"`, or
  `"off"`. It is possible to clear the cache with the new function
  [`.nflplotR_clear_cache()`](https://nflplotr.nflverse.com/reference/dot-nflplotR_clear_cache.md).
  This functionality added the dependencies cachem, memoise and
  rappdirs.
- Resolved an issue where
  [`geom_mean_lines()`](https://nflplotr.nflverse.com/reference/geom_lines.md)
  and
  [`geom_median_lines()`](https://nflplotr.nflverse.com/reference/geom_lines.md)
  didn’t draw lines when a scale transformation,
  e.g. `scale_*_reverse()`, was applied.
- Added new function
  [`nfl_team_factor()`](https://nflplotr.nflverse.com/reference/nfl_team_factor.md)
  which creates ordered factors of NFL team names for facetted plots.

## nflplotR 1.0.1

CRAN release: 2022-04-06

- Updated the internal logo and wordmark files with the new Washington
  Commanders design.
- Fixed some issues with `theme-elements` and updated examples.

## nflplotR 1.0.0

CRAN release: 2022-01-21

- Added the
  [`geom_nfl_logos()`](https://nflplotr.nflverse.com/reference/geom_nfl_logos.md)
  geom.
- Added the
  [`geom_mean_lines()`](https://nflplotr.nflverse.com/reference/geom_lines.md)
  and
  [`geom_median_lines()`](https://nflplotr.nflverse.com/reference/geom_lines.md)
  geoms. (v0.0.0.9002)
- [`geom_nfl_logos()`](https://nflplotr.nflverse.com/reference/geom_nfl_logos.md)
  now tries to clean the team abbreviations by calling
  [`nflreadr::clean_team_abbrs()`](https://nflreadr.nflverse.com/reference/clean_team_abbrs.html)
- Added the color and fill scales
  [`scale_color_nfl()`](https://nflplotr.nflverse.com/reference/scale_nfl.md)
  and
  [`scale_fill_nfl()`](https://nflplotr.nflverse.com/reference/scale_nfl.md).
  (v0.0.0.9003)
- Added the axis scales `scale_x_nfl()` and `scale_y_nfl()` in
  combination with the theme update functions `theme_x_nfl()` and
  `theme_y_nfl()`. (v0.0.0.9004)
- Fixed an incompatible position argument in `scale_y_nfl()`.
  (v.0.0.9005)
- Added the function
  [`ggpreview()`](https://nflplotr.nflverse.com/reference/ggpreview.md)
  which allows to preview a ggplot in it’s actual dimensions.
  (v.0.0.9006)
- [`geom_nfl_logos()`](https://nflplotr.nflverse.com/reference/geom_nfl_logos.md)
  now supports a `colour` aesthetic that colorizes the logos.
  (v0.0.9007)
- Added the function
  [`nfl_team_tiers()`](https://nflplotr.nflverse.com/reference/nfl_team_tiers.md)
  that build an NFL team tiers ggplot, thanks to Timo Riske for the
  suggestion. (v.0.0.9008)
- Fixed a bug ([\#10](https://github.com/nflverse/nflplotR/issues/10))
  in
  [`geom_median_lines()`](https://nflplotr.nflverse.com/reference/geom_lines.md)
  and
  [`geom_mean_lines()`](https://nflplotr.nflverse.com/reference/geom_lines.md)
  that caused `alpha` to not work properly. (v.0.0.9009)
- Improved
  [`nfl_team_tiers()`](https://nflplotr.nflverse.com/reference/nfl_team_tiers.md)
  by adding the opportunity to modify `title`, `subtitle`, `caption` of
  the plot. Added functionality to remove tier separation lines for
  combined tiers. Added functionality to run the function in “developer”
  mode which means, that team abbreviations will be plotted instead of
  logos (much faster). (v.0.0.9010)
- Added the
  [`geom_nfl_headshots()`](https://nflplotr.nflverse.com/reference/geom_nfl_headshots.md)
  geom that plots headshots for valid gsis IDs. (v0.0.9011)
- Added the axis scales `scale_x_nfl_headshots()` and
  `scale_y_nfl_headshots()`. (v.0.0.9012)
- Updated internal data to use the new team colors in nflfastR.
  (v.0.0.9013)
- Added the
  [`geom_nfl_wordmarks()`](https://nflplotr.nflverse.com/reference/geom_nfl_wordmarks.md)
  geom that plots NFL wordmarks using valid team abbreviations.
  (v.0.0.9014)
- Added the
  [`geom_from_path()`](https://nflplotr.nflverse.com/reference/geom_from_path.md)
  geom that plots images from urls, local paths and more. (v.0.0.9015)
- Added the ggplot2 theme-elements
  [`element_nfl_logo()`](https://nflplotr.nflverse.com/reference/element.md),
  [`element_nfl_wordmark()`](https://nflplotr.nflverse.com/reference/element.md),
  [`element_nfl_headshot()`](https://nflplotr.nflverse.com/reference/element.md),
  and
  [`element_path()`](https://mrcaseb.github.io/ggpath/reference/element_path.html)
  which translate NFL team abbreviations or player IDs into team logos
  and player headshots. These elements feature a major speed improvement
  over the axis scales `scale_x_nfl_headshots()` and
  `scale_y_nfl_headshots()` and make the package less dependent on an
  underlying package. (v.0.0.0.9016)
