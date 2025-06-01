


StatSeas <- ggproto("StatSeas", Stat, 
                  required_aes = c("x", "y"),
                  
                  compute_group = function(data, scales, x13_params, 
                                           index.ref, index.basis, start, frequency, ...) {
                     data <- data[order(data$x), ]

                     if(class(data$x) == "Date" & (is.null(frequency))){
                        stop("When x is of class 'Date' you need to specify frequency explicitly.")
                     }
                     
                     if(is.null(start)){
                        start <- data[1, "x"]
                           if(class(data$x) == "Date"){
                              stop("When x is of class 'Date' you need to specify start explicitly.")
                           }
                           message("Calculating starting date of ", start, " from the data.")
                        
                     }
                     if(is.null(frequency)){
                        frequency <- unique(round(1 / diff(data$x)))   
                        if(length(frequency) != 1){
                           stop("Unable to calculate frequency from the data.")
                        }
                        message("Calculating frequency of ", frequency, " from the data.")
                     }
                     
                     
                     y_ts <- stats::ts(data$y, frequency = frequency, start = start)
                     y_sa <- seasonal::final(seasonal::seas(y_ts, list = x13_params))
                     result <- data.frame(x = data$x, y = as.numeric(y_sa))
                     
                     if(!is.null(index.ref)){
                        result$y <- index_help(result$y, ref = index.ref, 
                                               basis = index.basis)
                     }
                     
                     return(result)
                  }
)




#' X13 seasonal adjustment Stat
#' 
#' Conducts X13-SEATS-ARIMA seasonal adjustment on the fly for ggplot2
#' 
#' @export
#' @import ggplot2
#' @importFrom seasonal final seas
#' @param data The data to be displayed in this layer. If NULL, this is
#'   inherited in the call to \code{\link[=ggplot2]{ggplot}}.
#' @param mapping 	Set of aesthetic mappings created by
#'   \code{\link[=ggplot2]{aes()}} or \code{\link[=ggplot2]{aes_()}}. If specified
#'   and \code{inherit.aes = TRUE} (the default), it is combined with the default
#'   mapping at the top level of the plot. You must supply mapping if there is
#'   no plot mapping.
#' @param geom The geometric object to use to display the data for this layer.
#' @param position A position adjustment to use on the data for this layer.
#' @param show.legend logical. Should this layer be included in the legends?
#'   \code{NA}, the default, includes if any aesthetics are mapped. \code{FALSE} never
#'   includes, and \code{TRUE} always includes. It can also be a named logical vector
#'   to finely select the aesthetics to display.
#' @param inherit.aes If \code{FALSE}, overrides the default aesthetics, rather than combining with them.
#' @param start The starting point for the time series, in a format suitable for \code{ts()}
#' @param frequency The frequency for the time series
#' @param x13_params a list of other parameters for \code{seas}
#' @param index.ref if not NULL, a vector of integers indicating which elements of
#' the beginning of each series to use as a reference point for converting to an index.  
#' If NULL, no conversion takes place and the data are presented on the original scale.
#' @param index.basis if index.ref is not NULL, the basis point for converting
#' to an index, most commonly 100 or 1000.  See examples.
#' @param ... other arguments for the geom
#' @family time series stats for ggplot2
#' @seealso \code{\link[=seasonal]{seas}}
#' @examples
#' \dontrun{
#' ap_df <- tsdf(AirPassengers)
#' 
#' # SEATS with defaults:
#' ggplot(ap_df, aes(x = x, y = y)) +
#'    stat_seas()
#'    
#' # X11 with no outlier treatment:
#' ggplot(ap_df, aes(x = x, y = y)) +
#'   stat_seas(x13_params = list(x11 = "", outlier = NULL))
#'
#' # Multiple time series example:    
#' ggplot(ldeaths_df, aes(x = YearMon, y = deaths, colour = sex)) +
#'   geom_point() +
#'   facet_wrap(~sex) +
#'   stat_seas() +
#'   ggtitle("Seasonally adjusted lung deaths")
#'   
#' # example use of index:  
#' ggplot(ap_df, aes(x = x, y = y)) +
#'   stat_seas(x13_params = list(x11 = "", outlier = NULL),
#'   index.ref = 1, index.basis = 1000) +
#'   labs(y = "Seasonally adjusted index\n(first observation = 1000)")
#'   
#' # if the x value is not a decimal eg not created with time(your_ts_object),
#' # you need to specify start and frequency by hand:
#' ggplot(subset(nzbop, Account == "Current account"), 
#'       aes(x = TimePeriod, y = Value)) +
#'    stat_seas(start = c(1971, 2), frequency = 12) +
#'    facet_wrap(~Category, scales = "free_y")
#'   
#'   }
stat_seas <- function(mapping = NULL, data = NULL, geom = "line",
                    position = "identity", show.legend = NA, 
                    inherit.aes = TRUE, x13_params = NULL, 
                    index.ref = NULL, index.basis = 100, 
                    frequency = NULL, start = NULL, ...) {
   
   ggplot2::layer(
      stat = StatSeas, data = data, mapping = mapping, geom = geom, 
      position = position, show.legend = show.legend, inherit.aes = inherit.aes,
      params = list(x13_params = x13_params, 
                    na.rm = FALSE, index.ref = index.ref, index.basis = index.basis, 
                    start = start, frequency = frequency, ...)
      # note that this function is unforgiving of NAs.
   )
}

