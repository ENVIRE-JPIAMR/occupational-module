# Initialize farm and foodborne module
source(here::here("occupational-module/farm_to_fork_module.R"))

# Estimate bacteria tansmission from surface to worker hands
source(here::here("occupational-module/contact_module.R"))

# Plot transmission
source(here::here("occupational-module/utilities/visualization.R"))

transmission_data <- list(
  thinning = transmission.thinning,
  clearing = transmission.clearing,
  unloading = transmission.unloading,
  hanging = transmission.hanging,
  post_bleeding = transmission.post_bleeding,
  post_df = transmission.post_ev,
  post_ev = transmission.post_ev,
  portioning = transmission.portioning
)

sim_idx = c(1:nrow(occupational_output))[occupational_output$B_flock_status == "p"][1]
plot_bacteria_accumulation(sim_idx, transmission_data, occupational_output, params_df)

# Estimate avg. conc. on lips given conc. on hands
mask = "all" # "all" for male(masked) and female(non masked). Otherwise use "TRUE"/"FALSE"
wash = "TRUE" # or manual p_wash values
glove = "TRUE" # or manual p_glove values
source(here::here("occupational-module/hygiene_module.R"))

# Plot exposure ECDFs
# plot_ecdfs(occupational_output[occupational_output$B_flock_status == "p", ])
plot_ecdfs(occupational_output)

# Estimate risk
source("occupational-module/risk_module.R")
# Calculate the average risks for each stage
avg_risk_thinning <- format(mean(occupational_output$prob_carrier.thinning), digits = 2, scientific = TRUE)
avg_risk_clearing <- format(mean(occupational_output$prob_carrier.clearing), digits = 2, scientific = TRUE)
avg_risk_unloading <- format(mean(occupational_output$prob_carrier.unloading), digits = 2, scientific = TRUE)
avg_risk_hanging <- format(mean(occupational_output$prob_carrier.hanging), digits = 2, scientific = TRUE)
avg_risk_post_bleeding <- format(mean(occupational_output$prob_carrier.post_bleeding), digits = 2, scientific = TRUE)
avg_risk_post_df <- format(mean(occupational_output$prob_carrier.post_df), digits = 2, scientific = TRUE)
avg_risk_post_ev <- format(mean(occupational_output$prob_carrier.post_ev), digits = 2, scientific = TRUE)
avg_risk_portioning <- format(mean(occupational_output$prob_carrier.portioning), digits = 2, scientific = TRUE)

# Create a data frame for tabular output
risk_table <- data.frame(
  Stage = c("Thinning", "Clearing", "Unloading", "Hanging", "Post Bleeding", "Post Defeathering", "Post Evisceration", "Portioning"),
  Average_Risk = c(avg_risk_thinning, avg_risk_clearing, avg_risk_unloading, avg_risk_hanging, avg_risk_post_bleeding, avg_risk_post_df, avg_risk_post_ev, avg_risk_portioning)
)

# Print the table
print(risk_table)

# Plot variables
plot_variable(occupational_output, plot_all = FALSE, flock = TRUE, variable = "lips")
plot_variable(occupational_output, plot_all = FALSE, flock = TRUE, variable = "hand")
plot_variable(occupational_output, plot_all = FALSE, flock = TRUE, variable = "surface")
plot_box(occupational_output)

# Micro-level appraoch - Number of cases
R_avg_foodborne <- 3.3e-5
N_micro_foodborne <- (n_broiler * 0.25) * 1 / 1.5
T_foodborne <- R_avg_foodborne * N_micro_foodborne

N_micro_thinning <- round(mean(occupational_output$n_farm))
N_micro_clearing <- round(mean(occupational_output$n_farm))
N_micro_unloading <- round(mean(occupational_output$n_unloading))
N_micro_hanging <- round(mean(occupational_output$n_hanging))
N_micro_post_bleeding <- round(mean(occupational_output$n_post_bleeding))
N_micro_post_df <- round(mean(occupational_output$n_post_df))
N_micro_post_ev <- round(mean(occupational_output$n_post_ev))
N_micro_portioning <- round(mean(occupational_output$n_portioning))
  


