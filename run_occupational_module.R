# Run farm and food-borne module
source(here::here("foodborne-module/run_foodborne_module.R"))

farm_output <- parallel_output
foodborne_output <- output

rm(list = setdiff(ls(), c("farm_output", "foodborne_output", "input_list_farm")), envir = globalenv())

# Load input parameters
source(here::here("occupational-module/data-input/load_inputs.R"))
params_df <- load_inputs_occupational()

# Estimate variables
source(here::here("foodborne-module/utilities/estimate_variables.R"))
input_occ <- read_excel(here("occupational-module/data-input/estimated_variables.xlsx"))
foodborne_output <- estimate_variables(foodborne_output, input_occ, N=nrow(foodborne_output))

# Computation of broiler surface areas (cm2) (Meeh's formula) 
broiler_area <- params_df$k_meeh * params_df$weight**(2/3)

# Estimate concentrations (CFU/m2) and prevalences
# Thinning
foodborne_output$CFU_thinning <-
  farm_output[params_df$thinning_day, 1,] / (farm_output[params_df$thinning_day, 4,] + input_list_farm$farm_size * input_list_farm$litter_mass)
foodborne_output$CFU_thinning <-
  foodborne_output$CFU_thinning * foodborne_output$Amount_fec / broiler_area[params_df$thinning_day]
foodborne_output$Prev_thinning <-
  farm_output[params_df$thinning_day, 2,]

# Clearing
foodborne_output$CFU_clearing <-
  farm_output[params_df$clearing_day, 1,] / (farm_output[params_df$clearing_day, 4,] + input_list_farm$farm_size * input_list_farm$litter_mass)
foodborne_output$CFU_clearing <-
  foodborne_output$CFU_clearing * foodborne_output$Amount_fec / broiler_area[params_df$clearing_day]
foodborne_output$Prev_clearing <-
  farm_output[params_df$clearing_day, 2,]

# Hanging
foodborne_output$CFU_prod <- foodborne_output$C_prod / broiler_area[params_df$clearing_day]

# Eviseration
foodborne_output$CFU_ev <- foodborne_output$C_ev / broiler_area[params_df$clearing_day]

# Portioning
foodborne_output$CFU_por <- foodborne_output$C_proc / broiler_area[params_df$clearing_day]

