# to determine id, time, value, when coverting from data frame likes

# only print guessing messages once
msg_optional <- function(..., name){
  x <- paste0(...)
  message(x)
}

is_time <- function(x) {
  if (class(x)[1] %in% c("Date", "POSIXct")) return(TRUE) # beyond doubt
  # use a short vector for time detection
  if (length(x) > 20) {
    x <- c(
      x[1:3], # first 3
      x[(length(x) %/% 2 - 1):(length(x) %/% 2 + 1)], # middle 3
      x[(length(x) - 2):(length(x))]
    ) # lost 3
  }
  x <- as.character(x)
  all(!is.na(anytime(x)))
}

is_value <- function(x) {
  is.numeric(x) # also works for integer
  # class(x)[1] %in% c("numeric")
}

guess_time <- function(x, value.name = "value") {
  stopifnot(inherits(x, "data.frame"))
  cnames <- colnames(x)
  if ("time" %in% cnames) return("time")

  cnames <- setdiff(cnames, value.name)

  z <- NA
  # start from the right column
  for (cname.i in rev(cnames)) {
    if (is_time(x[[cname.i]])) {
      z <- cname.i
      break
    }
  }

  if (is.na(z)) {
    stop("No time column detected. To be explict, name time column as 'time'.")
  }

  z
}

guess_value <- function(x) {
  stopifnot(inherits(x, "data.frame"))
  cnames <- colnames(x)
  if ("value" %in% cnames) return("value")

  z <- NA
  for (cname.i in rev(cnames)) {
    if (is_value(x[[cname.i]])) {
      z <- cname.i
      break
    }
  }
  if (is.na(z)) {
    stop("No value column detected. To be explict, name value column as 'value'.")
  }
  z
}

guess_time_value <- function(x) {
  value.name <- guess_value(x)
  time.name <- guess_time(x, value.name = value.name)

  msg <- NULL
  if (time.name != "time") {
    msg <- paste0("[time]: '", time.name, "' ")
  }
  if (value.name != "value") {
    msg <- paste0(msg, "[value]: '", value.name, "' ")
    # check if data frame is incidentally wide
    cnames <- colnames(x)
    cols.right.of.time <- cnames[(which(cnames == time.name) + 1):length(cnames)]
    if (length(cols.right.of.time) > 1){
      value.cols <- vapply(x[, cols.right.of.time, with = FALSE], is_value, TRUE)
      if (sum(value.cols) > 1){
        message(
        "More than one value column detected after the time colum, using the outermost.\n",
        "Are you using a wide data frame? ",
        "To convert, use 'ts_long'.\n"
        )
      }
    }
  }

  msg_optional(msg)



  c(
    time.name = time.name,
    value.name = value.name
  )
}
