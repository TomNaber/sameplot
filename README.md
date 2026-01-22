
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sameplot

<!-- badges: start -->

[![R-CMD-check](https://github.com/TomNaber/sameplot/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/TomNaber/sameplot/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

Render plots consistently across interactive R sessions, saved files,
and knitr output by drawing to a `ragg` device and displaying the
resulting image via `knitr::include_graphics()`.

## Why?

RStudio’s plot pane, saved figures, and knitted documents can differ due
to device and rendering differences. `sameplot()` standardizes output by
always rendering the plot to an image first and then displaying *that*
image.

## Installation

You can install the development version from GitHub:

``` r
install.packages("pak")
pak::pak("TomNaber/sameplot")
```

Alternatively (remotes):

``` r
install.packages("remotes")
remotes::install_github("TomNaber/sameplot")
```

## Usage

``` r
suppressPackageStartupMessages(library(sameplot))
suppressPackageStartupMessages(library(ggplot2))

p <- ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  theme_minimal()

# 1) Display via a temporary PNG (useful in RStudio and when knitting)
sameplot(p)
```

<img src="C:\Users\Tom\AppData\Local\Temp\RtmpEnd6oK\_plot_5460144c3ae.png" alt="" width="100%" />

``` r

# Using a temporary folder as example
tmp <- file.path(tempdir(), "sameplot-readme")

# 2) Save a PNG (to tempdir)
sameplot(p, file = file.path(tmp, "mtcars.png"), save = TRUE)
```

<img src="C:\Users\Tom\AppData\Local\Temp\RtmpEnd6oK\_plot_5460410a15a0.png" alt="" width="100%" />

``` r

# 3) Save a TIFF (to tempdir; still displays via a temp PNG for compatibility)
sameplot(p, file = file.path(tmp, "mtcars.tiff"), save = TRUE)
```

<img src="C:\Users\Tom\AppData\Local\Temp\RtmpEnd6oK\_plot_546024517b96.png" alt="" width="100%" />

## Notes

- Supported output extensions for saving: `.png`, `.tif`, `.tiff`.

- When `save = FALSE`, figures are written to a temporary location and
  cleaned up when the R session ends.

- `dpi` in the knitr output is set to the same value as `res` used for
  the `ragg` device.

- **When knitting to HTML with `rmarkdown::html_document`, set
  `self_contained: true`** in the YAML. This ensures the images produced
  by `sameplot()` are embedded in the HTML rather than linked as
  external files that are not accessible. Example:

  ``` yaml
  output:
    html_document:
      self_contained: true
  ```
