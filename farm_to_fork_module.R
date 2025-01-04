# Script to initialize farm and foodborne module

####################
## Initialization ##
####################

source(here::here("foodborne-module/run_foodborne_module.R"))

farm_output <- parallel_output
foodborne_output <- output

# Create new dataframe for storing outputs
occupational_output <-
  foodborne_output[, c("Runs",
                       "B_flock_status",
                       "init_prev",
                       "Prev_prod",
                       "Prev_df",
                       "Prev_ev",
                       "Prev_proc")]
names(occupational_output)[names(occupational_output) == "init_prev"] <-
  "Prev_clearing"

rm(list = setdiff(
  ls(),
  c(
    "farm_output",
    "foodborne_output",
    "input_list_farm",
    "occupational_output"
  )
), envir = globalenv())

# Load input parameters
source(here::here("occupational-module/utilities/load_inputs.R"))
params_df <- load_inputs_occupational()

# Load estimated variables
source(here::here("foodborne-module/utilities/estimate_variables.R"))
input_occ <-
  read_excel(here("occupational-module/data-input/estimated_variables.xlsx"))
occupational_output <-
  estimate_variables(occupational_output, input_occ, N = nrow(occupational_output))

# Extracting the flock prevalence on thinning day
occupational_output$Prev_thinning <- farm_output[params_df$thinning_day, 2, ]
occupational_output$Prev_thinning <- ifelse(occupational_output$B_flock_status == "p",
                                            occupational_output$Prev_thinning,
                                            0)

#######################################################
## Estimate concentrations (CFU/cm2) and prevalences ##
#######################################################

# Computation of broiler surface area (cm2) over 36 days (Meeh's formula)
broiler_area <- params_df$k_meeh * params_df$weight ** (2 / 3)

# Thinning
occupational_output$C_cm2.thinning <-
  farm_output[params_df$thinning_day, 1, ] / (farm_output[params_df$thinning_day, 4, ] + input_list_farm$farm_size * input_list_farm$litter_mass)
occupational_output$C_cm2.thinning <-
  occupational_output$C_cm2.thinning * foodborne_output$Amount_fec / broiler_area[params_df$thinning_day]

occupational_output$C_cm2.thinning <- ifelse(occupational_output$B_flock_status == "p",
                                             occupational_output$C_cm2.thinning,
                                             0)

# Clearing
occupational_output$C_cm2.clearing <-
  farm_output[params_df$clearing_day, 1, ] / (farm_output[params_df$clearing_day, 4, ] + input_list_farm$farm_size * input_list_farm$litter_mass)
occupational_output$C_cm2.clearing <-
  occupational_output$C_cm2.clearing * foodborne_output$Amount_fec / broiler_area[params_df$clearing_day]

occupational_output$C_cm2.clearing <- ifelse(occupational_output$B_flock_status == "p",
                                             occupational_output$C_cm2.clearing,
                                             0)
# Unloading
occupational_output$C_cm2.unloading <-
  foodborne_output$C_prod / broiler_area[params_df$clearing_day]

# Hanging
occupational_output$C_cm2.hanging <- occupational_output$C_cm2.unloading #crate surface conc. is same as exterior conc. of broilers after transport
  
# Post-bleeding
occupational_output$C_cm2.post_bleeding <- occupational_output$C_cm2.unloading #broiler ext. conc. remains unchanged
  
# Post-defeathering
occupational_output$C_cm2.post_df <-
  foodborne_output$C_df / broiler_area[params_df$clearing_day]

# Post-eviseration
occupational_output$C_cm2.post_ev <-
  foodborne_output$C_ev / broiler_area[params_df$clearing_day]

# Portioning
occupational_output$C_cm2.portioning <-
  foodborne_output$C_proc / broiler_area[params_df$clearing_day]
