


StatDecomp <- ggproto("StatDecomp", Stat, 
                    required_aes = c("x", "y"),
                    
                    compute_group = function(data, scales, frequency, type, 
                                             index.ref, index.basis, ...) {
                       data <- data[order(data$x), ]
                       
                       if(class(data$x) == "Date" & (is.null(frequency))){
                          stop("When x is of class 'Date' you need to specify frequency explicitly.")
                       }
                       
                       if(is.null(frequency)){
                          frequency <- unique(round(1 / diff(data$x)))   
                          if(length(frequency) != 1){
                             stop("Unable to calculate frequency from the data.")
                          }
                          message("Calculating frequency of ", frequency, " from the data.")
                       }
                       
                       
                       
                       y_ts <- ts(data$y, frequency = frequency)
                       y_dc <- decompose(y_ts, type = type)
                       if(type == "additive"){
                          y_sa = y_dc$x - y_dc$seasonal   
                       } else {
                          y_sa = y_dc$x / y_dc$seasonal   
                       }
                       
                       result <- data.frame(x = data$x, y = as.numeric(y_sa))
                       
                       if(!is.null(index.ref)){
                          result$y <- index_help(result$y, ref = index.ref, 
                                               basis = index.basis)
                       }
                       
                       return(result)
                    }
)




#' Classical seasonal adjustment Stat
#' 
#' Conducts seasonal adjustment on the fly for ggplot2, from classical seasonal decomposition by moving averages
#' 
#' @export
#' @import ggplot2
#' @param frequency The frequency for the time series
#' @param type The type of seasonal component
#' @param index.ref if not NULL, a vector of integers indicating which elements of
#' the beginning of each series to use as a reference point for converting to an index.  
#' If NULL, no conversion takes place and the data are presented on the original scale.
#' @param index.basis if index.ref is not NULL, the basis point for converting
#' to an index, most commonly 100 or 1000.  See examples.
#' @param ... other arguments for the geom
#' @inheritParams ggplot2::stat_identity
#' @family time series stats for ggplot2
#' @seealso \code{\link{decompose}}
#' @details Classical decomposition is a very basic way of performing seasonal
#' adjustment and is not recommended if you have access to X13-SEATS-ARIMA 
#' (\code{stat_seas}).  \code{stat_decomp} cannot allow the seasonality to vary
#' over time, or take outliers into account in calculating seasonality.
#' @examples
#' ap_df <- tsdf(AirPassengers)
#' 
#' # Default additive decomposition (doesn't work well in this case!):
#' ggplot(ap_df, aes(x = x, y = y)) +
#'    stat_decomp()
#' 
#' # Multiplicative decomposition, more appropriate:
#' ggplot(ap_df, aes(x = x, y = y)) +
#'    stat_decomp(type = "multiplicative")
#' 
#' # Multiple time series example:
#' ggplot(ldeaths_df, aes(x = YearMon, y = deaths, colour = sex)) +
#'   geom_point() +
#'   facet_wrap(~sex) +
#'   stat_decomp() +
#'   ggtitle("Seasonally adjusted lung deaths")
#'
#' # Example using index:
#' ggplot(ldeaths_df, aes(x = YearMon, y = deaths, colour = sex)) +
#'   facet_wrap(~sex) +
#'   stat_decomp(index.ref = 1:12, index.basis = 1000) +
#'   ggtitle("Rolling annual median lung deaths, indexed (average month in 1974 = 1000)")
#'
stat_decomp <- function(mapping = NULL, data = NULL, geom = "line",
                      position = "identity", show.legend = NA, 
                      inherit.aes = TRUE, frequency = NULL, type = c("additive", "multiplicative"), 
                      index.ref = NULL, index.basis = 100, ...) {
   type <- match.arg(type)
   ggplot2::layer(
      stat = StatDecomp, data = data, mapping = mapping, geom = geom, 
      position = position, show.legend = show.legend, inherit.aes = inherit.aes,
      params = list(frequency = frequency, type = type, na.rm = FALSE, 
                    index.ref = index.ref, index.basis = index.basis, ...)
      # note that this function is unforgiving of NAs.
   )
}

