# Script to estimate contact transmission in worker hands

source(here::here("occupational-module/utilities/contact_transmission.R"))
source(here::here("occupational-module/utilities/broiler_worker_ratio.R"))

transmission.thinning <-
  compute_final_C_hand(
    occupational_output$C_cm2.thinning,
    occupational_output$broiler_worker.thinning,
    occupational_output$t_bird
  )

transmission.clearing <-
  compute_final_C_hand(
    occupational_output$C_cm2.clearing,
    occupational_output$broiler_worker.clearing,
    occupational_output$t_bird
  )

transmission.hanging <-
  compute_final_C_hand(
    occupational_output$C_cm2.hanging,
    occupational_output$broiler_worker.hanging,
    occupational_output$t_bird
  )

transmission.ev <-
  compute_final_C_hand(
    occupational_output$C_cm2.ev,
    occupational_output$broiler_worker.slaughter,
    occupational_output$t_meat
  )

transmission.por <-
  compute_final_C_hand(
    occupational_output$C_cm2.por,
    occupational_output$broiler_worker.slaughter,
    occupational_output$t_meat
  )

occupational_output$C_hand.thinning <-
  extract_elements(transmission.thinning,
                   occupational_output$broiler_worker.thinning) 

occupational_output$C_hand.clearing <-
  extract_elements(transmission.clearing,
                   occupational_output$broiler_worker.clearing)

occupational_output$C_hand.hanging <-
  extract_elements(transmission.hanging,
                   occupational_output$broiler_worker.hanging)

occupational_output$C_hand.ev <-
  extract_elements(transmission.ev,
                   occupational_output$broiler_worker.slaughter)

occupational_output$C_hand.por <-
  extract_elements(transmission.por,
                   occupational_output$broiler_worker.slaughter)

