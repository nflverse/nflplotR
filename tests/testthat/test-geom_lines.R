test_that("geom lines work", {
  library(ggplot2)

  # inherit top level aesthetics
  p1 <- ggplot(mtcars, aes(x = disp, y = mpg, y0 = mpg, x0 = disp)) +
    geom_point() +
    geom_median_lines() +
    geom_mean_lines(color = "blue") +
    theme_minimal()

  # draw horizontal line only
  p2 <- ggplot(mtcars, aes(x = disp, y = mpg, y0 = mpg)) +
    geom_point() +
    geom_median_lines() +
    geom_mean_lines(color = "blue") +
    theme_minimal()

  # draw vertical line only
  p3 <- ggplot(mtcars, aes(x = disp, y = mpg, x0 = disp)) +
    geom_point() +
    geom_median_lines() +
    geom_mean_lines(color = "blue") +
    theme_minimal()

  # choose your own value
  p4 <- ggplot(mtcars, aes(x = disp, y = mpg)) +
    geom_point() +
    geom_median_lines(x0 = 400, y0 = 15) +
    geom_mean_lines(x0 = 150, y0 = 30, color = "blue") +
    theme_minimal()

  vdiffr::expect_doppelganger("p1", p1)
  vdiffr::expect_doppelganger("p2", p2)
  vdiffr::expect_doppelganger("p3", p3)
  vdiffr::expect_doppelganger("p4", p4)
})
