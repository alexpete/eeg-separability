# This script prints the Wald and ELR p-values in Table 1 of the paper

rm(list = ls())
load(file.path('results', 'EEGTestRes_AlcGrp.RData'))

# Print p-values

WaldResa$bootPval

ELRResa[[1]]$bootPval

ELRResa[[2]]$bootPval