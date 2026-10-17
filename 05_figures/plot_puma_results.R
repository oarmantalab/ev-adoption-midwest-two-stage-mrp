# =============================================================================
# plot_puma_results.R
# -----------------------------------------------------------------------------
# FIGURES - PUMA-level fleet-forecast figures from the Stage-2 model.
#
#   * Box plots of adoption share across PUMAs for each vehicle type (paper Fig. 8)
#   * Heatmap of the 15 highest and 15 lowest PUMAs for each vehicle type
#     (paper Fig. 9)
#
# Input   : outputs/tables/puma_fleet_shares.csv   (written by run_sce_model.R;
#                                                   columns: State, PUMS,
#                                                   SG, SE, LG, LE, PG, PE)
# Output  : outputs/figures/fig_boxplot.png
#           outputs/figures/fig_heatmap.png
#
# Run     : Rscript 05_figures/plot_puma_results.R
# =============================================================================

library(here)
source(here::here("config.R"))

library(dplyr)
library(tidyr)
library(ggplot2)
library(patchwork)
library(viridis)

## ---- Load PUMA-level shares -------------------------------------------------
data <- read.csv(file.path(DIR_TABLES, "puma_fleet_shares.csv"))

vehicle_vars  <- c("SG", "SE", "LG", "LE", "PG", "PE")
vehicle_names <- c(SG = "Small Gas",  SE = "Small BEV",
                   LG = "Large Gas",  LE = "Large BEV",
                   PG = "Pickup Truck Gas", PE = "Pickup Truck BEV")

## ===========================================================================
## Figure 8 - Box plots of adoption share by vehicle type (percent)
## ===========================================================================
boxplot_data <- data %>%
  select(all_of(vehicle_vars)) %>%
  pivot_longer(everything(), names_to = "type", values_to = "value") %>%
  mutate(value = value * 100,
         type  = factor(vehicle_names[type], levels = unname(vehicle_names)))

p_box <- ggplot(boxplot_data, aes(x = type, y = value)) +
  geom_boxplot(fill = "gray") +
  ylim(0, 100) +
  labs(x = "Vehicle Type", y = "Adoption share (%)") +
  theme_bw() +
  theme(panel.grid = element_blank())

ggsave(file.path(DIR_FIGURES, "fig_boxplot.png"), p_box,
       width = 8, height = 6, dpi = 300)

## ===========================================================================
## Figure 9 - Heatmap of the 15 highest / 15 lowest PUMAs per vehicle type
## ===========================================================================
# One horizontal strip per vehicle type; a black line separates the 15 lowest
# (left) from the 15 highest (right) PUMAs. Shares are shown as percentages.
fill_scale <- scale_fill_viridis_c(option = "magma", direction = -1, limits = c(0, 100))

make_strip <- function(df, variable) {
  df <- df %>%
    mutate(value = .data[[variable]] * 100) %>%
    arrange(value) %>%
    mutate(PUMS = factor(PUMS, levels = PUMS))
  subset_df <- rbind(head(df, 15), tail(df, 15))

  ggplot(subset_df, aes(x = PUMS, y = 1, fill = value)) +
    geom_tile() +
    fill_scale +
    geom_vline(xintercept = 15.5, color = "black", linewidth = 1) +
    labs(y = vehicle_names[[variable]],
         x = if (variable == "PE") "PUMA" else NULL) +
    theme_minimal() +
    theme(axis.text.x  = element_text(size = 7, angle = 90, vjust = 0.5, hjust = 1),
          axis.title.y = element_text(size = 10, angle = 0, vjust = 0.5),
          axis.text.y  = element_blank(),
          axis.ticks.y = element_blank(),
          panel.grid   = element_blank(),
          legend.position = "none")
}

strips <- lapply(vehicle_vars, function(v) make_strip(data, v))

heatmap <- wrap_plots(strips, ncol = 1) +
  plot_layout(guides = "collect") &
  theme(legend.position = "bottom") &
  guides(fill = guide_colorbar(title = "Percent", direction = "horizontal",
                               breaks = seq(0, 100, 20)))

ggsave(file.path(DIR_FIGURES, "fig_heatmap.png"), heatmap,
       width = 9, height = 7, dpi = 300)
