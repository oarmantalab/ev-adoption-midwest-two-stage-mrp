# =============================================================================
# plot_state_shares.R
# -----------------------------------------------------------------------------
# FIGURES - Stacked bar chart of vehicle-type shares by state (paper Fig. 11).
#
# Aggregates the PUMA-level fleet forecast to the state level (population-
# weighted beforehand) and shows the share of each of the six vehicle types per
# state. Running it on the baseline, +incentive, and -charging-time scenario
# tables reproduces panels A, B and C of Fig. 11.
#
# Input   : outputs/tables/state_shares.csv   (columns: State, Small Gas,
#                                              Small BEV, Large Gas, Large BEV,
#                                              Pickup Truck Gas, Pickup Truck BEV;
#                                              values are fractions in [0, 1])
# Output  : outputs/figures/fig_state_shares.png
#
# Run     : Rscript 05_figures/plot_state_shares.R
# =============================================================================

library(here)
source(here::here("config.R"))

library(dplyr)
library(tidyr)
library(ggplot2)

## ---- Load state-level shares ------------------------------------------------
data <- read.csv(file.path(DIR_TABLES, "state_shares.csv"), check.names = FALSE)

vehicle_levels <- c("Small Gas", "Small BEV", "Large Gas", "Large BEV",
                    "Pickup Truck Gas", "Pickup Truck BEV")

df_long <- data %>%
  pivot_longer(-State, names_to = "vehicle_type", values_to = "percentage") %>%
  mutate(State        = factor(State),
         vehicle_type = factor(vehicle_type, levels = vehicle_levels),
         percentage   = percentage * 100)

## ---- Colour palette (matches the paper) ------------------------------------
colors <- c("Small Gas"        = "black",
            "Small BEV"        = "#DF536B",
            "Large Gas"        = "#61D04F",
            "Large BEV"        = "#2297E6",
            "Pickup Truck Gas" = "#28E2E5",
            "Pickup Truck BEV" = "#CD0BBC")

## ---- Stacked bar with in-bar percentage labels -----------------------------
p <- ggplot(df_long, aes(x = State, y = percentage, fill = vehicle_type)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = sprintf("%.1f", percentage)),
            position = position_stack(vjust = 0.5), size = 3, color = "white") +
  scale_fill_manual(values = colors) +
  labs(x = "State", y = "Vehicle Type Percentage", fill = "Choice") +
  theme_minimal()

ggsave(file.path(DIR_FIGURES, "fig_state_shares.png"), p,
       width = 9, height = 6, dpi = 300)
