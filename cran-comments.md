## Resubmission
This is a resubmission of `sameplot`. In response to CRAN feedback I have:
- Removed the single quotes around knitr::include_graphics() in the DESCRIPTION.
- Added methodological reference in the DESCRIPTION in the requested format (Authors (year) <doi:...>)
- Ensured no residual temporary files/folders are left behind: examples/tests write only to tempfile()/tempdir() and clean up created files.

## Test environments
- Windows 11 (local), R 4.5.2
- win-builder (devel and release)
- R-hub: windows, linux, macos, macos-arm64

## R CMD check results
0 errors | 0 warnings | 0 notes

## Downstream dependencies
Not applicable.

## Reverse dependencies
Not applicable.
