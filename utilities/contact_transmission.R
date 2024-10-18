## Function to estimate cummulative conc. after repeated touching
## Arguments: Cs_list := List of surface concentrations corr. to diff. simulations
##            n       := List of contacts with surface corr. to diff. simulations
##            t       := List of simulated transfer rates (in percentage)
## Generates a matrix (length(Cs_list) x max(n))
## Extra columns at the end of the rows with n < max(n) are filled with 0s

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
      Cw[i] <- Cw[i-1] + t[j] * (Cs * (1 - occupational_output$d[j]) * params_df$hand_surface - Cw[i-1]) / 100 # t in percentage
    }
    
    # Store the final Cw value in the list (adj. due to unequal row lengths)
    final_Cw_list[j, ] <- c(Cw, rep(0, max(n) - length(Cw)))
  }
  
  return(final_Cw_list)
}

## Function to extract final conc. from output matirx of function: compute_final_C_hand
## Arguments: A := The output matrix
##            k := Column indices to be extracted (argument n in compute_final_C_hand)
## Generates the final hand conc. corr. to diff. simulations

extract_elements <- function(A, k) {

  elements_list <- vector("list", length(k))
  
  # Loop through each row and extract the element at the specified column index
  for (i in seq_along(k)) {
    elements_list[[i]] <- A[i, k[i]]
  }
  
  return(unlist(elements_list))
}
