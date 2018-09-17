pollutantmean <- function(directory, pollutant, id = 1:332) {
    data <- c()
    for (i in id){
        if(i<100 & i>=10){
          i <- paste("0", i, sep="");
        }
        else if(i<10){
          i <- paste("00", i, sep="");
        }
        readData <- read.csv(paste(directory, "/", i, ".csv", sep=""), header=T)
        
        data <- c(data, readData[[pollutant]])
    }
    mean(data, na.rm=T)
}
