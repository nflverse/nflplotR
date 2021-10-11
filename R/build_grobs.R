# INTERNAL HELPER THAT BUILD THE GROBS FOR
# GEOM LOGOS AND HEADSHOTS
build_grobs <- function(i, alpha, colour, data, teams = TRUE) {
  make_null <- FALSE
  if(isTRUE(teams)){
    team_abbr <- data$team_abbr[i]
    image_to_read <- logo_list[[team_abbr]]
    if (is.na(team_abbr)) make_null <- TRUE
  } else{
    gsis <- data$player_gsis[i]
    headshot_map <- nflreadr::rds_from_url("https://github.com/nflverse/nflfastR-roster/raw/master/src/headshot_gsis_map.rds")
    image_to_read <- headshot_map$headshot_nfl[headshot_map$gsis_id == gsis]
    if(length(image_to_read) == 0) image_to_read <- "https://static.www.nfl.com/image/private/t_player_profile_landscape_2x/f_auto/league/rfuw3dh4aah4l4eeuubp.png"
  }
  if (is.na(make_null)){
    grid <- grid::nullGrob()
  } else if (is.null(alpha)) {
    img <- magick::image_read(image_to_read)
    col <- colour[i]
    if (!is.null(col) && col %in% "b/w"){
      new <- magick::image_quantize(img, colorspace = 'gray')
    } else{
      opa <- ifelse(is.na(col) || is.null(col), 0, 100)
      col <- ifelse(is.na(col) || is.null(col), "none", col)
      new <- magick::image_colorize(img, opa, col)
    }
    grid <- grid::rasterGrob(new)
  } else if (length(alpha) == 1L) {
    if (as.numeric(alpha) <= 0 || as.numeric(alpha) >= 1) {
      cli::cli_abort("aesthetic {.var alpha} requires a value between {.val 0} and {.val 1}")
    }
    img <- magick::image_read(image_to_read)
    new <- magick::image_fx(img, expression = paste0(alpha, "*a"), channel = "alpha")
    col <- colour[i]
    if (!is.null(col) && col %in% "b/w"){
      new <- magick::image_quantize(new, colorspace = 'gray')
    } else{
      opa <- ifelse(is.na(col) || is.null(col), 0, 100)
      col <- ifelse(is.na(col) || is.null(col), "none", col)
      new <- magick::image_colorize(new, opa, col)
    }
    grid <- grid::rasterGrob(new)
  } else {
    if (any(as.numeric(alpha) < 0) || any(as.numeric(alpha) > 1)) {
      cli::cli_abort("aesthetics {.var alpha} require values between {.val 0} and {.val 1}")
    }
    img <- magick::image_read(image_to_read)
    new <- magick::image_fx(img, expression = paste0(alpha[i], "*a"), channel = "alpha")
    col <- colour[i]
    if (!is.null(col) && col %in% "b/w"){
      new <- magick::image_quantize(new, colorspace = 'gray')
    } else{
      opa <- ifelse(is.na(col) || is.null(col), 0, 100)
      col <- ifelse(is.na(col) || is.null(col), "none", col)
      new <- magick::image_colorize(new, opa, col)
    }
    grid <- grid::rasterGrob(new)
  }

  grid$vp <- grid::viewport(
    x = grid::unit(data$x[i], "native"),
    y = grid::unit(data$y[i], "native"),
    width = grid::unit(data$width[i], "npc"),
    height = grid::unit(data$height[i], "npc"),
    just = c(data$hjust[i], data$vjust[i]),
    angle = data$angle[i],
    name = paste("geom_nfl.panel", data$PANEL[i],
                 "row", i,
                 sep = "."
    )
  )

  grid$name <- paste("nfl.grob", i, sep = ".")

  grid
}
