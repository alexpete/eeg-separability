# This script prints the Wald and ELR p-values in Table 1 of the paper

rm(list = ls())
load(file.path('results', 'EEGTestRes_AlcGrp.RData'))

# Print p-values

round(WaldResa$bootPval, 3)

round(ELRResa[[1]]$bootPval, 3)

round(ELRResa[[2]]$bootPval, 3)