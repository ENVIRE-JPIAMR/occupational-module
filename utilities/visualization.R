# Script for visualization

# Plot hand conc. over number of contacts, for different stages
plot_bacteria_accumulation <- function(sim_idx, transmission_data, occupational_output, params_df) {
  stages <- c("thinning", "clearing", "unloading", "hanging", "post_bleeding", "post_df", "post_ev", "portioning")
  titles <- c("Bacteria accumulation: thinning", 
              "Bacteria accumulation: clearing", 
              "Bacteria accumulation: unloading", 
              "Bacteria accumulation: hanging", 
              "Bacteria accumulation: post bleeding", 
              "Bacteria accumulation: post defeathering", 
              "Bacteria accumulation: post evisceration", 
              "Bacteria accumulation: portioning")
  
  for (i in seq_along(stages)) {
    stage <- stages[i]
    title <- titles[i]
    transmission_stage <- transmission_data[[stage]][sim_idx, ]
    surface_conc <- occupational_output[[paste0("C_cm2.", stage)]][sim_idx] * params_df$hand_surface
    
    plot(
      transmission_stage[transmission_stage > 0],
      xlab = "number of contacts",
      ylab = "hand conc. (CFU)",
      main = title,
      sub = paste0(
        "surface conc.: ",
        format(surface_conc, scientific = TRUE, digits = 2),
        " (simulation:", sim_idx, ")"
      )
    )
  }
}

# Plot ECDFs of final exposure to workers
plot_ecdfs <- function(occupational_output) {
  # Create a new dataframe with log10 values and a 'pathway' column
  data_long <- data.frame(value = c(
    log10(occupational_output$C_lips.thinning),
    log10(occupational_output$C_lips.clearing),
    log10(occupational_output$C_lips.unloading),
    log10(occupational_output$C_lips.hanging),
    log10(occupational_output$C_lips.post_bleeding),
    log10(occupational_output$C_lips.post_df),
    log10(occupational_output$C_lips.post_ev),
    log10(occupational_output$C_lips.portioning)
  ),
  pathway = rep(c("thinning", "clearing", "unloading", "hanging", "post_bleeding", "post_df", "post_ev", "portioning"), each = nrow(occupational_output)))
  
  # Plot the ECDFs
  ggplot(data_long, aes(x = value, color = pathway)) +
    stat_ecdf(geom = "step") +
    labs(
      title = "ECDF of different stages exposure dose",
      x = "log10(CFU)",
      y = "ECDF",
      color = "pathway"
    ) +
    scale_color_manual(values = c(
      "thinning" = "blue",
      "clearing" = "green",
      "unloading" = "yellow",
      "hanging" = "red",
      "post_bleeding" = "purple", 
      "post_df" = "pink", 
      "post_ev" = "brown",
      "portioning" = "orange"
    )) +
    theme_minimal()
}