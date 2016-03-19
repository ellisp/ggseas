

#' @import stats
ggsdc_helper <- function(data, mapping, method, s.window, 
                         type = c("additive", "multiplicative"),
                         index.ref, index.basis, start, frequency){
   
   yvar <- as.character(mapping$y)
   xvar <- as.character(mapping$x)
   
   data <- data[order(data[ , xvar]), ]
   
   
   if(class(data[ , xvar]) == "Date" & (is.null(frequency))){
      stop("When x is of class 'Date' you need to specify frequency explicitly.")
   }
   
   if(is.null(start)){
      start <- data[1, xvar]
      if(method == "seas"){
         if(class(data[ , xvar]) == "Date"){
            stop("When x is of class 'Date' you need to specify start explicitly if method = 'seas'.")
         }
         message("Calculating starting date of ", start, " from the data.")
      }
   }
   if(is.null(frequency)){
      frequency <- unique(round(1 / diff(data[ , xvar])))   
      message("Calculating frequency of ", frequency, " from the data.")
   }
   
   
   
   if(!is.null(index.ref)){
      data[ , yvar] <- index_help(data[ , yvar], ref = index.ref, 
                           basis = index.basis)
   }
   
   if(method == "decompose"){
      type <- match.arg(type)
      y <- ts(data[ , yvar], frequency = frequency)
      model <- decompose(y, type = type)
      y2 <- as.numeric(model$trend)
      y3 <- as.numeric(model$seasonal)
      y4 <- as.numeric(model$random)
   }
   
   if(method == "stl"){
      if(is.null(s.window)){
         stop("A value is needed for s.window.  See ?stl for help.")
      }
      y <- ts(data[ , yvar], frequency = frequency)
      model <- stl(y, s.window = s.window)
      y2 <- as.numeric(model$time.series[ , 2])
      y3 <- as.numeric(model$time.series[ , 1])
      y4 <- as.numeric(model$time.series[ , 3]) 
   }
   
   if(method == "seas"){
      y <- ts(data[ , yvar], frequency = frequency, start = start)
      model <- seas(y)
      d <- as.data.frame(model$data)
      y2 <- d$trend
      y3 <- y - d$seasonaladj
      # y4 <- d$irregular # problem with this is sometimes it's a multiplier, sometimes additive
      y4 <- y - y2 - y3

   }
   
   sdc <- rbind(
      data.frame(x = data[ , xvar],
                 y = as.numeric(y),
                 component = factor("observed", 
                                    levels = c("observed", "trend", "seasonal", "irregular")))  ,
      data.frame(x = data[ , xvar],
                 y = y2,
                 component = "trend",
                 stringsAsFactors = FALSE),
      data.frame(x = data[ , xvar],
                 y = y3,
                 component = "seasonal",
                 stringsAsFactors = FALSE),
      data.frame(x = data[ , xvar],
                 y = y4,
                 component = "irregular",
                 stringsAsFactors = FALSE)
   )
   
   return(sdc)
   
}

#' Visualise seasonal decomposition
#' 
#' Creates a four-facet plot of seasonal decomposition showing observed, trend, seasonal and random components
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
#' @param index.ref if not NULL, a vector of integers indicating which elements of
#' the beginning of each series to use as a reference point for converting to an index.  
#' If NULL, no conversion takes place and the data are presented on the original scale.
#' @param index.basis if index.ref is not NULL, the basis point for converting
#' to an index, most commonly 100 or 1000.  See examples.
#' @return an object of class ggplot with four facets
#' @seealso \code{\link{decompose}}, \code{\link{stl}}, \code{\link{seas}}
#' @details This function takes a data frame and performs seasonal decomposition
#' on the variable mapped to the y aesthetic, grouped by the variable (if any)
#' mapped to the colour or color aesthetic.  This allows the user to perform
#' the equivalent of plot(stats::decompose(x)) but in the ggplot2 environment for themes,
#' polishing etc; and to overlay decompositions on the same graphic; and with the 
#' X13-SEATS-ARIMA seasonal decomposition (so far only with default settings).
#' 
#' The "seasonal" component can be either multiplicative (in which case it will
#' in a small range of values around one) or additive (in which case it will be
#' on the scale of the original data), depending on the settings.
#' 
#' @examples
#' # sample time series data in data frame
#' ap_df <- tsdf(AirPassengers)
#' 
#' ggsdc(ap_df, aes(x = x, y = y), method = "decompose") +
#'    geom_line()
#'    
#' ggsdc(ap_df, aes(x = x, y = y), method = "decompose", 
#'       type = "multiplicative") +
#'    geom_line(colour = "blue", size = 2) +
#'    theme_light(8)
#' 
#' ggsdc(ap_df, aes(x = x, y = y), method = "stl", s.window = 7) +
#'    labs(x = "", y = "Air passenger numbers") +
#'    geom_point()
#'    
#' \dontrun{      
#' ggsdc(ldeaths_df, aes(x = YearMon, y = deaths, colour = sex), method = "seas") +
#'       geom_line()
#'       
#' serv <- subset(nzbop, Account == "Current account" & 
#'             Category %in% c("Services; Exports total", "Services; Imports total"))
#' ggsdc(serv, aes(x = TimePeriod, y = Value, colour = Category),
#'       method = "seas", start = c(1971, 2), frequency = 4) +
#'    geom_line()
#' }
#' 
#' ggsdc(ldeaths_df, aes(x = YearMon, y = deaths, colour = sex), s.window = 7, 
#'    index.ref = 1:12, index.basis = 1000) +
#'    geom_line() +
#'    ylab("Lung deaths index (average month in 1974 = 1000)")
#'       
#' bop <- subset(nzbop, Account == "Current account" & !Balance)
#' ggsdc(bop, aes(x = TimePeriod, y = Value, colour = Category), frequency = 4, 
#'    method = "decomp", type = "multiplicative") +
#'       geom_line() 
#'       
#' ggsdc(bop, aes(x = TimePeriod, y = Value, colour = Category), frequency = 4, s.window = 7) +
#'       geom_line() 
ggsdc <- function(data, mapping, frequency = NULL, method = c("stl", "decompose", "seas"),
                  start = NULL, s.window, 
                  type = c("additive", "multiplicative"),
                  index.ref = NULL, index.basis = 100) {

   method <- match.arg(method)
   
   # Australian/British spelling please:
   names(mapping)[names(mapping) == "color"] <- "colour"
   
   if(!is.null(mapping$colour)){
      # Multivariate - a dimension mapped to colour
      
      colvar <- as.character(mapping$colour)
      if(length(unique(table(data[ , colvar]))) > 1 & method == "seas"){
         stop("Time series are of different lengths.  Cannot use method 'seas' in this situation, try 'stl' instead.")
      }
      
      # make a convenient vector of the variable mapped to colour
      cv <- as.character(data[ , colvar])
      all_cols <- unique(cv)
      for(this_col in all_cols){
         this_data <- data[cv == this_col, ]
         this_sdc <- ggsdc_helper(data = this_data, mapping = mapping, 
                                  method = method, s.window = s.window, type = type,
                                  index.ref = index.ref, index.basis = index.basis, 
                                  frequency = frequency, start = start)
         this_sdc$colour <- this_col
      
         if(exists("sdc")){
            sdc <- rbind(sdc, this_sdc)
         } else {
            sdc <- this_sdc
         }
      }
      
      names(sdc)[names(sdc) == "colour"] <- colvar
      
      p <- ggplot(sdc, aes_string(x = "x", y = "y", colour = colvar)) +
         facet_wrap(~component, ncol = 1, scales = "free_y") 
      
      
   } else {
      # Univariate
      sdc <- ggsdc_helper(data = data, mapping = mapping, 
                          method = method, s.window = s.window, type = type,
                          index.ref = index.ref, index.basis = index.basis, 
                          frequency = frequency, start = start)
      
      p <- ggplot(sdc, aes_string(x = "x", y = "y")) +
         facet_wrap(~component, ncol = 1, scales = "free_y") 
      
   }
   
   
   return(p)  
   
   
}