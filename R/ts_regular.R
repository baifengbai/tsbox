#' Enforce Regularity
#' 
#' Enforces regularity in data frame and `xts` objects, by turning implicit
#' `NA`s into explicit `NA`s. In `ts` objects, regularity is automatically 
#' enfored.
#' 
#' @param x a ts-boxable time series
#' @examples
#' x0 <- AirPassengers
#' x0[c(10, 15)] <- NA
#' x <- ts_na_omit(ts_dts(x0))
#' ts_regular(x)
#' 
#' m <- mdeaths
#' m[c(10, 69)] <- NA
#' f <- fdeaths
#' f[c(1, 3, 15)] <- NA
#' 
#' ts_regular(ts_na_omit(ts_dts(ts_c(f, m))))
#' @export
ts_regular <- function(x){
  stopifnot(ts_boxable(x))
  z <- regular_core(ts_dts(x))
  copy_ts_class(z, x)
}

regular_core <- function(x){
  stopifnot(inherits(x, "dts"))
  ctime <- colname_time(x)
  cid <- colname_id(x)

  x <- copy(x)
  setnames(x, ctime, "time")

  is_regular <- function(x) {
    dd <- diff(as.numeric(x))
    max(dd) - min(dd) < 100
  }

  regular_core_one_series <- function(x){
    # to speed it up
    if (is_regular(x$time)) return(x)
    reg.date <- regularize_date(x$time)
    if (is.null(reg.date)) {
      stop("series does no show regular pattern and cannot be regularized", 
           call. = FALSE)
    }
    # if POSIXct and successful regularization, change to date, to join
    if (inherits(x$time, "POSIXct")){
      x$time = as.Date(x$time)
    }
    x[data.table(time = as.Date(reg.date)), on = "time"]
  }

  if (length(cid) == 0){
    z <- regular_core_one_series(x)
  } else {
    z <- x[, regular_core_one_series(.SD), by = cid]
  }
  setnames(z, "time", ctime)
  z[]
}