library(ggplot2)

# Load processed subset data
tri <- read.csv("data/raw/tri_small.csv", check.names = FALSE)

# Since tri_small.csv already contains cleaned/renamed variables,
# use it directly
tri_sub <- tri

# Create long-format dataset for pathway comparison
tri_pathway <- data.frame(
  releases = c(tri_sub$air_releases, tri_sub$water),
  pathway = factor(
    c(rep("Air", nrow(tri_sub)), rep("Water", nrow(tri_sub))),
    levels = c("Air", "Water")
  )
)

# Log transformation
tri_pathway$log_releases <- log1p(tri_pathway$releases)

# Summary statistics
pathway_summary_raw <- aggregate(
  log_releases ~ pathway,
  data = tri_pathway,
  FUN = function(x) {
    c(
      mean = mean(x, na.rm = TRUE),
      median = median(x, na.rm = TRUE),
      IQR = IQR(x, na.rm = TRUE)
    )
  }
)

pathway_summary <- data.frame(
  pathway = pathway_summary_raw$pathway,
  mean_log = pathway_summary_raw$log_releases[, "mean"],
  median_log = pathway_summary_raw$log_releases[, "median"],
  IQR_log = pathway_summary_raw$log_releases[, "IQR"]
)

# Save processed data
write.csv(tri_sub, "data/processed/tri_subset.csv", row.names = FALSE)
write.csv(pathway_summary, "data/processed/pathway_summary.csv", row.names = FALSE)

# Plot
p1 <- ggplot(tri_pathway, aes(x = log_releases)) +
  geom_histogram(bins = 30) +
  facet_wrap(~ pathway, ncol = 1, scales = "free_y") +
  labs(
    title = "Distribution of Toxic Chemical Releases by Pathway",
    x = "log(1 + releases in pounds)",
    y = "Number of facility records"
  ) +
  theme_classic()

# Save figure
ggsave(
  filename = "output/figures/Figure1_Toxic_Releases_by_Pathway.pdf",
  plot = p1,
  device = "pdf",
  width = 180,
  height = 220,
  units = "mm"
)
