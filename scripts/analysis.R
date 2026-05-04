---
title: "Differences in Toxic Chemical Release Pathways: A Comparison of Air and Water Releases"
author: "Kira Lu"
date: "`r Sys.Date()`"
editor_options:
  chunk_output_type: console
output:
  pdf_document:
    latex_engine: xelatex
    toc: true
    toc_depth: 1
    number_sections: true
urlcolor: blue
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning = FALSE)
```

# Introduction

## Research Question

This study investigates whether the magnitude of toxic chemical releases differs between air and water release pathways.

## Scientific Background

Environmental exposure to toxic chemicals varies by release pathway, with air and water pathways presenting different risks to human health and ecosystems. Previous studies have shown that toxic exposure may be associated with adverse health outcomes, particularly in vulnerable populations.^1,2^ The U.S. Environmental Protection Agency’s Toxics Release Inventory (TRI) provides a comprehensive dataset to examine these patterns across industrial facilities.^3^

# Methods

## Data

The data used in this study come from the U.S. Environmental Protection Agency (EPA) Toxics Release Inventory (TRI) 2024 dataset. Due to GitHub file size limitations, a subset of the dataset (`tri_small.csv`) was used.

The TRI dataset includes facility-level records reported by industrial facilities to the EPA. The analytic dataset included 5,000 facility records with non-missing values for both air and water releases.

The key variables include:

- `air_releases`: sum of fugitive and stack air emissions
- `water`: total water releases

A long-format dataset was created to compare the two release pathways. A log transformation (log(1 + releases)) was applied to reduce skewness and improve comparability between distributions.

```{r, results='hide'}
# Package
library(ggplot2)

# Load data
tri <- read.csv("tri_small.csv", check.names = FALSE)

# Use processed subset directly
tri_sub <- tri

# Count
nrow(tri_sub)
sum(!is.na(tri_sub$air_releases))
sum(!is.na(tri_sub$water))

# Create long-format dataset
tri_pathway <- data.frame(
  releases = c(tri_sub$air_releases, tri_sub$water),
  pathway = factor(
    c(rep("Air", nrow(tri_sub)), rep("Water", nrow(tri_sub))),
    levels = c("Air", "Water")
  )
)

# Log transform
tri_pathway$log_releases <- log1p(tri_pathway$releases)
```

## Statistical Analysis

To compare release amounts between pathways, a Wilcoxon rank-sum test was used because the release data are highly skewed and do not satisfy the assumptions of normality required for a two-sample t-test.

The hypotheses were:

- **H0:** There is no difference in toxic release amounts between air and water pathways.
- **H1:** There is a difference in toxic release amounts between air and water pathways.

# Results

## Visualization

The following histogram and boxplot were used to visualize the distribution of log-transformed toxic releases by pathway.

```{r, results='hide'}
ggplot(tri_pathway, aes(x = log_releases)) +
  geom_histogram(bins = 30) +
  facet_wrap(~ pathway, ncol = 1, scales = "free_y") +
  labs(
  title = "Distribution of Log-Transformed Toxic Releases by Pathway",
  x = "Log(1 + Releases, lbs)",
  y = "Number of Facility Records"
    ) +
  theme_classic()
```

```{r, results='hide'}
ggplot(tri_pathway, aes(x = pathway, y = log_releases)) +
  geom_boxplot() +
  labs(
  title = "Comparison of Log-Transformed Toxic Releases by Pathway",
  x = "Release Pathway",
  y = "Log(1 + Releases, lbs)"
  ) +
  theme_classic()
```

## Statistical Test

```{r}
test_result <- wilcox.test(log_releases ~ pathway, data = tri_pathway)
test_result
```

A Wilcoxon rank-sum test was conducted to assess differences in log-transformed toxic release amounts between air and water pathways. 

The results indicated a statistically significant difference between the two pathways (W = 19635229, p < 2.2e-16). This suggests that the distribution of toxic releases differs significantly depending on the release pathway.

Although the p-value indicates strong statistical significance, it does not directly reflect the magnitude of the difference. Therefore, interpretation should consider both statistical and practical significance.

## Interpretation

The distributions of log-transformed toxic releases were visualized using histograms and boxplots. The results show that water releases are highly concentrated near zero with several extreme outliers, while air releases exhibit a broader distribution.

Descriptive patterns suggest that air releases have a higher median and greater variability compared to water releases. This indicates that air emissions tend to be more widely distributed across facilities, whereas water releases are typically minimal but occasionally extreme.

These findings highlight meaningful differences in release patterns between pathways, suggesting that different environmental and regulatory considerations may apply to air versus water emissions.

# Conclusion

This analysis demonstrates that toxic release amounts differ significantly between air and water pathways in the TRI dataset. Air releases show a broader distribution, while water releases are concentrated near zero with extreme outliers.

These findings suggest that release pathway is strongly associated with differences in both the magnitude and variability of toxic releases. From a public health and environmental perspective, these differences may have implications for monitoring strategies and regulatory policies, as distinct pathways may require tailored approaches to risk assessment and control.

# Limitation

One limitation of this analysis is that it relies on a subset of the TRI dataset, which may not fully represent all facilities or geographic variation. In addition, the analysis does not account for differences in facility size, industry type, or regulatory compliance, which may influence the magnitude of reported releases.

Furthermore, the use of a non-parametric test limits the ability to estimate the magnitude of differences between groups. Future analyses could incorporate additional covariates and modeling approaches to better understand the drivers of variation in toxic releases.

# GitHub Repository

The GitHub repository containing the data, scripts, and related project materials is available here:

**https://github.com/puffconw/r-project-test**

# AI Use Disclosure

This document was developed with assistance from ChatGPT for code debugging, formatting, and preparation of the R Markdown structure. All analytical decisions, statistical interpretation, and final writing were reviewed and completed by the author.

# References

1. Agarwal N, Banternghansa C, Bui LTM. Toxic exposure in America: estimating fetal and infant health outcomes from 14 years of TRI reporting. *J Health Econ.* 2010;29(4):557-574.

2. Wilson SM, Fraser-Rahim H, Williams E, et al. Assessment of the distribution of toxic release inventory facilities in metropolitan Charleston: an environmental justice case study. *Am J Public Health.* 2012;102(10):1974-1980.

3. U.S. Environmental Protection Agency. Toxics Release Inventory (TRI) Program. Accessed April 10, 2026. https://www.epa.gov/toxics-release-inventory-tri-program
