# Script for risk estimation

# Adjusted bacteria load
occupational_output$C_lips.thinning <-
  ifelse(occupational_output$C_lips.thinning < 1,
         1,
         occupational_output$C_lips.thinning)
occupational_output$C_lips.clearing <-
  ifelse(occupational_output$C_lips.clearing < 1,
         1,
         occupational_output$C_lips.clearing)
occupational_output$C_lips.unloading <-
  ifelse(occupational_output$C_lips.unloading < 1,
         1,
         occupational_output$C_lips.unloading)
occupational_output$C_lips.hanging <-
  ifelse(occupational_output$C_lips.hanging < 1,
         1,
         occupational_output$C_lips.hanging)
occupational_output$C_lips.post_bleeding <-
  ifelse(
    occupational_output$C_lips.post_bleeding < 1,
    1,
    occupational_output$C_lips.post_bleeding
  )
occupational_output$C_lips.post_df <-
  ifelse(occupational_output$C_lips.post_df < 1,
         1,
         occupational_output$C_lips.post_df)
occupational_output$C_lips.post_ev <-
  ifelse(occupational_output$C_lips.post_ev < 1,
         1,
         occupational_output$C_lips.post_ev)
occupational_output$C_lips.portioning <-
  ifelse(
    occupational_output$C_lips.portioning < 1,
    1,
    occupational_output$C_lips.portioning
  )

# Risk characterization
occupational_output$prob_carrier.thinning <-
  1 - (1 + (occupational_output$C_lips.thinning / params_df$DR_omega)) ^ (-params_df$DR_alpha)
occupational_output$prob_carrier.clearing <-
  1 - (1 + (occupational_output$C_lips.clearing / params_df$DR_omega)) ^ (-params_df$DR_alpha)
occupational_output$prob_carrier.unloading <-
  1 - (1 + (occupational_output$C_lips.unloading / params_df$DR_omega)) ^ (-params_df$DR_alpha)
occupational_output$prob_carrier.hanging <-
  1 - (1 + (occupational_output$C_lips.hanging / params_df$DR_omega)) ^ (-params_df$DR_alpha)
occupational_output$prob_carrier.post_bleeding <-
  1 - (1 + (
    occupational_output$C_lips.post_bleeding / params_df$DR_omega
  )) ^ (-params_df$DR_alpha)
occupational_output$prob_carrier.post_df <-
  1 - (1 + (occupational_output$C_lips.post_df / params_df$DR_omega)) ^ (-params_df$DR_alpha)
occupational_output$prob_carrier.post_ev <-
  1 - (1 + (occupational_output$C_lips.post_ev / params_df$DR_omega)) ^ (-params_df$DR_alpha)
occupational_output$prob_carrier.portioning <-
  1 - (1 + (occupational_output$C_lips.portioning / params_df$DR_omega)) ^ (-params_df$DR_alpha)
