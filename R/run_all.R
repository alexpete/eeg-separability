# Run all EEG replication steps from the repository root.
# This script may take substantial time because it runs B = 500 bootstrap samples.

source(file.path("R", "01_run_eeg_tests.R"))
source(file.path("R", "02_print_table1_pvalues.R"))
