
<!-- README.md is generated from README.Rmd. Please edit that file -->

# nflplotR <a href='https://nflplotr.nflverse.com'><img src='man/figures/logo.png' align="right" width="25%" min-width="120px" /></a>

<!-- badges: start -->

[![CRAN
status](https://img.shields.io/cran/v/nflplotR?style=flat-square&logo=R&label=CRAN)](https://CRAN.R-project.org/package=nflplotR)
[![CRAN
downloads](http://cranlogs.r-pkg.org/badges/grand-total/nflplotR)](https://CRAN.R-project.org/package=nflplotR)
[![Dev
status](https://img.shields.io/github/r-package/v/nflverse/nflplotR/main?label=dev%20version&style=flat-square&logo=github)](https://nflplotr.nflverse.com)
[![R build
status](https://img.shields.io/github/workflow/status/nflverse/nflplotR/R-CMD-check?label=R%20check&style=flat-square&logo=github)](https://github.com/nflverse/nflplotR/actions)
[![Codecov test
coverage](https://codecov.io/gh/nflverse/nflplotR/branch/main/graph/badge.svg)](https://app.codecov.io/gh/nflverse/nflplotR?branch=main)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg?style=flat-square)](https://lifecycle.r-lib.org/articles/stages.html)
[![nflverse
support](https://img.shields.io/discord/789805604076126219?color=7289da&label=nflverse%20support&logo=discord&logoColor=fff&style=flat-square)](https://discord.com/invite/5Er2FBnnQa)
<!-- badges: end -->

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
if (!require("remotes")) install.packages("remotes")
remotes::install_github("nflverse/nflplotR")
```

or prebuilt from the [development repo](https://nflverse.r-universe.dev)
with:

``` r
install.packages("nflplotR", repos = "https://nflverse.r-universe.dev")
```

## Usage

Please see the **‘[Get Started with
nflplotR](https://nflplotr.nflverse.com/articles/nflplotR.html)’
article**.

## Getting help

The best places to get help on this package are:

-   the [nflverse discord](https://discord.com/invite/5Er2FBnnQa) (for
    both this package as well as anything R/NFL related)
-   opening [an
    issue](https://github.com/nflverse/nflplotR/issues/new/choose)

## Contributing

Many hands make light work! Here are some ways you can contribute to
this project:

-   You can [open an
    issue](https://github.com/nflverse/nflplotR/issues/new/choose) if
    you’d like to request specific data or report a bug/error.

-   If you’d like to contribute code, please check out [the contribution
    guidelines](https://nflplotr.nflverse.com/CONTRIBUTING.html).

## Terms of Use

The R code for this package is released as open source under the [MIT
License](https://nflplotr.nflverse.com/LICENSE.html). NFL data accessed
by this package belong to their respective owners, and are governed by
their terms of use.
