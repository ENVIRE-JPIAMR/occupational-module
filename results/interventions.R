## Script for scenario analysis

####################
## Effect of mask ##
####################

# Initialization
source(here::here("occupational-module/farm_to_fork_module.R"))
source(here::here("occupational-module/transmission_module.R"))

# Effect of masks
mask = "TRUE"
wash = 0
glove = 0
source(here::here("occupational-module/biosecurity_module.R"))

C_lips.thinning.mask <- occupational_output$C_lips.thinning
C_lips.clearing.mask <- occupational_output$C_lips.clearing
C_lips.unloading.mask <- occupational_output$C_lips.unloading
C_lips.hanging.mask <- occupational_output$C_lips.hanging
C_lips.post_bleeding.mask <- occupational_output$C_lips.post_bleeding
C_lips.post_df.mask <- occupational_output$C_lips.post_df
C_lips.post_ev.mask <- occupational_output$C_lips.post_ev
C_lips.portioning.mask <- occupational_output$C_lips.portioning

# Effect of washing
mask = "FALSE"
wash = "TRUE"
glove = 0
source(here::here("occupational-module/biosecurity_module.R"))

C_lips.thinning.wash <- occupational_output$C_lips.thinning
C_lips.clearing.wash <- occupational_output$C_lips.clearing
C_lips.unloading.wash <- occupational_output$C_lips.unloading
C_lips.hanging.wash <- occupational_output$C_lips.hanging
C_lips.post_bleeding.wash <- occupational_output$C_lips.post_bleeding
C_lips.post_df.wash <- occupational_output$C_lips.post_df
C_lips.post_ev.wash <- occupational_output$C_lips.post_ev
C_lips.portioning.wash <- occupational_output$C_lips.portioning

# Effect of gloves
mask = "FALSE"
wash = 0
glove = "TRUE"
source(here::here("occupational-module/biosecurity_module.R"))

C_lips.thinning.glove <- occupational_output$C_lips.thinning
C_lips.clearing.glove <- occupational_output$C_lips.clearing
C_lips.unloading.glove <- occupational_output$C_lips.unloading
C_lips.hanging.glove <- occupational_output$C_lips.hanging
C_lips.post_bleeding.glove <- occupational_output$C_lips.post_bleeding
C_lips.post_df.glove <- occupational_output$C_lips.post_df
C_lips.post_ev.glove <- occupational_output$C_lips.post_ev
C_lips.portioning.glove <- occupational_output$C_lips.portioning

# No intervention baseline
mask = "FALSE"
wash = 0
glove = 0
source(here::here("occupational-module/biosecurity_module.R"))

C_lips.thinning.baseline <- occupational_output$C_lips.thinning
C_lips.clearing.baseline <- occupational_output$C_lips.clearing
C_lips.unloading.baseline <- occupational_output$C_lips.unloading
C_lips.hanging.baseline <- occupational_output$C_lips.hanging
C_lips.post_bleeding.baseline <- occupational_output$C_lips.post_bleeding
C_lips.post_df.baseline <- occupational_output$C_lips.post_df
C_lips.post_ev.baseline <- occupational_output$C_lips.post_ev
C_lips.portioning.baseline <- occupational_output$C_lips.portioning

# All interventions
mask = "TRUE"
wash = "TRUE"
glove = "TRUE"
source(here::here("occupational-module/biosecurity_module.R"))

C_lips.thinning.all <- occupational_output$C_lips.thinning
C_lips.clearing.all <- occupational_output$C_lips.clearing
C_lips.unloading.all <- occupational_output$C_lips.unloading
C_lips.hanging.all <- occupational_output$C_lips.hanging
C_lips.post_bleeding.all <- occupational_output$C_lips.post_bleeding
C_lips.post_df.all <- occupational_output$C_lips.post_df
C_lips.post_ev.all <- occupational_output$C_lips.post_ev
C_lips.portioning.all <- occupational_output$C_lips.portioning

# Plot separately
data <- data.frame(
  thinning.mask = log10(C_lips.thinning.mask),
  clearing.mask = log10(C_lips.clearing.mask),
  unloading.mask = log10(C_lips.unloading.mask),
  hanging.mask = log10(C_lips.hanging.mask),
  post_bleeding.mask = log10(C_lips.post_bleeding.mask),
  post_df.mask = log10(C_lips.post_df.mask),
  post_ev.mask = log10(C_lips.post_ev.mask),
  portioning.mask = log10(C_lips.portioning.mask),
  thinning.wash = log10(C_lips.thinning.wash),
  clearing.wash = log10(C_lips.clearing.wash),
  unloading.wash = log10(C_lips.unloading.wash),
  hanging.wash = log10(C_lips.hanging.wash),
  post_bleeding.wash = log10(C_lips.post_bleeding.wash),
  post_df.wash = log10(C_lips.post_df.wash),
  post_ev.wash = log10(C_lips.post_ev.wash),
  portioning.wash = log10(C_lips.portioning.wash),
  thinning.glove = log10(C_lips.thinning.glove),
  clearing.glove = log10(C_lips.clearing.glove),
  unloading.glove = log10(C_lips.unloading.glove),
  hanging.glove = log10(C_lips.hanging.glove),
  post_bleeding.glove = log10(C_lips.post_bleeding.glove),
  post_df.glove = log10(C_lips.post_df.glove),
  post_ev.glove = log10(C_lips.post_ev.glove),
  portioning.glove = log10(C_lips.portioning.glove),
  thinning.baseline = log10(C_lips.thinning.baseline),
  clearing.baseline = log10(C_lips.clearing.baseline),
  unloading.baseline = log10(C_lips.unloading.baseline),
  hanging.baseline = log10(C_lips.hanging.baseline),
  post_bleeding.baseline = log10(C_lips.post_bleeding.baseline),
  post_df.baseline = log10(C_lips.post_df.baseline),
  post_ev.baseline = log10(C_lips.post_ev.baseline),
  portioning.baseline = log10(C_lips.portioning.baseline)
)

# Reshape the data to long format
data_long <- data %>%
  pivot_longer(cols = everything(), names_to = c("step", "intervention"), names_sep = "\\.") %>%
  mutate(step = factor(step, levels = c("thinning", "clearing", "unloading", "hanging", "post_bleeding", "post_df", "post_ev", "portioning")),
         intervention = factor(intervention, levels = c("mask", "wash", "glove", "baseline")))

# Create the boxplots
ggplot(data_long, aes(x = step, y = value, fill = intervention)) +
  geom_boxplot(position = position_dodge(0.8)) +
  labs(title = "Exposure relative to biosecurity practices over different steps",
       # subtitle = "Females (no mask) and Males (with masks)",
       x = "Steps",
       y = "log10 CFU") +
  theme_minimal() +
  scale_fill_manual(values = c("mask" = "blue", "wash" = "pink", "glove" = "green", "baseline" = "red"))

# Plot selected
data_select <- data.frame(
  thinning.all = log10(C_lips.thinning.all),
  clearing.all = log10(C_lips.clearing.all),
  unloading.all = log10(C_lips.unloading.all),
  hanging.all = log10(C_lips.hanging.all),
  post_bleeding.all = log10(C_lips.post_bleeding.all),
  post_df.all = log10(C_lips.post_df.all),
  post_ev.all = log10(C_lips.post_ev.all),
  portioning.all = log10(C_lips.portioning.all),
  thinning.baseline = log10(C_lips.thinning.baseline),
  clearing.baseline = log10(C_lips.clearing.baseline),
  unloading.baseline = log10(C_lips.unloading.baseline),
  hanging.baseline = log10(C_lips.hanging.baseline),
  post_bleeding.baseline = log10(C_lips.post_bleeding.baseline),
  post_df.baseline = log10(C_lips.post_df.baseline),
  post_ev.baseline = log10(C_lips.post_ev.baseline),
  portioning.baseline = log10(C_lips.portioning.baseline)
)

# Reshape the data to long format
data_long <- data_select %>%
  pivot_longer(cols = everything(), names_to = c("step", "intervention"), names_sep = "\\.") %>%
  mutate(step = factor(step, levels = c("thinning", "clearing", "unloading", "hanging", "post_bleeding", "post_df", "post_ev", "portioning")),
         intervention = factor(intervention, levels = c("all", "baseline")))

# Create the boxplots
ggplot(data_long, aes(x = step, y = value, fill = intervention)) +
  geom_boxplot(position = position_dodge(0.8)) +
  labs(title = "Exposure relative to biosecurity practices over different steps",
       x = "Steps",
       y = "log10 CFU") +
  theme_minimal() +
  scale_fill_manual(values = c("all" = "green", "baseline" = "red"))


