temperature<-function(element='TX',large=500,small=-500,maxjump=200,maxseq=3,margina=0.999,
                      level=4,window=11,roundmax=10,blockmanymonth=15,blockmanyyear=180,
                      blocksizeround=20,qjump=0.999,tjump=1.5,
                      inisia=FALSE){

  #' QC for Air Temperature (TX/TN/TG)
  #' @description This function will centralize temperature-like QC routines. It will QC files for temperature. Reads all the temperature data in the
  #' ./raw folder (TX, TN or TG) and quality controls each of them. Notice that ECA&D stores temperature in 1/10th of Celsius degrees when entering new parameter values
  #' @seealso consolidator(), duplas(), flat(), IQRoutliers(), jumps2(), newfriki(), physics(), toomany(), rounding(), txtn(), weirdate()
  #
  # @param home path to the home directory, passed as character string
  #' @param element two-letters ECA&D code for the element ('TX' for daily maximum temperature,
  #' 'TN' for daily minimum temperature, 'TG' for daily mean temperature) passed as character string
  #' @param large value above which the observation is considered physically impossible for the region. Defaulted to 500. Passed on to physics(). See ?physics for details
  #' @param small value below which the observation is considered physically impossible for the region. Defaulted to -500. Passed on to physics(). See ?physics for details
  #' @param maxjump forcing for jumps2() in absolute mode (in the same units of the variable). Passed on to jumps2(). See ?jumps2 for further details
  #' @param maxseq maximum number of consecutive repeated values, for flat function (11.1,11.1,11.1 would be 3 consecutive values). Passed on to flat(). See ?flat for details
  #' @param margina tolerance margin, expressed as quantile of the differences, FUNCTION: newfriki(). Passed on to newfriki(). See ?newfriki for details
  #' @param level number of IQRs for IQRoutliers()
  #' @param window number of days to be considered (including the target), FUNCTION: IQRoutliers()
  #' @param roundmax maximum number of consecutive decimal part value, for flat function (10.0, 11.0, 12.0 would be 3 consecutive value). Passed on to flat()
  # @param blocksize such parameter (blocksize=10) was included into the arguments of the function but not used in the calculations
  # @param step such parameter (step=30) was included into the arguments of the function but not used in the calculations
  #' @param blockmanymonth maximum number of equal values in a month, FUNCTION: toomany()
  #' @param blockmanyyear maximum number of equal values in a year, FUNCTION: toomany()
  #' @param blocksizeround the maximum number of repeated values with the same decimal, FUNCTION: roundprecip()
  #' @param qjump quantile for jumps2() in quantile mode. Passed on to jumps2(). See ?jumps2 for further details
  #' @param tjump factor to multiply the quantile value for jumps2(). Passed on to jumps2(). See ?jumps2 for further details
  #' @param inisia logical flag. If it is TRUE inithome() will be called
  #' @return results of QC for TX/TN/TG
  #' @examples
  #' #Set a temporal working directory:
  #' wd <- tempdir()
  #' wd0 <- setwd(wd)
  #' #Create subdirectory where raw data files have to be located
  #' dir.create(file.path(wd, 'raw'))
  #' options("homefolder"='./'); options("blend"=FALSE)
  #' #Extract the ECA&D data and station files from the example data folder
  #' path2tnlist<-system.file("extdata", "ECA_blend_source_tn.txt", package = "INQC")
  #' tnlist<-readr::read_lines_raw(path2tnlist)
  #' readr::write_lines(tnlist,'ECA_blend_source_tn.txt')
  #' path2tndata<-system.file("extdata", "TN_SOUID132733.txt", package = "INQC")
  #' tndata<-readr::read_lines_raw(path2tndata)
  #' readr::write_lines(tndata, file=paste(wd,'/raw/TN_SOUID132733.txt',sep=''))
  #' #Perform QC of Air Temperature data
  #' temperature(element='TN',inisia=TRUE)
  #' #Remove some temporary files
  #' list = list.files(pattern = "Rfwf")
  #' file.remove(list)
  #' #Return to user's working directory:
  #' setwd(wd0)
  #' #The QC results can be found in the directory:
  #' print(wd)
  #' @export

  #Get values of 'Global variables' 'blend' and 'homefolder'
  blend <- getOption("blend")
  homefolder <- getOption("homefolder")
  if(inisia){inithome()}
  tx<-lister(element)
  ene<-length(tx)
  if(ene==0){return()}
  for(i in 1:ene){
    name<-paste(homefolder,'raw/',tx[i],sep='')
    print(paste(name,i,'of',ene),quote=FALSE)
    x<-readecad(input=name) ; print(paste(Sys.time(),'Ended readecad'),quote=FALSE)
    if(!'STAID' %in% colnames(x) & ncol(x)==4){x<-cbind(STAID=as.numeric(substring(tx[i],9,14)),x)}
    x<-x[,1:4];colnames(x)<-c('STAID','SOUID','DATE','value')
    #pattern(x[,4])
    bad<-weirddate(x[,3:4]);x$weirddate<-0;if(length(bad)!=0){x$weirddate[bad]<-1}; print(paste(Sys.time(),'Ended weirddate'),quote=FALSE)
    bad<-duplas(x$DATE);x$dupli<-0;if(length(bad)!=0){x$dupli[bad]<-1}; print(paste(Sys.time(),'Ended duplas'),quote=FALSE)
    bad<-physics(x$value,large,1);x$large<-0;if(length(bad)!=0){x$large[bad]<-1}; print(paste(Sys.time(),'Ended physics, large'),quote=FALSE)
    bad<-physics(x$value,small,3);x$small<-0;if(length(bad)!=0){x$small[bad]<-1}; print(paste(Sys.time(),'Ended physics, small'),quote=FALSE)
    bad<-jumps2(x$DATE,x$value,force=maxjump);x$jumpABS<-0;if(length(bad)!=0){x$jumpABS[bad]<-1}; print(paste(Sys.time(),'Ended jumps ABSOLUTE'),quote=FALSE)
    bad<-jumps2(x$DATE,x$value,qjump,tjump);x$jumpQUANT<-0;if(length(bad)!=0){x$jumpQUANT[bad]<-1}; print(paste(Sys.time(),'Ended jumps QUANTILE'),quote=FALSE)
    bad<-flat(x$value,maxseq);x$flat<-0;if(length(bad)!=0){x$flat[bad]<-1}; print(paste(Sys.time(),'Ended flat for values'),quote=FALSE)
    bad<-flat(x$value%%10,roundmax);x$roundmax<-0;if(length(bad)!=0){x$roundmax[bad]<-1}; print(paste(Sys.time(),'Ended flat for decimal part'),quote=FALSE)
    bad<-newfriki(x$DATE,x$value,margina,times=3);x$friki<-0;if(length(bad)!=0){x$friki[bad]<-1} ; print(paste(Sys.time(),'Ended newfriki for errors'),quote=FALSE)
    bad<-newfriki(x$DATE,x$value,margina,times=1.5);x$frikilight<-0;if(length(bad)!=0){x$frikilight[bad]<-1} ; print(paste(Sys.time(),'Ended newfriki for suspect'),quote=FALSE)
    bad<-IQRoutliers(x$DATE,x$value,level,window);x$IQRoutliers<-0;if(length(bad)!=0){x$IQRoutliers[bad]<-1}; print(paste(Sys.time(),'Ended IQR outliers'),quote=FALSE)
    bad<-toomany(x[,3:4],blockmanymonth,1);x$toomanymonth<-0;if(length(bad)!=0){x$toomanymonth[bad]<-1}; print(paste(Sys.time(),'Ended toomany, monthly'),quote=FALSE)
    bad<-toomany(x[,3:4],blockmanyyear,2);x$toomanyyear<-0;if(length(bad)!=0){x$toomanyyear[bad]<-1}; print(paste(Sys.time(),'Ended toomany, annual'),quote=FALSE)
    bad<-rounding(x[,3:4],blocksizeround);x$rounding<-0;if(length(bad)!=0){x$rounding[bad]<-1}; print(paste(Sys.time(),'Ended rounding'),quote=FALSE)
    if(element != 'TG' & !blend){bad<-txtn(x[,3:4],tx[i]);x$txtn<-0;if(length(bad)!=0){x$txtn[bad]<-1}; print(paste(Sys.time(),'Ended txtn'),quote=FALSE)}
    if(element != 'TG' &  blend){bad<-txtnblend(x[,3:4],tx[i]);x$txtn<-0;if(length(bad)!=0){x$txtn[bad]<-1}; print(paste(Sys.time(),'Ended txtn'),quote=FALSE)}
    consolidator(tx[i],x)
  }
}