## Function to estimate cummulative conc. after repeated touching

compute_final_C_hand <- function(Cs_list, n, t) {

  Cw0 <- 0  # Initial concentration
  
  # Initialize the list to store final Cw values
  final_Cw_list <- matrix(nrow = length(Cs_list), ncol = max(n))
  
  # Loop through each Cs value
  for (j in seq_along(Cs_list)) {
    Cs <- Cs_list[j]
    
    # Initialize the vector to store Cw values for the current Cs
    Cw <- numeric(n[j])
    Cw[1] <- Cw0
    
    # Loop to calculate Cw values
    for (i in 2:n[j]) {
      Cw[i] <- Cw[i-1] + t[j] * (Cs * params_df$hand_surface - Cw[i-1]) / 100 # t in percentage
    }
    
    # Store the final Cw value in the list (adj. due to unequal row lengths)
    final_Cw_list[j, ] <- c(Cw, rep(0, max(n) - length(Cw)))
  }
  
  return(final_Cw_list)
}

# Funtion to extract final conc. from matirx

extract_elements <- function(A, k) {

  elements_list <- vector("list", length(k))
  
  # Loop through each row and extract the element at the specified column index
  for (i in seq_along(k)) {
    elements_list[[i]] <- A[i, k[i]]
  }
  
  return(elements_list)
}
