## Limit datatable to two CPU cores for test purposes
# https://github.com/Rdatatable/data.table/issues/5658

current_threads <- data.table::getDTthreads()
data.table::setDTthreads(2)
testthat::teardown_env(data.table::setDTthreads(current_threads))
