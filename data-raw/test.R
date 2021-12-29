library(ggplot2)

ggplot(mpg, aes(cyl, hwy)) +
  geom_point() +
  scale_x_continuous(breaks = 4:5, labels = c("ARI", "ATL")) +
  theme(
    axis.text.x = element_image()
  ) +
  NULL
