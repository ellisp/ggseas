#' Time series to data frame
#' 
#' Convert a ts object to data.frame with columns for time period and the original data
#' 
#' @export
#' @param timeseries an object of class ts or mts 
#' @param colname Column name to give to the time period column
#' @details A convenience function to create a data frame from a time series or
#' multiple time series object.  The motivation is to make it easy to pass time
#' series data to functions that need data frames such as ggplot2.
#' @return a data.frame with the same number of rows as the original time series
#' @examples
#' head(tsdf(AirPassengers))
#' 
#' ld <- cbind(fdeaths, mdeaths)
#' head(tsdf(ld))
tsdf <- function(timeseries, colname = "x") {
   ct <- class(timeseries)
   
   if (! "ts" %in% ct){
      stop("timeseries needs to be of class ts or mts")
   }
   
   if(length(ct) == 1){
      # univariate
      output <- data.frame(
         TimePeriod = as.numeric(time(timeseries)),
         y = as.numeric(timeseries)
      )
      names(output)[1] <- colname
   } else {
      # multivariate
      output <- data.frame(
         TimePeriod = as.numeric(time(timeseries))
      )
      for(i in 1:ncol(timeseries)){
         output <- cbind(output, as.numeric(timeseries[ , i]))
      }
      names(output) <- c(colname, colnames(timeseries))
      
   }
   
   return(output)   
}


