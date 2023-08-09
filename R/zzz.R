# nocov start
.onLoad <- function(libname,pkgname){

  memoise_option <- getOption("nflplotR.cache", default = "memory")

  if(!memoise_option %in% c("memory", "filesystem", "off")) memoise_option <- "memory"

  if(memoise_option == "filesystem"){
    cache_dir <- rappdirs::user_cache_dir(appname = "nflplotR")
    dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)
    cache <- cachem::cache_disk(dir = cache_dir)
  }

  if(memoise_option == "memory") cache <- cachem::cache_mem()

  if(memoise_option != "off"){
    assign(x = "reader_function",
           value = memoise::memoise(reader_function, ~ memoise::timeout(86400), cache = cache),
           envir = parent.env(environment()))
  }

  # CRAN incoming checks can fail if examples use more than 2 cores.
  # We can run in this problem by using data.table https://github.com/Rdatatable/data.table/issues/5658
  # R CMD Check throws the NOTE because CRAN sets
  # _R_CHECK_EXAMPLE_TIMING_CPU_TO_ELAPSED_THRESHOLD_ to "2.5"
  # which means "more than two cores are running".
  # We check for this specific environment variable and run the nflreadr helper
  # if it is set to any value
  cpu_threshold <- as.numeric(Sys.getenv("_R_CHECK_EXAMPLE_TIMING_CPU_TO_ELAPSED_THRESHOLD_",
                                         NA_character_))

  if (!is.na(cpu_threshold)) nflreadr::.for_cran()
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
