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
    surface_conc <- occupational_output[[paste0("C_cm2.", stage)]][sim_idx]
    
    plot(
      transmission_stage[transmission_stage > 0],
      xlab = "number of contacts",
      ylab = "hand conc. (CFU/cm2)",
      main = title,
      sub = paste0(
        "surface conc.: ",
        format(surface_conc, scientific = TRUE, digits = 2),
        " (simulation:", sim_idx, ", flocks size: ", n_broiler, ")"
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
      subtitle = paste0("flocks size: ", n_broiler, " with ", length(occupational_output$Runs), " MC runs"),
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

# Plot variables over different stages
# Arguments: data     := output df of the occupational module
#            plot_all := if TRUE, plots individual simulations
#                        else, plots mean, median and empirical CIs
#            flock    := if True, distinguishes positive and negative plots
#            variable := variable name among (lips, hand, surface, ratio)
plot_variable <- function(data, plot_all = TRUE, flock = TRUE, variable) {
  
  if(variable == "lips"){
    myprefix <- "C_lips."
    mytitle <- "Bacteria exposure on a worker's lips over production stages"
    mylabel <- "log10 CFU"
  }else if(variable == "hand"){
    myprefix <- "C_hand."
    mytitle <- "Bacteria exposure on a worker's hands over production stages"
    mylabel <- "log10 CFU/cm2"
  }else if(variable == "surface"){
    myprefix <- "C_cm2."
    mytitle <- "Bacteria exposure on broiler/carcasses over production stages"
    mylabel <- "log10 CFU/cm2"
  }else if(variable == "ratio"){
    myprefix <- "broiler_worker."
    mytitle <- "Broiler processed per worker over production stages"
    mylabel <- "contacts"
  }
  
  # Extract the order of steps based on the original dataframe columns
  steps_order <- sub(myprefix, "", names(data)[grepl(paste0("^", myprefix), names(data))])
  
  data_long <- data %>%
    pivot_longer(cols = starts_with(myprefix), names_to = "variable", values_to = "value") %>%
    mutate(step = factor(sub(myprefix, "", variable), levels = steps_order))
  
  if (flock) {
    data_long <- data_long %>%
      mutate(flock_status = ifelse(B_flock_status == "p", "positive", "negative"),
             color = ifelse(B_flock_status == "p", "red", "blue"))
  } else {
    data_long <- data_long %>%
      mutate(flock_status = "all",
             color = "black")
  }
  
  if (plot_all) {
    gg <- ggplot(data = data_long, aes(x = step, y = log10(value), color = color, group = Runs)) +
      labs(title = mytitle,
           subtitle = paste0("flocks size: ", n_broiler, " with ", length(data$Runs), " MC runs"),
           x = "Stages",
           y = mylabel) +
      theme_minimal() +
      geom_line() +
      geom_point() +
      scale_color_manual(values = c("red" = "red", "blue" = "blue"), labels = c("red" = paste0("positive (", round(mean(foodborne_output$prev), 2)*100, "%)"), "blue" = paste0("negative (", (1-round(mean(foodborne_output$prev), 2))*100, "%)")), name = "Flock Status")
    
  } else {
    # Calculate summary statistics for plotting
    if (flock) {
      summary_data <- data_long %>%
        group_by(step, color, flock_status) %>%
        summarize(
          mean_value = log10(mean(value, na.rm = TRUE)),
          median_value = log10(median(value, na.rm = TRUE)),
          lower_ci = log10(quantile(value, 0.025, na.rm = TRUE)),
          upper_ci = log10(quantile(value, 0.975, na.rm = TRUE)),
          .groups = 'drop'
        )
    } else {
      summary_data <- data_long %>%
        group_by(step) %>%
        summarize(
          mean_value = log10(mean(value, na.rm = TRUE)),
          median_value = log10(median(value, na.rm = TRUE)),
          lower_ci = log10(quantile(value, 0.025, na.rm = TRUE)),
          upper_ci = log10(quantile(value, 0.975, na.rm = TRUE)),
          .groups = 'drop'
        ) %>%
        mutate(color = "black", flock_status = "all")
    }
    
    # Create the plot
    gg <- ggplot(data = summary_data, aes(x = step, group = color, color = color)) +
      geom_line(aes(y = mean_value, linetype = "Mean"), size = 1) +
      geom_line(aes(y = median_value, linetype = "Median"), size = 1) +
      geom_ribbon(aes(ymin = lower_ci, ymax = upper_ci, fill = color), alpha = 0.3) +  # Confidence bands
      labs(title = mytitle,
           subtitle = paste0("flocks size: ", n_broiler, " with ", length(data$Runs), " MC runs"),
           x = "Stages",
           y = mylabel) +
      scale_linetype_manual(values = c("Mean" = "solid", "Median" = "dotted"), name = "Statistic")
    
    if (flock) {
      gg <- gg + 
        scale_color_manual(values = c("red" = "red", "blue" = "blue"), name = "Flock Status",
                           labels = c("red" = paste0("positive (", round(mean(foodborne_output$prev), 2)*100, "%)"), "blue" = paste0("negative (", (1-round(mean(foodborne_output$prev), 2))*100, "%)"))) +
        scale_fill_manual(values = c("red" = "red", "blue" = "blue"), guide = "none")
    } else {
      gg <- gg + 
        scale_color_manual(values = c("black" = "black"), name = "Flock Status",
                           labels = c("black" = "all")) +
        scale_fill_manual(values = c("black" = "black"), guide = "none")
    }
    
    gg <- gg + theme_minimal() +
      theme(legend.title = element_text(size = 12),  # Set legend title
            legend.text = element_text(size = 12)) +
      guides(linetype = guide_legend(title = "Statistic"),
             color = guide_legend(override.aes = list(linetype = "solid")))  # Ensure color legend shows solid line
  }
  
  return(gg)
}

# Boxplot boilers per worker contacts over different stages
# Arguments: data     := output df of the occupational module
#            plot_all := if TRUE, plots individual simulations
#                        else, plots mean, median and empirical CIs
#            flock    := if True, distinguishes positive and negative plots
plot_box <- function(data) {
  
  myprefix <- "broiler_worker."
  mytitle <- "Broiler processed per worker over production stages"
  mylabel <- "contacts"
  
  # Extract the order of steps based on the original dataframe columns
  steps_order <- sub(myprefix, "", names(data)[grepl(paste0("^", myprefix), names(data))])
  
  data_long <- data %>%
    pivot_longer(cols = starts_with(myprefix), names_to = "variable", values_to = "value") %>%
    mutate(step = factor(sub(myprefix, "", variable), levels = steps_order))
  
  gg <- ggplot(data = data_long, aes(x = step, y = value)) +
    labs(title = mytitle,
         subtitle = paste0("flocks size: ", n_broiler, " with ", length(data$Runs), " MC runs"),
         x = "Stages",
         y = mylabel) +
    theme_minimal() +
    geom_boxplot() 
  
  return(gg)
}
