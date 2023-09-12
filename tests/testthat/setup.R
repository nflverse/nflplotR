# CRAN incoming checks can fail if tests use more than 2 cores.
# We can run in this problem by using data.table https://github.com/Rdatatable/data.table/issues/5658
# R CMD Check throws the NOTE because CRAN sets
# _R_CHECK_TEST_TIMING_CPU_TO_ELAPSED_THRESHOLD_ to "2.5"
# which means "more than two cores are running".
# We check for this specific environment variable and run the nflreadr helper
# if it is set to any value
cpu_threshold <- as.numeric(Sys.getenv("_R_CHECK_TEST_TIMING_CPU_TO_ELAPSED_THRESHOLD_",
                                       NA_character_))

if (!is.na(cpu_threshold)) nflreadr::.for_cran()
