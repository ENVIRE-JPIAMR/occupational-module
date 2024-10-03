# Initialize farm and foodborne module
source(here::here("occupational-module/farm_to_fork_module.R"))
source(here::here("occupational-module/transmission_module.R"))

# Plot transmission

plot(transmission.thinning[1,], ylab = "ESBL E. coli", main = "thinning")
plot(transmission.clearing[1,], ylab = "ESBL E. coli", main = "clearing")
plot(transmission.hanging[1,], ylab = "ESBL E. coli", main = "hanging")
plot(transmission.ev[1,], ylab = "ESBL E. coli", main = "evisceration")
plot(transmission.por[1,], ylab = "ESBL E. coli", main = "portioning")




