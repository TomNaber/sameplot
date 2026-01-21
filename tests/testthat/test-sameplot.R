test_that("sameplot validates inputs", {
  skip_if_not_installed("ragg")
  skip_if_not_installed("knitr")
  skip_if_not_installed("ggplot2")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  # save=TRUE requires a non-empty filename
  expect_error(
    sameplot(p, save = TRUE),
    "Please provide a filename",
    fixed = FALSE
  )
  expect_error(
    sameplot(p, file = "", save = TRUE),
    "Please provide a filename",
    fixed = FALSE
  )

  # Unsupported extension should error when file is provided
  expect_error(
    sameplot(p, file = "x.jpg", save = FALSE),
    "Extension must be",
    fixed = FALSE
  )
  expect_error(
    sameplot(p, file = "x.jpg", save = TRUE),
    "Extension must be",
    fixed = FALSE
  )
})

test_that("sameplot saves files for supported extensions", {
  skip_if_not_installed("ragg")
  skip_if_not_installed("knitr")
  skip_if_not_installed("ggplot2")

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  # PNG
  out_png <- file.path(tempdir(), "sameplot-test", "p.png")
  unlink(dirname(out_png), recursive = TRUE, force = TRUE)
  expect_silent(sameplot(p, file = out_png, save = TRUE))
  expect_true(file.exists(out_png))
  expect_gt(file.info(out_png)$size, 0)

  # TIFF
  out_tif <- file.path(tempdir(), "sameplot-test", "p.tiff")
  if (file.exists(out_tif)) unlink(out_tif)
  expect_silent(sameplot(p, file = out_tif, save = TRUE))
  expect_true(file.exists(out_tif))
  expect_gt(file.info(out_tif)$size, 0)
})
