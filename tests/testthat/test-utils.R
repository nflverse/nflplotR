test_that("valid_team_names works", {
  valid_all <- c("AFC", "ARI", "ATL", "BAL", "BUF", "CAR", "CHI", "CIN", "CLE",
                 "DAL", "DEN", "DET", "GB", "HOU", "IND", "JAX", "KC",
                 "LA", "LAC", "LAR", "LV", "MIA", "MIN", "NE", "NFC", "NFL", "NO",
                 "NYG", "NYJ", "OAK", "PHI", "PIT", "SD", "SEA", "SF",
                 "STL", "TB", "TEN", "WAS")

  valid_filtered <- valid_all[!valid_all %in% c("LAR", "OAK", "SD", "STL")]

  expect_identical(valid_team_names(exclude_duplicates = TRUE), valid_filtered)
  expect_identical(valid_team_names(exclude_duplicates = FALSE), valid_all)
})
