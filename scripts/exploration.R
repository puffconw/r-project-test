library(ggplot2)

tri <- read.csv("data/raw/tri_small.csv", check.names = FALSE)

tri_sub <- tri[, c(
  "1. YEAR",
  "8. ST",
  "7. COUNTY",
  "23. INDUSTRY SECTOR",
  "37. CHEMICAL",
  "107. TOTAL RELEASES",
  "51. 5.1 - FUGITIVE AIR",
  "52. 5.2 - STACK AIR",
  "53. 5.3 - WATER",
  "65. ON-SITE RELEASE TOTAL"
)]

names(tri_sub) <- c(
  "year", "state", "county", "industry_sector", "chemical",
  "total_releases", "fugitive_air", "stack_air", "water", "onsite_total"
)

tri_sub$air_releases <- tri_sub$fugitive_air + tri_sub$stack_air

tri_pathway <- data.frame(
  releases = c(tri_sub$air_releases, tri_sub$water),
  pathway = factor(
    c(rep("Air", nrow(tri_sub)), rep("Water", nrow(tri_sub))),
    levels = c("Air", "Water")
  )
)

tri_pathway$log_releases <- log1p(tri_pathway$releases)

p1 <- ggplot(tri_pathway, aes(x = log_releases)) +
  geom_histogram(bins = 30) +
  facet_wrap(~ pathway, ncol = 1, scales = "free_y")

ggsave("output/figures/Figure1_Toxic_Releases_by_Pathway.pdf", p1)
