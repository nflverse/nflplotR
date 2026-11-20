test_that("geom from path works", {
  # skip this on cran because we load images from github which could fail
  skip_on_cran()
  # Linux links magick against the system ImageMagick, which rounds the alpha
  # modification differently (off by 1/255) than the bundled ImageMagick on
  # macOS and Windows. The snapshot would then differ depending on the
  # distribution's ImageMagick version.
  skip_on_os("linux")

  library(ggplot2)

  # create x-y-coordinates of a pentagon and add nflverse logo urls
  df <- data.frame(
    a = sin(2 * pi * (0) / 5),
    b = cos(2 * pi * (0) / 5),
    url = c(
      "https://github.com/nflverse/nflseedR/raw/master/man/figures/logo.png"
    )
  )

  # plot images directly from url and apply transparency
  p1 <- ggplot(df, aes(x = a, y = b)) +
    geom_from_path(aes(path = url), width = 0.1, alpha = 0.5) +
    coord_cartesian(xlim = c(-2, 2), ylim = c(-1.3, 1.5)) +
    theme_void()

  vdiffr::expect_doppelganger("p1", p1)
})
