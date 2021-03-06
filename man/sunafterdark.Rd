% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sunafterdark.R
\name{sunafterdark}
\alias{sunafterdark}
\title{Maximum sunshine hours}
\usage{
sunafterdark(y, code = "991274")
}
\arguments{
\item{y}{ECA&D style two columns with date (yyyymmdd) and  values (expressed in 0.1 hours)}

\item{code}{"numeric" part of the ECA&D SOUID, expressed as character, to avoid trouble with leading zeroes}
}
\value{
vector with the list of positions which do not pass this test. If all positions pass the test, returns NULL
}
\description{
This function compares sunshine data to the maximum theoretical sunshine an ECA&D station, according the day, lat and lon.
Maximum sunshine hours are computed from the 'suncalc' package, using "night" and "dawn" parameters.
This contrasts quite a lot with other functions computing "daylength". This formulation is more conservative
}
\details{
depends on either a previous execution of listas() or on a proper execution of listas() to run properly
}
\seealso{
listas()
}
