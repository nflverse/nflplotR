test_that("geom lines work", {
  library(ggplot2)

  # inherit top level aesthetics
  p1 <- ggplot(mtcars, aes(x = disp, y = mpg, h_var = mpg, v_var = disp)) +
    geom_point() +
    geom_median_lines() +
    geom_mean_lines(color = "blue") +
    theme_minimal()

  # draw horizontal line only
  p2 <- ggplot(mtcars, aes(x = disp, y = mpg, h_var = mpg)) +
    geom_point() +
    geom_median_lines() +
    geom_mean_lines(color = "blue") +
    theme_minimal()

  # draw vertical line only
  p3 <- ggplot(mtcars, aes(x = disp, y = mpg, v_var = disp)) +
    geom_point() +
    geom_median_lines() +
    geom_mean_lines(color = "blue") +
    theme_minimal()

  # choose your own value
  p4 <- ggplot(mtcars, aes(x = disp, y = mpg)) +
    geom_point() +
    geom_median_lines(v_var = 400, h_var = 15) +
    geom_mean_lines(v_var = 150, h_var = 30, color = "blue") +
    theme_minimal()

  vdiffr::expect_doppelganger("p1", p1)
  vdiffr::expect_doppelganger("p2", p2)
  vdiffr::expect_doppelganger("p3", p3)
  vdiffr::expect_doppelganger("p4", p4)
})
