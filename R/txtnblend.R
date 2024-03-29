txtnblend<-function(y,id){

  #' Comparison of tx an tn data (for "blended" ECA&D data)
  #' @description This function first looks for the closest station and then merges both data frames.
  #' If one value is flagged, looks at the ecdfs of tx and tn. If the target variable (e.g tx) is central
  #' (between quantiles 0.2 and 0.8) and the other variable (e.g. tn) is outside this range, the value is
  #' not flagged, assuming the other variable is the culprit
  #' @param y two columns with date and data
  #' @param id name of a file ("xx_STAIDxxxxxx.txt", blended) we are working with
  #' @return list of positions which do not pass this QC test. If all positions pass the test, returns NULL
  #' @examples
  #' #Set a temporal working directory:
  #' wd <- tempdir(); wd0 <- setwd(wd)
  #' #Create subdirectory where raw data files have to be located
  #' dir.create(file.path(wd, "raw"))
  #' #Extract the blended ECA&D data and station files from the example data folder
  #' path2list<-system.file("extdata", "stations.txt", package = "INQC")
  #' list<-readr::read_lines_raw(path2list)
  #' readr::write_lines(list,file=paste(wd,"/raw/stations.txt",sep=""))
  #' path2txdata<-system.file("extdata", "TX_STAID000002.txt", package = "INQC")
  #' txdata<-readr::read_lines_raw(path2txdata)
  #' readr::write_lines(txdata, file=paste(wd,"/raw/TX_STAID000002.txt",sep=""))
  #' path2tndata<-system.file("extdata", "TN_STAID000002.txt", package = "INQC")
  #' tndata<-readr::read_lines_raw(path2tndata)
  #' readr::write_lines(tndata, file=paste(wd,"/raw/TN_STAID000002.txt",sep=""))
  #' #Read the tn data
  #' y<-readecad(input=path2tndata,missing= -9999)[,3:4]
  #' options("homefolder"="./")
  #' #Call txtnblend()
  #' txtnblend(y,"TN_STAID000002.txt")
  #' #Introduce error values in the tn data
  #' y[c(1,3),2]<-100
  #' #Call txtnblend()
  #' txtnblend(y,"TN_STAID000002.txt")
  #' #Return to user's working directory:
  #' setwd(wd0)
  #' @export

  #Get value of 'Global variable' 'homefolder'
  homefolder <- getOption("homefolder")
  bad<-NULL
  whoami<-substring(id,1,2)
  if(whoami=='TX'){targetvariable='TN'}else{targetvariable='TX'}
  id2<-id;substring(id2,1,2)<-targetvariable; targetfile<-paste0(homefolder,'raw/',id2)
  if(file.exists(targetfile)){z<-readecad(targetfile)}else{return(bad)}
  zcols<-c(ncol(z)-2,ncol(z)-1);z<-z[,zcols] ### keep dates and values
  zz<-merge(y,z,all.x=TRUE,all.y=FALSE)### do not be fooled! all.y refers to the second variable!
  if(targetvariable=='TN'){bad<-which(zz[,2]<=zz[,3])}
  if(targetvariable=='TX'){bad<-which(zz[,2]>=zz[,3])}
  return(bad)
}