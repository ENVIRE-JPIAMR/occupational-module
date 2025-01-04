# Script to estimate contact transmission in worker hands

source(here::here("occupational-module/utilities/contact_transmission.R"))
source(here::here("occupational-module/utilities/broiler_worker_ratio.R"))

# Thinning
transmission.thinning <-
  compute_final_C_hand(
    occupational_output$C_cm2.thinning,
    occupational_output$broiler_worker.thinning,
    occupational_output$t_bird
  )

## Extracting final concentrations 
occupational_output$C_hand.thinning <-
  extract_elements(transmission.thinning,
                   occupational_output$broiler_worker.thinning) 
# Clearing
transmission.clearing <-
  compute_final_C_hand(
    occupational_output$C_cm2.clearing,
    occupational_output$broiler_worker.clearing,
    occupational_output$t_bird
  )

## Extracting final concentrations 
occupational_output$C_hand.clearing <-
  extract_elements(transmission.clearing,
                   occupational_output$broiler_worker.clearing)

# Unloading 
transmission.unloading <-
  compute_final_C_hand(
    occupational_output$C_cm2.unloading, 
    occupational_output$broiler_worker.unloading,
    occupational_output$t_board
  )

## Extracting final concentrations 
occupational_output$C_hand.unloading <-
  extract_elements(transmission.unloading,
                   occupational_output$broiler_worker.unloading)

# Hanging
transmission.hanging <-
  compute_final_C_hand(
    occupational_output$C_cm2.hanging,
    occupational_output$broiler_worker.hanging,
    occupational_output$t_bird
  )

## Extracting final concentrations 
occupational_output$C_hand.hanging <-
  extract_elements(transmission.hanging,
                   occupational_output$broiler_worker.hanging)

# Post-bleeding
transmission.post_bleeding <-
  compute_final_C_hand(
    occupational_output$C_cm2.post_bleeding, 
    occupational_output$broiler_worker.post_bleeding,
    occupational_output$t_bird
  )

## Extracting final concentrations 
occupational_output$C_hand.post_bleeding <-
  extract_elements(transmission.post_bleeding,
                   occupational_output$broiler_worker.post_bleeding)

# Post-defeathering
transmission.post_df <-
  compute_final_C_hand(
    occupational_output$C_cm2.post_df,
    occupational_output$broiler_worker.post_df,
    occupational_output$t_meat
  )

## Extracting final concentrations 
occupational_output$C_hand.post_df <-
  extract_elements(transmission.post_df,
                   occupational_output$broiler_worker.post_df)

# Post-evisceration
transmission.post_ev <-
  compute_final_C_hand(
    occupational_output$C_cm2.post_ev,
    occupational_output$broiler_worker.post_ev,
    occupational_output$t_meat
  )

## Extracting final concentrations 
occupational_output$C_hand.post_ev <-
  extract_elements(transmission.post_ev,
                   occupational_output$broiler_worker.post_ev)

# Portioning
transmission.portioning <-
  compute_final_C_hand(
    occupational_output$C_cm2.portioning,
    occupational_output$broiler_worker.portioning,
    occupational_output$t_meat
  )

## Extracting final concentrations 
occupational_output$C_hand.portioning <-
  extract_elements(transmission.portioning,
                   occupational_output$broiler_worker.portioning)

