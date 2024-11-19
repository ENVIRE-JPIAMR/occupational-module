## Script to estimate the number of broilers processed per worker 

# Total number of broilers
n_broiler <-
  round(
    input_list_farm$farm_density / input_list_farm$target_weight * input_list_farm$farm_size
  )

# Thinning
occupational_output$broiler_worker.thinning <-
  round(n_broiler * occupational_output$Prev_farm * input_list_farm$thinning_percentage / occupational_output$n_farm)

# Clearing
occupational_output$broiler_worker.clearing <-
  round(n_broiler * occupational_output$Prev_farm / occupational_output$n_farm)

# Unloading
occupational_output$broiler_worker.unloading <-
  round(n_broiler * occupational_output$Prev_prod / (occupational_output$n_unloading * occupational_output$crate_size))

# Hanging
occupational_output$broiler_worker.hanging <-
  round(n_broiler * occupational_output$Prev_prod / occupational_output$n_hanging)

# Post-bleeding
occupational_output$broiler_worker.post_bleeding <-
  round(n_broiler * occupational_output$Prev_prod * occupational_output$eff.post_bleeding / occupational_output$n_post_bleeding)

# Post-defeathering
occupational_output$broiler_worker.post_df <-
  round(n_broiler * occupational_output$Prev_df * occupational_output$eff.post_df / occupational_output$n_post_df)

# Post-evisceration
occupational_output$broiler_worker.post_ev <-
  round(n_broiler * occupational_output$Prev_ev / occupational_output$n_post_ev)

# Portioning
occupational_output$broiler_worker.portioning <-
  round(n_broiler * occupational_output$Prev_proc / occupational_output$n_portioning)
