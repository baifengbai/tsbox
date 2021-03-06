% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/date_utils.R
\name{time_shift}
\alias{time_shift}
\alias{time_shift}
\alias{first_time_of_month}
\alias{time_shift}
\alias{first_time_of_quarter}
\alias{time_shift}
\alias{first_time_of_year}
\title{Manipulating Dates}
\usage{
time_shift(x, by = NULL)

first_time_of_month(x)

first_time_of_quarter(x)

first_time_of_year(x)
}
\arguments{
\item{x}{\code{Date} or \code{POSIXct}. If \code{POSIXct}, it is converted into \code{Date}.}

\item{by}{integer or character, either the number of shifting periods
(integer), or an absolute amount of time (character). See details.}
}
\value{
an object of class \code{Date}
}
\description{
\code{time_shift} adds seconds, minutes, hours, days, weeks, months, quarters or years to dates.
\code{first_time_of_month}, \code{first_time_of_quarter} and \code{first_time_of_yeae} return the first day of the
period and are useful for customized aggregation of data frames. For standard
aggregation, use \code{\link[=ts_frequency]{ts_frequency()}}.
}
\details{
If \code{by} is character, the time stamp is shifted by a specific amount of time.
This can be one of one of \code{"sec"}, \code{"min"}, \code{"hour"}, \code{"day"}, \code{"week"},
\code{"month"}, \code{"quarter" or}"year", optionally preceded by a (positive or
negative) integer and a space, or followed by plural "s". This is passed to
\code{\link[base:seq.Date]{base::seq.Date()}}. This does not require the series to be regular.
}
\examples{
ap.time <- ts_df(AirPassengers)$time
head(first_time_of_month(ap.time))
head(first_time_of_quarter(ap.time))
head(first_time_of_year(ap.time))

head(time_shift(ap.time, 14))
head(time_shift(ap.time, "7 week"))
head(time_shift(ap.time, "-1 month"))

time_shift(ts_end(mdeaths), 1)
time_shift(ts_end(mdeaths), "-14 sec")
time_shift(ts_end(mdeaths), "-1 year")
ts_window(ts_c(mdeaths, fdeaths), start = time_shift(ts_end(mdeaths), -1))

}
\seealso{
\code{\link[=ts_frequency]{ts_frequency()}} for standard aggregation. \code{\link[=time_shift]{time_shift()}}, for
shifting time stamps of a ts-boxable object.
}
