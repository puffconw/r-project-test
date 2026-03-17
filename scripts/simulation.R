library(ggplot2)

# Load data (use relative path)
tri <- read.csv("data/raw/tri_small.csv", check.names = FALSE)

# Select relevant variables
tri_sub <- tri[, c(
  "51. 5.1 - FUGITIVE AIR",
  "52. 5.2 - STACK AIR",
  "53. 5.3 - WATER"
)]

names(tri_sub) <- c("fugitive_air", "stack_air", "water")

# Create air releases
tri_sub$air_releases <- tri_sub$fugitive_air + tri_sub$stack_air

# Simulation function
simulate_releases <- function(effect_size, noise, n, mu = 2) {
  pathway <- factor(rep(c("Air", "Water"), each = n), levels = c("Air", "Water"))
  
  mu_air <- mu + effect_size
  mu_water <- mu
  
  log_releases <- c(
    rnorm(n, mean = mu_air, sd = noise),
    rnorm(n, mean = mu_water, sd = noise)
  )
  
  data.frame(pathway = pathway, log_releases = log_releases)
}

# Summary function
summarize_by_pathway <- function(sim_dat) {
  tmp <- aggregate(
    log_releases ~ pathway,
    data = sim_dat,
    FUN = function(x) c(mean = mean(x), median = median(x), IQR = IQR(x))
  )
  
  data.frame(
    pathway = tmp$pathway,
    mean_log = tmp$log_releases[, "mean"],
    median_log = tmp$log_releases[, "median"],
    IQR_log = tmp$log_releases[, "IQR"]
  )
}

# Run one simulation
run_one_sim <- function(effect_size, noise, n, mu = 2) {
  sim_dat <- simulate_releases(effect_size = effect_size, noise = noise, n = n, mu = mu)
  sim_sum <- summarize_by_pathway(sim_dat)
  
  list(
    data = sim_dat,
    summary = sim_sum
  )
}

# Parameter grid
effect_sizes <- seq(0, 2, length.out = 10)
noise_levels <- c(0.5, 1, 2)

n_real <- nrow(tri_sub)
sample_sizes <- unique(round(seq(max(50, n_real * 0.01), n_real * 0.10, length.out = 10)))

# Run simulations
sim_store <- list()
idx <- 1

for (e in effect_sizes) {
  for (n in sample_sizes) {
    for (s in noise_levels) {
      out <- run_one_sim(effect_size = e, noise = s, n = n)
      sim_store[[idx]] <- list(
        effect_size = e,
        sample_size = n,
        noise = s,
        data = out$data,
        summary = out$summary
      )
      idx <- idx + 1
    }
  }
}

# Combine results
plot_df <- do.call(rbind, lapply(sim_store, function(x) {
  m_air <- x$summary$mean_log[x$summary$pathway == "Air"]
  m_water <- x$summary$mean_log[x$summary$pathway == "Water"]
  
  data.frame(
    effect_size = x$effect_size,
    sample_size = x$sample_size,
    noise = factor(x$noise, levels = c(0.5, 1, 2)),
    mean_diff = m_air - m_water
  )
}))

# Save processed data
write.csv(plot_df, "data/processed/simulation_summary.csv", row.names = FALSE)

# Plot heatmap
p_sim <- ggplot(plot_df, aes(x = effect_size, y = sample_size, fill = mean_diff)) +
  geom_tile(color = "white", linewidth = 0.2) +
  facet_wrap(~ noise, nrow = 1,
             labeller = labeller(noise = function(x) paste("Noise =", x))) +
  scale_fill_gradient(low = "grey20", high = "skyblue", name = "Mean diff") +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(
    title = "Simulation Results: Estimated Mean Difference (Air - Water)",
    x = "Effect size on log scale",
    y = "Sample size per pathway (n)"
  ) +
  theme_minimal()

# Save figure
ggsave(
  filename = "output/figures/Simulation_Heatmap.pdf",
  plot = p_sim,
  device = "pdf",
  width = 10,
  height = 6
)
