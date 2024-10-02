## Function for loading input variables from csv list

load_inputs_occupational <- function(input_manual = list()) {
  
  ## read input variables
  df_read <- read_xlsx("occupational-module/data-input/inputs.xlsx")
  
  ## parsing objects from input list
  input_objects = list(
    weight              = eval(parse(text = df_read$Value[df_read$Variable == "weight"]))
  )
  
  ## parsing non-objects from input list
  idx_double <- df_read$Type != "OBJECT"
  df_double <-
    data.frame(id = df_read$Variable[idx_double],
               val = unlist(lapply(df_read$Value[idx_double], function(x)
                 eval(parse(
                   text = x
                 )))))
  
  named_vector <- with(df_double, setNames(val, id))
  input_doubles <- lapply(split(named_vector, names(named_vector)), unname)
  
  input_list <- c(input_objects, input_doubles) 
  
  # update the input list with manual inputs
  input_list <- modifyList(input_list, input_manual)
  
  return(input_list)
}

