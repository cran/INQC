% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/returnpotpareto.R
\name{returnpotpareto}
\alias{returnpotpareto}
\title{Threshold percentile for the Pareto outliers}
\usage{
returnpotpareto(pato, ret, w = 1.65)
}
\arguments{
\item{pato}{list with results of modelling/fitting the generalized Pareto distribution}

\item{ret}{pseudo-return period}

\item{w}{parameter to equate to return period to a temporal interval (recall the approach is not
block maxima but peak over threshold. Typical value of w to equate the return period to years is 1.65
(See Wilks, 2011. Statistical Analysis for the Atmospheric Sciences)}
}
\value{
for a given pareto distribution, returns the value representing a requested return period
}
\description{
This function returns a value of a threshold percentile for the Pareto outliers
}
