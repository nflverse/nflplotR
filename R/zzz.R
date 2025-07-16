# nocov start
.onLoad <- function(libname,pkgname){

  S7::methods_register()

  memoise_option <- getOption("nflplotR.cache", default = "memory")

  if(!memoise_option %in% c("memory", "filesystem", "off")) memoise_option <- "memory"

  if(memoise_option == "filesystem"){
    cache_dir <- R_user_dir("nflplotR", "cache")
    if (!dir.exists(cache_dir)) dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)
    cache <- cachem::cache_disk(dir = cache_dir)
  }

  if(memoise_option == "memory") cache <- cachem::cache_mem()

  if(memoise_option != "off"){
    assign(x = "reader_function",
           value = memoise::memoise(reader_function, ~ memoise::timeout(86400), cache = cache),
           envir = parent.env(environment()))
  }

  # CRAN incoming checks can fail if examples or tests use more than 2 cores.
  # We can run in this problem by using data.table https://github.com/Rdatatable/data.table/issues/5658
  # R CMD Check throws the NOTE because CRAN sets
  # _R_CHECK_TEST_TIMING_CPU_TO_ELAPSED_THRESHOLD_ and/or
  # _R_CHECK_EXAMPLE_TIMING_CPU_TO_ELAPSED_THRESHOLD_to "2.5"
  # (EDIT: They probably use different ones in R DEVEL)
  # which means "more than two cores are running".
  # We check for these environment variables and if we find them
  # we set data.table to two threads
  # nflplotR depends on magick which also uses OMP but doesn't respect
  # OMP_THREAD_LIMIT. I have to skip the related tests unfortunately.
  cpu_check <- suppressWarnings(stats::na.omit(as.numeric(c(
      Sys.getenv("_R_CHECK_EXAMPLE_TIMING_CPU_TO_ELAPSED_THRESHOLD_", unset = 0),
      Sys.getenv("_R_CHECK_TEST_TIMING_CPU_TO_ELAPSED_THRESHOLD_", unset = 0)
    ))))

  if (any(cpu_check != 0)) {
    cores <- suppressWarnings(min(
      floor(as.integer(Sys.getenv("_R_CHECK_EXAMPLE_TIMING_CPU_TO_ELAPSED_THRESHOLD_"))),
      floor(as.integer(Sys.getenv("_R_CHECK_TEST_TIMING_CPU_TO_ELAPSED_THRESHOLD_"))),
      2L,
      na.rm = TRUE
    ))
    Sys.setenv("OMP_THREAD_LIMIT" = cores)
    # see https://stat.ethz.ch/pipermail/r-package-devel/2023q4/009969.html
    Sys.setenv("OMP_NUM_THREADS" = cores)
    data.table::setDTthreads(cores)
  }
}

.onAttach <- function(libname, pkgname){

  # validate nflplotR.cache
  memoise_option <- getOption("nflplotR.cache",default = "memory")

  if (!memoise_option %in% c("memory", "filesystem", "off")) {
    packageStartupMessage('Note: nflplotR.cache is set to "',
                          memoise_option,
                          '" and should be one of c("memory","filesystem", "off"). \n',
                          'Defaulting to "memory".')
    memoise_option <- "memory"
  }
  if(memoise_option == "off") packageStartupMessage('Note: nflplotR.cache is set to "off"')
}

# nocov end
