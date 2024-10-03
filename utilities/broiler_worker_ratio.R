## Script to estimate the number of broilers processed per worker 

# Total number of broilers
n_broiler <-
  round(
    input_list_farm$farm_density / input_list_farm$target_weight * input_list_farm$farm_size
  )

# Thinning
occupational_output$broiler_worker.thinning <-
  round(n_broiler * input_list_farm$thinning_percentage / occupational_output$n_farm)

# Clearing
occupational_output$broiler_worker.clearing <-
  round(n_broiler / occupational_output$n_farm)

# Hanging
occupational_output$broiler_worker.hanging <-
  round(n_broiler / occupational_output$n_hanging)

# Slaughter (evisceration + portioning)
occupational_output$broiler_worker.slaughter <-
  round(n_broiler / occupational_output$n_slaughter)
