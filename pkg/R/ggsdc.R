

#' Visualise seasonal decomposition
#' 
#' Creates a standard plot of seasonal decomposition with four facets
#' 
#' @export
#' @import ggplot2
#' @param data dataset to use for plot.  
#' @param mapping List of aesthetic mappings.  Must include x and y, and optionally
#' can include colour/color 
#' @param frequency frequency of the period of the time series eg 12 = monthly
#' @param method function to use for performing the seasonal decomposition. stl
#' and decompose are functions in the \code{stats} package; \code{seas} is access
#' to the \code{seats} program from X-13-SEATS-ARIMA via the \code{seasonal} package
#' @param start starting time for the data; only needed if \code{method = 'seas'}.
#' @param s.window parameter to pass to \code{stl()}
#' @param type parameter to pass to \code{decompose()}
#' @seealso \code{\link{decompose}}, \code{\link{stl}}, \code{\link{seas}}
#' @details etc etc etc
#' @examples
#' print("hello world")
ggsdc <- function(data, mapping, frequency, method = c("stl", "decompose", "seas"),
                  start = NULL, s.window = NULL, 
                  type = c("additive", "multiplicative")) {
   # data = ldeaths_df; mapping = aes(x = YearMon, y = deaths, colour = sex); frequency = 12
   # data = ap_df; mapping = aes(x = x, y = y); frequency = 12; s.window = 7; type = "multiplicative", start = c(1949,1)
   
   data <- data[order(data[ , as.character(mapping$x)]), ]
   y <- ts(data[ , as.character(mapping$y)], frequency = frequency)
   
   
   if(method == "decompose"){
      model <- decompose(y, type = type)
      y2 <- as.numeric(model$trend)
      y3 <- as.numeric(model$seasonal)
      y4 <- as.numeric(model$random)
   }
   
   if(method == "stl"){
      if(is.null(s.window)){
         stop("A value is needed for s.window.  See ?stl for help.")
      }
      model <- stl(y, s.window = s.window)
      y2 <- as.numeric(model$time.series[ , 2])
      y3 <- as.numeric(model$time.series[ , 1])
      y4 <- as.numeric(model$time.series[ , 3])
   }
   
   if(method == "seas"){
      y <- ts(data[ , as.character(mapping$y)], frequency = frequency, start = start)
      model <- seas(y)
      y2 <- series(model, "s12", reeval = FALSE)
      y3 <- series(model, "s10", reeval = FALSE)
      y4 <- y / y2 / y3
      
   }
   
   sdc <- rbind(
      data.frame(x = data[ , as.character(mapping$x)],
              y = as.numeric(y),
              component = factor("observed", 
                                 levels = c("observed", "trend", "seasonal", "random")))  ,
      data.frame(x = data[ , as.character(mapping$x)],
                 y = y2,
                 component = "trend",
                 stringsAsFactors = FALSE),
      data.frame(x = data[ , as.character(mapping$x)],
                 y = y3,
                 component = "seasonal",
                 stringsAsFactors = FALSE),
      data.frame(x = data[ , as.character(mapping$x)],
                 y = y4,
                 component = "random",
                 stringsAsFactors = FALSE)
   )
      
      p <- ggplot(sdc, aes(x = x, y = y)) +
         facet_wrap(~component, ncol = 1, scale = "free_y") 
      
      return(p)
}