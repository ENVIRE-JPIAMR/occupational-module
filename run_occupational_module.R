# Run farm and food-borne module
source(here::here("foodborne-module/run_foodborne_module.R"))

farm_output <- parallel_output
foodborne_output <- output

# Create new dataframe for storing outputs
occupational_output <- foodborne_output[, c("Runs", "B_flock_status", "init_prev", "Prev_prod", "Prev_ev", "Prev_proc")]
names(occupational_output)[names(occupational_output) == "init_prev"] <- "Prev_farm"

rm(list = setdiff(ls(), c("farm_output", "foodborne_output", "input_list_farm", "occupational_output")), envir = globalenv())

# Load input parameters
source(here::here("occupational-module/load_inputs.R"))
params_df <- load_inputs_occupational()

# Estimate variables
source(here::here("foodborne-module/utilities/estimate_variables.R"))
input_occ <- read_excel(here("occupational-module/data-input/estimated_variables.xlsx"))
occupational_output <- estimate_variables(occupational_output, input_occ, N=nrow(occupational_output))

# Computation of broiler surface areas (cm2) (Meeh's formula) 
broiler_area <- params_df$k_meeh * params_df$weight**(2/3)

# Number of broilers
n_broiler <- round(input_list_farm$farm_density/input_list_farm$target_weight*input_list_farm$farm_size)

# Estimate concentrations (CFU/cm2) and prevalences
# Thinning
occupational_output$C_cm2.thinning <-
  farm_output[params_df$thinning_day, 1,] / (farm_output[params_df$thinning_day, 4,] + input_list_farm$farm_size * input_list_farm$litter_mass)
occupational_output$C_cm2.thinning <-
  occupational_output$C_cm2.thinning * foodborne_output$Amount_fec / broiler_area[params_df$thinning_day]

# Clearing
occupational_output$C_cm2.clearing <-
  farm_output[params_df$clearing_day, 1,] / (farm_output[params_df$clearing_day, 4,] + input_list_farm$farm_size * input_list_farm$litter_mass)
occupational_output$C_cm2.clearing <-
  occupational_output$C_cm2.clearing * foodborne_output$Amount_fec / broiler_area[params_df$clearing_day]

# Hanging
occupational_output$C_cm2.prod <- foodborne_output$C_prod / broiler_area[params_df$clearing_day]

# Eviseration
occupational_output$C_cm2.ev <- foodborne_output$C_ev / broiler_area[params_df$clearing_day]

# Portioning
occupational_output$C_cm2.por <- foodborne_output$C_proc / broiler_area[params_df$clearing_day]

# Estimate the number of broilers processed per worker 
occupational_output$broiler_worker.thinning <- round(n_broiler * input_list_farm$thinning_percentage/occupational_output$n_farm)
occupational_output$broiler_worker.clearing <- round(n_broiler/occupational_output$n_farm)
occupational_output$broiler_worker.hanging <- round(n_broiler/occupational_output$n_hanging)
occupational_output$broiler_worker.slaughter <- round(n_broiler/occupational_output$n_slaughter)

# Estimate concentrations on hand
source(here::here("occupational-module/utilities/transmission_model.R"))

transmission.thinning <-
  compute_final_C_hand(
    occupational_output$C_cm2.thinning,
    occupational_output$broiler_worker.thinning,
    occupational_output$t_bird
  )

transmission.clearing <-
  compute_final_C_hand(
    occupational_output$C_cm2.clearing,
    occupational_output$broiler_worker.clearing,
    occupational_output$t_bird
  )

transmission.hanging <-
  compute_final_C_hand(
    occupational_output$C_cm2.prod,
    occupational_output$broiler_worker.hanging,
    occupational_output$t_bird
  )

transmission.ev <-
  compute_final_C_hand(
    occupational_output$C_cm2.ev,
    occupational_output$broiler_worker.slaughter,
    occupational_output$t_meat
  )

transmission.por <-
  compute_final_C_hand(
    occupational_output$C_cm2.por,
    occupational_output$broiler_worker.slaughter,
    occupational_output$t_meat
  )


occupational_output$C_hand.thinning <-
  extract_elements(transmission.thinning,
                   occupational_output$broiler_worker.thinning) 

occupational_output$C_hand.clearing <-
  extract_elements(transmission.clearing,
                   occupational_output$broiler_worker.clearing)

occupational_output$C_hand.hanging <-
  extract_elements(transmission.hanging,
                   occupational_output$broiler_worker.hanging)

occupational_output$C_hand.ev <-
  extract_elements(transmission.ev,
                   occupational_output$broiler_worker.slaughter)

occupational_output$C_hand.por <-
  extract_elements(transmission.por,
                   occupational_output$broiler_worker.slaughter)

plot(transmission.thinning[1,], ylab = "ESBL E. coli", main = "thinning")
plot(transmission.clearing[1,], ylab = "ESBL E. coli", main = "clearing")
plot(transmission.hanging[1,], ylab = "ESBL E. coli", main = "hanging")
plot(transmission.ev[1,], ylab = "ESBL E. coli", main = "evisceration")
plot(transmission.por[1,], ylab = "ESBL E. coli", main = "portioning")




