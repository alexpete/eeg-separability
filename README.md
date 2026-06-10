# EEG Analysis Replication Materials

This repository contains replication materials for the EEG data illustration in Section 4.3 / Table 1 of the manuscript **Empirical Likelihood Ratio Tests for Nested Covariance Separability Structures in Two-Way Data**.

The analysis uses the EEG database from the UCI Machine Learning Repository:

<https://archive.ics.uci.edu/dataset/121/eeg+database>

The file in `data/` is the alpha-band filtered and subject-averaged data described in the manuscript. The raw EEG recordings are publicly available at the UCI link above. The filtering/preprocessing step is not part of the proposed methodology; the scripts here reproduce the numerical EEG results starting from the preprocessed data used in the paper.

## Repository structure

```text
data/
  eeg_data_filtered_and_averaged.RData   # preprocessed EEG data used in the paper

R/
  01_run_eeg_tests.R                     # runs Wald and ELR separability tests
  02_print_table1_pvalues.R              # prints the p-values reported in Table 1
  run_all.R                              # runs both scripts in sequence

results/
  .gitkeep                               # output directory; results are written here
```

Running `R/01_run_eeg_tests.R` creates

```text
results/EEGTestRes_AlcGrp.RData
```

which is then read by `R/02_print_table1_pvalues.R`.

## Requirements

The scripts were written for R and require the following R packages:

```r
install.packages("melt")
# Install ELRSepTests from its repository or local source, as described in the manuscript.
# Example, if available from GitHub:
# remotes::install_github("alexpete/ELRSepTests")
```

The package `ELRSepTests` must be installed before running the scripts.

## Reproducing the EEG results

Clone the repository, open R with the repository root as the working directory, and run:

```r
source(file.path("R", "run_all.R"))
```

Alternatively, run the scripts individually:

```r
source(file.path("R", "01_run_eeg_tests.R"))
source(file.path("R", "02_print_table1_pvalues.R"))
```

The first script uses `set.seed(80293)` and `B = 500` bootstrap samples, matching the manuscript analysis. Depending on the machine, this step may take substantial time.

## Data provenance

The original raw EEG data are from the UCI Machine Learning Repository EEG database. The object `data/eeg_data_filtered_and_averaged.RData` contains the alpha-wave-filtered, averaged data used for the manuscript's EEG illustration. Please cite the UCI dataset and the original EEG data source when reusing these materials.

## Expected output

The Table 1 p-values are printed by `R/02_print_table1_pvalues.R` as:

```r
WaldResa$bootPval
ELRResa[[1]]$bootPval
ELRResa[[2]]$bootPval
```

These correspond to the Wald test p-values and the two ELR calibrations stored in the saved result object.
