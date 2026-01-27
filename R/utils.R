.sameplot_check_self_contained_html <- function() {
  if (!isTRUE(getOption("knitr.in.progress"))) return(invisible(TRUE))

  if (!requireNamespace("knitr", quietly = TRUE)) return(invisible(TRUE))
  output_type <- knitr::opts_knit$get("rmarkdown.pandoc.to")
  if (!identical(output_type, "html")) return(invisible(TRUE))

  args <- knitr::opts_knit$get("rmarkdown.pandoc.args")
  if (is.null(args)) args <- character()

  is_self_contained <- any(args == "--self-contained") ||
    (any(args == "--embed-resources") && any(args == "--standalone"))

  if (!isTRUE(is_self_contained)) {
    stop(
      "sameplot() was called while knitting to HTML, but the document is not self-contained.\n\n",
      "Fix: add this to your YAML:\n",
      "output:\n",
      "  html_document:\n",
      "    self_contained: true\n\n",
      "Or render with: rmarkdown::html_document(self_contained = TRUE)\n",
      call. = FALSE
    )
  }

  invisible(TRUE)
}
