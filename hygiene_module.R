# Script for computing lips conc. given biosecurity standards

## Funtion for computing bio-security constant for a given prob. of wearing mask
get_bio_seq_constant <- function(p_mask, p_wash, p_glove){

  constant <- (p_mask * p_glove * p_wash *
    params_df$q_mask * params_df$q_glove * params_df$q_wash +
    (1 - p_mask) * (1 - p_glove) * (1 - p_wash) +
    p_mask * p_glove * (1 - p_wash) *
    params_df$q_mask * params_df$q_glove +
    p_mask * (1 - p_glove) * p_wash * 
    params_df$q_mask * params_df$q_wash +
    (1 - p_mask) * p_glove * p_wash * 
    params_df$q_glove * params_df$q_wash +
    (1 - p_mask) * (1 - p_glove) * p_wash *
    params_df$q_wash +
    (1 - p_mask) * p_glove * (1 - p_wash) *
    params_df$q_glove +
    p_mask * (1 - p_glove) * (1 - p_wash) *
    params_df$q_mask) * 
    params_df$q_lips
  
  return(constant)
  
}

## Bio-security constant adjusted with male female ratio among workers 
if (mask == 'all'){
  if(wash == "TRUE"){
    if(glove == "TRUE"){
    bio_seq_constant <-
      get_bio_seq_constant(params_df$p_mask_male, params_df$p_wash, params_df$p_glove) * params_df$p_male +
      get_bio_seq_constant(params_df$p_mask_female, params_df$p_wash, params_df$p_glove) * (1 - params_df$p_male)
    }else{
      bio_seq_constant <-
        get_bio_seq_constant(params_df$p_mask_male, params_df$p_wash, glove) * params_df$p_male +
        get_bio_seq_constant(params_df$p_mask_female, params_df$p_wash, glove) * (1 - params_df$p_male)
    }
  }else{
    if(glove == "TRUE"){
    bio_seq_constant <-
      get_bio_seq_constant(params_df$p_mask_male, wash, params_df$p_glove) * params_df$p_male +
      get_bio_seq_constant(params_df$p_mask_female, wash, params_df$p_glove) * (1 - params_df$p_male)
    }else{
      bio_seq_constant <-
        get_bio_seq_constant(params_df$p_mask_male, wash, glove) * params_df$p_male +
        get_bio_seq_constant(params_df$p_mask_female, wash, glove) * (1 - params_df$p_male)
    }
  }
}else if(mask == "TRUE"){
  if(wash == "TRUE"){
    if(glove == "TRUE"){
      bio_seq_constant <-
        get_bio_seq_constant(params_df$p_mask_male, params_df$p_wash, params_df$p_glove)
    }else{
      bio_seq_constant <-
        get_bio_seq_constant(params_df$p_mask_male, params_df$p_wash, glove)
    }
  }else{
    if(glove == "TRUE"){
      bio_seq_constant <-
        get_bio_seq_constant(params_df$p_mask_male, wash, params_df$p_glove)
    }else{
      bio_seq_constant <-
        get_bio_seq_constant(params_df$p_mask_male, wash, glove)
    }
  }
}else if(mask == "FALSE"){
  if(wash == "TRUE"){
    if(glove == "TRUE"){
      bio_seq_constant <-
        get_bio_seq_constant(params_df$p_mask_female, params_df$p_wash, params_df$p_glove)
    }else{
      bio_seq_constant <-
        get_bio_seq_constant(params_df$p_mask_female, params_df$p_wash, glove)
    }
  }else{
    if(glove == "TRUE"){
      bio_seq_constant <-
        get_bio_seq_constant(params_df$p_mask_female, wash, params_df$p_glove)
    }else{
      bio_seq_constant <-
        get_bio_seq_constant(params_df$p_mask_female, wash, glove)
    }
  }
}

## Bio-security constant adjusted with finger tip area
bio_seq_constant <- bio_seq_constant * occupational_output$finger_surface

## Compute estimated conc. (CFU/finger contact area) on worker lips given accidental touch
occupational_output$C_lips.thinning <-
  bio_seq_constant * occupational_output$C_hand.thinning
occupational_output$C_lips.clearing <-
  bio_seq_constant * occupational_output$C_hand.clearing
occupational_output$C_lips.unloading <-
  bio_seq_constant * occupational_output$C_hand.unloading
occupational_output$C_lips.hanging <-
  bio_seq_constant * occupational_output$C_hand.hanging
occupational_output$C_lips.post_bleeding <-
  bio_seq_constant * occupational_output$C_hand.post_bleeding
occupational_output$C_lips.post_df <-
  bio_seq_constant * occupational_output$C_hand.post_df
occupational_output$C_lips.post_ev <-
  bio_seq_constant * occupational_output$C_hand.post_ev
occupational_output$C_lips.portioning <-
  bio_seq_constant * occupational_output$C_hand.portioning
