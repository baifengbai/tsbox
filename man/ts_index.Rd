% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ts_index.R
\name{ts_index}
\alias{ts_index}
\alias{ts_compound}
\alias{ts_index}
\title{Indices from Levels or Percentage Rates}
\usage{
ts_compound(x, denominator = 100)

ts_index(x, base)
}
\arguments{
\item{x}{ts-boxable time series, an object of class \code{ts}, \code{xts}, \code{data.frame}, \code{data.table}, or \code{tibble}.}

\item{denominator}{numeric, set equal to one if percentage change rate is given a
decimal fraction}

\item{base}{base date, character string, \code{Date} or \code{POSIXct}, at which the}
}
\value{
a ts-boxable time series, with the same class as the input.
}
\description{
\code{ts_index} returns an index series, with value of 1 at \code{base} date.
\code{ts_compound} builds an index from percentage change rates, starting with 1
and compounding the rates.
}
\examples{
head(ts_compound(ts_pc(ts_c(fdeaths, mdeaths))))
head(ts_index(ts_df(ts_c(fdeaths, mdeaths)), "1974-02-01"))
ts_plot(
  `My Expert Knowledge` = ts_chain(
    mdeaths, 
    ts_compound(ts_bind(ts_pc(mdeaths), 15, 23, 33))),
  `So Far` = mdeaths,
  title = "A Very Manual Forecast"
)
}
