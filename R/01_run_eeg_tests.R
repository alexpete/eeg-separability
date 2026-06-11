## This script performs the separability tests for the EEG data set in Section 4.3 of the paper

# Install testing package
library(ELRSepTests)

################################################################################
## EEG Data Analysis of Alcoholic Group
################################################################################

load('eeg_data_filtered_and_averaged.RData')

## Create Data Arrays
M1 <- dim(Xa)[2] # 64, number of channels
M2 <- dim(Xa)[3] # 256, number of time points
na <- dim(Xa)[1] # 77, number of subjects
tt <- seq(0, 1, length.out = M2) # regular grid from 0 to 1 sec

# center and standardize since data values are quite large
Xa <- (Xa - mean(Xa)) / sd(Xa)

## Get MBEs to check FVEs

MBEa <- getMBExp(Xa, tt2 = tt, useFVE = TRUE, FVEthres = 0.99)

MBEa$cumFVE$Dim1[1:20]
# [1] 0.4651175 0.7248496 0.8356629 0.8726310 0.8931152 0.9097371 0.9247707
# [8] 0.9376932 0.9467943 0.9522620 0.9567321 0.9605526 0.9640220 0.9673374
# [15] 0.9702172 0.9722859 0.9743391 0.9761128 0.9777526 0.9791927
MBEa$cumFVE$Dim2[1:20]
# [1] 0.2606265 0.4692990 0.6144873 0.7013018 0.7790411 0.8485150 0.8999718
# [8] 0.9316097 0.9573924 0.9725393 0.9844208 0.9902525 0.9947011 0.9966487
# [15] 0.9984818 0.9991047 0.9996339 0.9997930 0.9999242 0.9999654

## Set Test indices
JTestELRa <- JTestELRc <- rep(2L, 3L) # 70%, 80%
LTestELRa <- LTestELRc <- c(2L, 3L, 4L) # 45%, 60%, 70%

JTestWalda <- c(2L, 2L, 2L, 3L, 6L) # 70%, 80%, 90%
LTestWalda <- c(2L, 3L, 4L, 6L, 7L) # 45%, 60%, 70%, 80%, 90%

## Run Tests

B <- 500L
set.seed(80293)

# Alcoholic Wald Tests
WaldResa <- WaldSepTests(Xa, tt2 = tt, nullHyp = c('ParSep', 'WkSep', 'Sep'), 
                         JTest = JTestWalda, LTest = LTestWalda, B = B,
                         thin = FALSE)
WaldResaPSRev <- WaldSepTests(aperm(Xa, c(1, 3, 2)), tt1 = tt, nullHyp = 'ParSep',
                              JTest = LTestWalda, LTest = JTestWalda, B = B,
                              thin = FALSE)
bootPval <- rbind(WaldResaPSRev$bootPval, WaldResa$bootPval)
tStats <- rbind(WaldResaPSRev$tStats, WaldResa$tStats)
tStatsBoot <- c(WaldResaPSRev$tStatsBoot, WaldResa$tStatsBoot)

rownames(bootPval) <- rownames(tStats) <- names(tStatsBoot) <- c('ParSepSpace', 'ParSepTime', 'WkSep', 'Sep')
colnames(bootPval) <- colnames(tStats) <- colnames(WaldResa$bootPval)
WaldResa$bootPval <- bootPval
WaldResa$tStats <- tStats
WaldResa$tStatsBoot <- tStatsBoot
rm(WaldResaPSRev)

# Alcoholic ELR Tests
mnBoota <- c(floor(na^(0.95)), na)

ELRResa <- lapply(mnBoota, \(mn){
  val <- ELRSepTests(Xa, tt2 = tt, nullHyp = c('ParSep', 'WkSep', 'Sep'), 
                     JTest = JTestELRa, LTest = LTestELRa, B = B,
                     thin = FALSE, mnBoot = mn)
  valPSRev <- ELRSepTests(aperm(Xa, c(1, 3, 2)), tt1 = tt, JTest = JTestELRa, LTest = LTestELRa,
                          ELctrl = melt::el_control(maxit = 1000L, maxit_l = 1000L),
                          nullHyp = "ParSep", B = B, thin = FALSE,
                          mnBoot = mn)
  bootPval <- rbind(valPSRev$bootPval, val$bootPval)
  tStats <- rbind(valPSRev$tStats, val$tStats)
  tStatsBoot <- c(valPSRev$tStatsBoot, val$tStatsBoot)
  ELoptInfo <- c(valPSRev$ELoptInfo, val$ELoptInfo)
  
  rownames(bootPval) <- rownames(tStats) <- names(tStatsBoot) <- names(ELoptInfo) <- c('ParSepSpace', 'ParSepTime', 'WkSep', 'Sep')
  colnames(bootPval) <- colnames(tStats) <- colnames(val$bootPval)
  val$bootPval <- bootPval
  val$tStats <- tStats
  val$tStatsBoot <- tStatsBoot
  val$ELoptInfo <- ELoptInfo
  rm(valPSRev)
  return(val)
})

save(Xa, na, M1, M2, tt, mnBoota, JTestELRa, 
     LTestELRa, JTestWalda, LTestWalda, WaldResa, ELRResa,
     file = "EEGTestRes_AlcGrp.RData")