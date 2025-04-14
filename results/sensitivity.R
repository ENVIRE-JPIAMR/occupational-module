## Script for sensitivity analysis

# There are two sets of input parameters in the occupational model
# 1. estimated inputs: inputs parameters with defined uncertainlty
# 2. fixed inputs: inputs parameters with unknown uncertainlty
# The sensitivity analysis was performed only on the uncertain input parameters. 
# Along with the estimated inputs, the outputs of the foodborne modules that 
# serves as the starting concentrations, are used for sensitivity analysis

# There are several outputs of the occupational module and sensitivity 
# analysis was done on each of them separately w.r.t their corresponding
# uncertain input parameters.

# Simulation

source(here::here("occupational-module/farm_to_fork_module.R"))
source(here::here("occupational-module/contact_module.R"))
mask = "all" 
wash = "TRUE"
glove = "TRUE" 
source(here::here("occupational-module/hygiene_module.R"))

sa_input <- occupational_output %>% select(t_bird, t_board, t_meat, d, n_farm, n_hanging, 
                                           n_post_ev, n_portioning, finger_surface,
                                           eff.post_bleeding, eff.post_df, crate_size)

sa_output <- occupational_output %>% select(C_lips.thinning, C_lips.clearing, C_lips.unloading,
                                           C_lips.hanging, C_lips.post_bleeding, C_lips.post_df,
                                           C_lips.post_ev, C_lips.portioning)

foodborne_columns <- foodborne_output %>% select(C_proc, Prev_proc, Prev_home_cook)

# Filtering the non zero variance columns 
data_filtered <- data[, sapply(data, function(col) is.numeric(col) && var(col, na.rm = TRUE) > 0)]
data_filtered <- data_filtered[, !names(data_filtered) %in% "Runs"]
data_filtered <- data_filtered %>% select(1:36)

# Combining all inputs and outputs
sa_input <- bind_cols(sa_input, data_filtered)
sa_output <- bind_cols(sa_output, foodborne_columns)

# Function to make tornado plot
make_tornade_plot <- function(output_idx){

  correlations <- sa_input %>%
    summarise(
      across(everything(), ~ cor(.x, sa_output[[output_idx]], method = "spearman", use = "complete.obs"))
    ) %>%
    pivot_longer(cols = everything(), 
                 names_to = "Input", 
                 values_to = "Spearman_Rank_Correlation")
  
  # View the result 
  correlations_sorted <- data.frame(correlations) %>% arrange(Spearman_Rank_Correlation)
  
  ggplot(tail(correlations_sorted, 10), aes(x = Spearman_Rank_Correlation, y = reorder(Input, Spearman_Rank_Correlation))) +
    geom_bar(stat = "identity", fill = "skyblue", color = "black") +
    labs(
      title = paste("Rank Correlation with -", colnames(sa_output)[output_idx]),
      x = "Spearman's Rank Correlation",
      y = "Input Variables"
    ) +
    theme_minimal() +
    theme(axis.text.y = element_text(size = 8)) +
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(axis.text.x = element_text(size = 10)) +
    theme(axis.title.x = element_text(size = 12)) +
    theme(axis.title.y = element_text(size = 12)) 

}

make_tornade_plot(9)
