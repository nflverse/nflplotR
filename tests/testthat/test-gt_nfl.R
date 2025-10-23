test_that("gt_pct_bar works", {
  set.seed(20)
  df <- data.frame(
    letters = sample(LETTERS, 10, TRUE),
    value = sample(100:500, 10, FALSE),
    pctl = rev(c(0, 1, 5, 10, 20, 45, 50, 75, 98, 100))
  )

  tbl <- gt::gt(df, id = "test1") |>
    nflplotR::gt_pct_bar(
      "value",
      "pctl",
      hide_col_pct = FALSE,
      value_padding_left = ifelse(df$pctl < 25, "110%", "10px"),
      fill_border.radius = "3px",
      background_border.radius = "5px"
    ) |>
    gt::cols_width(value ~ gt::px(200)) |>
    gt::cols_align("left", "value")

  expect_snapshot(tbl)

  tbl <- gt::gt(df, id = "test2") |>
    nflplotR::gt_pct_bar(
      "value",
      "pctl",
      hide_col_pct = FALSE,
      value_position = "above",
      # with value_position = "above", we need an absolute value of bar heights!
      background_fill.height = "5px",
      background_fill.color = "LightGray"
    ) |>
    gt::cols_width(value ~ gt::px(100)) |>
    gt::cols_align("center", "value")

  expect_snapshot(tbl)
})
