# Package index

## Geoms

ggplot2 geoms (geometric objects) that create a `layer()`. A layer
combines data, aesthetic mapping, a geom (geometric object), a stat
(statistical transformation), and a position adjustment.

- [`geom_from_path()`](https://nflplotr.nflverse.com/reference/geom_from_path.md)
  : ggplot2 Layer for Visualizing Images from URLs or Local Paths
- [`geom_median_lines()`](https://nflplotr.nflverse.com/reference/geom_lines.md)
  [`geom_mean_lines()`](https://nflplotr.nflverse.com/reference/geom_lines.md)
  : ggplot2 Layer for Horizontal and Vertical Reference Lines
- [`geom_nfl_headshots()`](https://nflplotr.nflverse.com/reference/geom_nfl_headshots.md)
  : ggplot2 Layer for Visualizing NFL Player Headshots
- [`geom_nfl_logos()`](https://nflplotr.nflverse.com/reference/geom_nfl_logos.md)
  : ggplot2 Layer for Visualizing NFL Team Logos
- [`geom_nfl_wordmarks()`](https://nflplotr.nflverse.com/reference/geom_nfl_wordmarks.md)
  : ggplot2 Layer for Visualizing NFL Team Wordmarks

## Theme Elements

Themes control the display of all non-data elements of the plot. Theme
elements can tweak individual settings inside `theme()`.

- [`element_nfl_logo()`](https://nflplotr.nflverse.com/reference/element.md)
  [`element_nfl_wordmark()`](https://nflplotr.nflverse.com/reference/element.md)
  [`element_nfl_headshot()`](https://nflplotr.nflverse.com/reference/element.md)
  : Theme Elements for Image Grobs

## Scales

Scales control the details of how data values are translated to visual
properties. Override the default scales to tweak details like the axis
labels or legend keys, or to use a completely different translation from
data to aesthetic.

- [`scale_color_nfl()`](https://nflplotr.nflverse.com/reference/scale_nfl.md)
  [`scale_colour_nfl()`](https://nflplotr.nflverse.com/reference/scale_nfl.md)
  [`scale_fill_nfl()`](https://nflplotr.nflverse.com/reference/scale_nfl.md)
  : Scales for NFL Team Colors

## Tables

Utility functions that work with the gt package to create html tables.

- [`gt_nfl_cols_label()`](https://nflplotr.nflverse.com/reference/gt_nfl_cols_label.md)
  : Render Logos, Wordmarks, and Headshots in 'gt' Table Column Labels
- [`gt_nfl_headshots()`](https://nflplotr.nflverse.com/reference/gt_nfl_headshots.md)
  : Render Player Headshots in 'gt' Tables
- [`gt_nfl_logos()`](https://nflplotr.nflverse.com/reference/gt_nfl_logos.md)
  [`gt_nfl_wordmarks()`](https://nflplotr.nflverse.com/reference/gt_nfl_logos.md)
  : Render Logos and Wordmarks in 'gt' Tables
- [`gt_pct_bar()`](https://nflplotr.nflverse.com/reference/gt_pct_bar.md)
  : Format Columns of 'gt' Tables as Percentage Bars
- [`gt_render_image()`](https://nflplotr.nflverse.com/reference/gt_render_image.md)
  : Render 'gt' Table to Temporary png File

## Utilities

Various helper functions.

- [`ggpreview()`](https://nflplotr.nflverse.com/reference/ggpreview.md)
  : Preview ggplot in Specified Dimensions
- [`nfl_team_factor()`](https://nflplotr.nflverse.com/reference/nfl_team_factor.md)
  : Create Ordered NFL Team Name Factor
- [`nfl_team_tiers()`](https://nflplotr.nflverse.com/reference/nfl_team_tiers.md)
  : Create NFL Team Tiers
- [`valid_team_names()`](https://nflplotr.nflverse.com/reference/valid_team_names.md)
  : Output Valid NFL Team Abbreviations
- [`.nflplotR_clear_cache()`](https://nflplotr.nflverse.com/reference/dot-nflplotR_clear_cache.md)
  : Clear nflplotR Cache
- [`nflverse_sitrep`](https://nflplotr.nflverse.com/reference/nflverse_sitrep.md)
  : Get a Situation Report on System, nflverse Package Versions and
  Dependencies
