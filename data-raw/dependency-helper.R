# Run this to update the DESCRIPTION
imports <- c(
  "magrittr",
  "rlang",
  "cli",
  "ggplot2",
  "magick",
  "grid"
)
purrr::walk(imports, usethis::use_package, "Imports")
usethis::use_tidy_description()
rm(imports)
