# Script for computing lips conc. given biosecurity standards

bio_seq_constant <-
  params_df$p_mask * params_df$p_glove * params_df$p_wash *
  params_df$q_mask * params_df$q_glove * params_df$q_wash +
  (1 - params_df$p_mask) * (1 - params_df$p_glove) * (1 - params_df$p_wash) +
  params_df$p_mask * params_df$p_glove * (1 - params_df$p_wash) *
  params_df$q_mask * params_df$q_glove +
  params_df$p_mask * (1 - params_df$p_glove) * params_df$p_wash * 
  params_df$q_mask * params_df$q_wash +
  (1 - params_df$p_mask) * params_df$p_glove * params_df$p_wash * 
  params_df$q_glove * params_df$q_wash +
  (1 - params_df$p_mask) * (1 - params_df$p_glove) * params_df$p_wash *
  params_df$q_wash +
  (1 - params_df$p_mask) * params_df$p_glove * (1 - params_df$p_wash) *
  params_df$q_glove +
  params_df$p_mask * (1 - params_df$p_glove) * (1 - params_df$p_wash) *
  params_df$q_mask * 
  params_df$q_lips

occupational_output$C_lips.thinning <- bio_seq_constant * occupational_output$C_cm2.thinning
occupational_output$C_lips.clearing <- bio_seq_constant * occupational_output$C_cm2.clearing
occupational_output$C_lips.hanging <- bio_seq_constant * occupational_output$C_cm2.hanging
occupational_output$C_lips.ev <- bio_seq_constant * occupational_output$C_cm2.ev
occupational_output$C_lips.por <- bio_seq_constant * occupational_output$C_cm2.por
