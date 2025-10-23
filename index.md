# nflplotR

The goal of nflplotR is to provide functions and geoms that help
visualization of NFL related analysis. It provides a ggplot2 geom that
does the heavy lifting of plotting NFL logos in high quality, with
correct aspect ratio and possible transparency.

## Installation

The easiest way to get nflplotR is to install it from
[CRAN](https://cran.r-project.org/package=nflplotR) with:

``` r
install.packages("nflplotR")
```

To get a bug fix or to use a feature from the development version, you
can install the development version of nflplotR either from
[GitHub](https://github.com/nflverse/nflplotR/) with:

``` r
if (!require("pak")) install.packages("pak")
pak::pak("nflverse/nflplotR")
```

or prebuilt from the [development repo](https://nflverse.r-universe.dev)
with:

``` r
install.packages("nflplotR", repos = c("https://nflverse.r-universe.dev", getOption("repos")))
```

## Usage

Please see the **[Get Started with
nflplotR](https://nflplotr.nflverse.com/articles/nflplotR.html)** and
**[nflplotR & the gt
Package](https://nflplotr.nflverse.com/articles/gt.html)** articles.

## Getting help

The best places to get help on this package are:

- the [nflverse discord](https://discord.com/invite/5Er2FBnnQa) (for
  both this package as well as anything R/NFL related)
- opening [an
  issue](https://github.com/nflverse/nflplotR/issues/new/choose)

## Contributing

Many hands make light work! Here are some ways you can contribute to
this project:

- You can [open an
  issue](https://github.com/nflverse/nflplotR/issues/new/choose) if
  you’d like to request specific data or report a bug/error.

- If you’d like to contribute code, please check out [the contribution
  guidelines](https://nflplotr.nflverse.com/CONTRIBUTING.html).

## Terms of Use

The R code for this package is released as open source under the [MIT
License](https://nflplotr.nflverse.com/LICENSE.html). NFL data accessed
by this package belong to their respective owners, and are governed by
their terms of use.
