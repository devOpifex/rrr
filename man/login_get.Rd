% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/login.R
\name{login_get}
\alias{login_get}
\title{GET Login}
\usage{
login_get(req, res)
}
\arguments{
\item{req}{A `Request`.}

\item{res}{A `Response`.}
}
\description{
Returns login page response, unless the user
is already authenticated in which case we redirect
to profile.
}
\keyword{internal}
