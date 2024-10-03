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
                       "Prev_ev",
                       "Prev_proc")]
names(occupational_output)[names(occupational_output) == "init_prev"] <-
  "Prev_farm"

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

# Clearing
occupational_output$C_cm2.clearing <-
  farm_output[params_df$clearing_day, 1, ] / (farm_output[params_df$clearing_day, 4, ] + input_list_farm$farm_size * input_list_farm$litter_mass)
occupational_output$C_cm2.clearing <-
  occupational_output$C_cm2.clearing * foodborne_output$Amount_fec / broiler_area[params_df$clearing_day]

# Hanging
occupational_output$C_cm2.hanging <-
  foodborne_output$C_prod / broiler_area[params_df$clearing_day]

# Eviseration
occupational_output$C_cm2.ev <-
  foodborne_output$C_ev / broiler_area[params_df$clearing_day]

# Portioning
occupational_output$C_cm2.por <-
  foodborne_output$C_proc / broiler_area[params_df$clearing_day]
