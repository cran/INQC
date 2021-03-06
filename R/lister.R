lister<-function(element){

  #' Creates a list of blended/non-bladed files for some climate variable
  #' @description This function create a list of blended or non-bladed files containing data of a specified element to be QCed.
  #' @param element climatological element (defined by means of two letters, i.e. 'TX')
  #' @return list of blended or non-bladed files to be QCed
  #' @export

  #Get values of 'Global variables' 'blend' and 'homefolder'
  blend <- getOption("blend")
  homefolder <- getOption("homefolder")
  if(blend){
    lista<-list.files(path=paste(homefolder,'raw',sep=''),pattern='STAID')
  }else{
    lista<-list.files(path=paste(homefolder,'raw',sep=''),pattern='SOUID')
  }
  tx<-lista[which(substring(lista,1,2)==element)]
  return(tx)
}