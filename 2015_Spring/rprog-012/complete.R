formatID <- function(i) {
  if(i<100 & i>=10){
    i <- paste("0", i, sep="");
  }
  else if(i<10){
    i <- paste("00", i, sep="");
  }
  i
}
complete <- function(directory, id = 1:332) {
  df <- data.frame(id=integer(0), nobs=integer(0))
  j <- 1
  for (i in id){
    ID <- formatID(i) 
    readData <- read.csv(paste(directory, "/", ID, ".csv", sep=""), header=T)
    countNA <- sum(complete.cases(readData))
    df[j, ] <- c(i, countNA)
    j <- j+1
    }
  df
}
