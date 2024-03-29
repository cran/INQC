inqc<-function(homefolder='./',blend=TRUE){

  #' Wrapper for QC'ing all variables
  #' @description This function calls functions which perform QC for all climate variables
  #' @param homefolder path to the homefolder, as string
  #' @param blend logical flag which means performing (if TRUE) QC on blended time series
  #' @return QC results, in both formats (verbose and workable file in exact ECA&D format)
  #' @examples
  #' #Set a temporal working directory:
  #' wd <- tempdir(); wd0 <- setwd(wd)
  #' #Create subdirectory where raw data files have to be located
  #' dir.create(file.path(wd, 'raw'))
  #' #NON-BLENDED ECA&D SERIES
  #' #Extract the non-blended ECA&D data and station files from the example data folder
  #' #Only TX (maximum air temperature) and CC (cloud cover) data are used in the example
  #' path2txlist<-system.file("extdata", "ECA_blend_source_tx.txt", package = "INQC")
  #' txlist<-readr::read_lines_raw(path2txlist)
  #' readr::write_lines(txlist,'ECA_blend_source_tx.txt')
  #' path2txdata<-system.file("extdata", "TX_SOUID132734.txt", package = "INQC")
  #' txdata<-readr::read_lines_raw(path2txdata)
  #' readr::write_lines(txdata, file=paste(wd,'/raw/TX_SOUID132734.txt',sep=''))
  #' path2cclist<-system.file("extdata", "ECA_blend_source_cc.txt", package = "INQC")
  #' cclist<-readr::read_lines_raw(path2cclist)
  #' readr::write_lines(cclist,'ECA_blend_source_cc.txt')
  #' path2ccdata<-system.file("extdata", "CC_SOUID132727.txt", package = "INQC")
  #' ccdata<-readr::read_lines_raw(path2ccdata)
  #' readr::write_lines(ccdata, file=paste(wd,'/raw/CC_SOUID132727.txt',sep=''))
  #' #This is the MAIN starting point of the INQC software calculation:
  #' inqc(homefolder='./',blend=FALSE) #Work with non-blended ECA&D data
  #' #Remove some temporary files
  #' list = list.files(pattern = "Rfwf")
  #' file.remove(list)
  #' #The QC results can be found in the directory:
  #' print(wd)
  #' #BLENDED ECA&D SERIES
  #' #Extract the blended ECA&D data and station files from the example data folder
  #' #Only TX (maximum air temperature) and CC (cloud cover) data are used in the example
  #' path2list<-system.file("extdata", "stations.txt", package = "INQC")
  #' list<-readr::read_lines_raw(path2list)
  #' readr::write_lines(list,file=paste(wd,'/raw/stations.txt',sep=''))
  #' path2txdata<-system.file("extdata", "TX_STAID000002.txt", package = "INQC")
  #' txdata<-readr::read_lines_raw(path2txdata)
  #' readr::write_lines(txdata, file=paste(wd,'/raw/TX_STAID000002.txt',sep=''))
  #' path2ccdata<-system.file("extdata", "CC_STAID000001.txt", package = "INQC")
  #' ccdata<-readr::read_lines_raw(path2ccdata)
  #' readr::write_lines(ccdata, file=paste(wd,'/raw/CC_STAID000001.txt',sep=''))
  #' #This is the MAIN starting point of the INQC software calculation:
  #' inqc(homefolder='./',blend=TRUE) #work with blended ECA&D data
  #' #Remove some temporary files
  #' list = list.files(pattern = "Rfwf")
  #' file.remove(list)
  #' #The QC results can be found in the directory:
  #' print(wd)
  #' #Return to user's working directory:
  #' setwd(wd0)
  #' @export

  options("homefolder"=homefolder)
  options("blend"=blend)
  inithome()
  temperature(element='TX')
  temperature(element='TN')
  temperature(element='TG')
  precip()
  relhum()
  selepe()
  snowdepth()
  sundur()
  windspeed()
  clocov()
  dostats()
}
