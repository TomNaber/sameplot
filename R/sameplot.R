#' Render a plot consistently across RStudio, saved files, and knitr output
#'
#' `sameplot()` renders `plot` to a temporary PNG using a ragg device and returns
#' a knitr image include pointing to that PNG. This makes the displayed output
#' consistent across interactive use and knitted documents. Optionally, when
#' `save = TRUE`, the plot is also saved to `file` using a ragg device inferred
#' from the file extension.
#'
#' @param plot A plot object. Typically a ggplot, but any object whose `print()`
#'   method draws to the active graphics device.
#' @param file Output filename (relative or absolute). Must include an extension
#'   `.png` or `.tif`/`.tiff`. Required when `save = TRUE`.
#' @param width,height Plot size.
#' @param units Units for `width` and `height` (e.g., `"in"`, `"cm"`, `"mm"`).
#' @param background Background color passed to ragg devices.
#' @param res Resolution in pixels per inch passed to ragg devices.
#' @param scaling Increase to make plot bigger within the same physical size.
#' @param bitsize Record color as 8 bit or 16 bit. 16 bit may be useful for smoother gradients.
#' @param save Logical; if `TRUE`, also save the plot to `file`.
#'
#' @return An object returned by [knitr::include_graphics()] (rendered by knitr
#'   in HTML/PDF output).
#'
#' @examplesIf requireNamespace("ggplot2", quietly = TRUE)
#' p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()
#' sameplot(p)  # display via temp PNG
#'
#' # Save to a temporary folder (safe for R CMD check)
#' out_png <- file.path(tempdir(), "p.png")
#' out_tif <- file.path(tempdir(), "p.tiff")
#' sameplot(p, out_png, save = TRUE)
#' sameplot(p, out_tif, save = TRUE)
#' @export
sameplot <- function(plot,
                     file = NULL,
                     width = 6.4,
                     height = 4.8,
                     units = "in",
                     background = "white",
                     scaling = 1,
                     bitsize = 8,
                     res = 300,
                     save = FALSE) {
  if (!is.null(file))
    stopifnot(is.character(file), length(file) == 1L)

  if (isTRUE(save) && (is.null(file) || !nzchar(file))) {
    stop("Please provide a filename when save = TRUE.", call. = FALSE)
  }

  ext <- if (!is.null(file) &&
             nzchar(file))
    paste0(".", tools::file_ext(file))
  else
    ".png"
  ext_key <- tolower(ext)

  if ((isTRUE(save) || (!is.null(file) && nzchar(file))) &&
      !ext_key %in% c(".png", ".tif", ".tiff")) {
    stop("Extension must be .png or .tif/.tiff", call. = FALSE)
  }

  write_image <- function(device, filename) {
    device(
      filename = filename,
      width = width,
      height = height,
      units = units,
      background = background,
      res = res,
      scaling = scaling,
      bitsize = bitsize
    )
    on.exit(grDevices::dev.off(), add = TRUE)
    print(plot)
  }

  temp_base <- tempfile("_plot_")

  if (ext_key == ".png" && isTRUE(save)) {
    temp_fig <- paste0(temp_base, ext)
    temp_png <- temp_fig
    write_image(ragg::agg_png, temp_fig)
  } else if (ext_key != ".png" || isFALSE(save)) {
    temp_png <- paste0(temp_base, ".png")
    write_image(ragg::agg_png, temp_png)
  }

  if (ext_key %in% c(".tif", ".tiff") && isTRUE(save)) {
    temp_fig <- paste0(temp_base, ext)
    write_image(ragg::agg_tiff, temp_fig)
  }

  if (isTRUE(save)) {
    outdir <- dirname(file)
    if (!identical(outdir, ".") && !dir.exists(outdir)) {
      dir.create(outdir, recursive = TRUE, showWarnings = FALSE)
    }
    file.copy(temp_fig, file, overwrite = TRUE)
  }

  if ("rel_path" %in% names(formals(knitr::include_graphics))) {
    knitr::include_graphics(path = temp_png,
                            dpi = res,
                            rel_path = FALSE)
  } else {
    knitr::include_graphics(path = temp_png, dpi = res)
  }
}
