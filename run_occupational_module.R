# Initialize farm and foodborne module
source(here::here("occupational-module/farm_to_fork_module.R"))

# Estimate bacteria tansmission from surface to worker hands
source(here::here("occupational-module/transmission_module.R"))

# Plot transmission
source(here::here("occupational-module/utilities/visualization.R"))

transmission_data <- list(
  thinning = transmission.thinning,
  clearing = transmission.clearing,
  hanging = transmission.hanging,
  ev = transmission.ev,
  por = transmission.por
)

sim_idx = c(1:nrow(occupational_output))[occupational_output$B_flock_status == "p"][1]
plot_bacteria_accumulation(sim_idx, transmission_data, occupational_output, params_df)

# Estimate avg. conc. on lips given conc. on hands
source(here::here("occupational-module/biosecurity_module.R"))

# Plot exposure ECDFs
plot_ecdfs(occupational_output[occupational_output$B_flock_status == "p", ])
plot_ecdfs(occupational_output)



