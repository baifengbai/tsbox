# A blueprint for new functions? If possible, functions should work on dts, not
# on other objects. Faster and keeps time stamp intact.

#' Normalized Time Series
#' 
#' Subtract mean and divide by standard deviation. Based on [base::scale()].
#'
#' @param x ts_boxable time series
#' @param center logical
#' @param scale logical
#' @export
#' @examples
#' ts_plot(ts_scale((ts_c(airmiles, co2, JohnsonJohnson, discoveries))))
#' ts_plot(ts_scale(ts_c(AirPassengers, DAX = EuStockMarkets[, 'DAX'])))
ts_scale <- function (x, center = TRUE, scale = TRUE){
  value <- NULL
  z <- ts_dts(x)

  colname.id <- colname_id(z)
  colname.value <- colname_value(z)
  setnames(z, colname.value, "value")

  scale_core <- function(value) {
    z <- scale(value, center = center, scale = scale)
    attr(z, "scaled:center") <- NULL
    attr(z, "scaled:scale") <- NULL
    z
  }

  .by <- parse(text = paste0("list(", paste(colname.id, collapse = ", "), ")"))
  z[
    ,
    value := scale_core(value),
    by = eval(.by)
  ]
  setnames(z, "value", colname.value)
  ts_na_omit(copy_class(z, x))
}
