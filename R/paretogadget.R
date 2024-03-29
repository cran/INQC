paretogadget<-function(x,ret){

  #' Finds outliers
  #' @description This function finds outliers for variables which can be described/evaluated by means of 
  #' the Pareto distribution (e.g. atmospheric precipitation or wind speed)
  #' @param x vector of values (a series) to be analyzed
  #' @param ret pseudo-return period for the pot-pareto distribution approach
  #' @return list of positions which do not pass this QC test (which can be considered as outliers)
  #' @examples
  #' #Extract the ECA&D precipitation data file from the example data folder
  #' path2inptfl<-system.file("extdata", "RR_SOUID132730.txt", package = "INQC")
  #' #Read the data file
  #' x<-readecad(input=path2inptfl,missing= -9999)[,4]
  #' #Find all suspicious positions in the time series corresponding to the requested return period
  #' paretogadget(x,25)
  #' #Suspicious values
  #' x[paretogadget(x,25)]
  #' @export

  # Auxiliated by potpareto, returnpotpareto, computecal
  target<-NULL
  nyu<-potpareto(x)
  if(is.null(nyu)){
    return(NULL)
  }
  mus<-returnpotpareto(nyu,ret)
  target<-which(x > mus)
  return(target)
}