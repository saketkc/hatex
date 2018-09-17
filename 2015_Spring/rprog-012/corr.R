corr <- function(directory, threshold = 0) {
  files <- list.files(directory, pattern="*.csv", full.names=TRUE)
  corrs <- integer(0)
  #j <- 
  for (file in files){
    readData <- read.csv(file, header=T)
    countNA <- sum(complete.cases(readData))
    if (countNA >= threshold){
      corrs <- c(corrs, cor(readData$sulfate, readData$nitrate, use="pairwise.complete.obs"))
    }
    
  }
  corrs
}