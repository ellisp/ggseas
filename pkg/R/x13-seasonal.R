


StatSeas <- ggproto("StatSeas", Stat, 
                  required_aes = c("x", "y"),
                  
                  compute_group = function(data, scales, x13_params, 
                                           index.ref, index.basis, ...) {
                     data <- data[order(data$x), ]

                     # Why not getting this from x?
                     start <- data$x[1]
                     frequency <- unique(round(1 / diff(data$x)))

                     y_ts <- ts(data$y, frequency = frequency, start = start)
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
#' @import seasonal
#' @param start The starting point for the time series, in a format suitable for \code{ts()}
#' @param frequency The frequency for the time series
#' @param x13_params a list of other parameters for \code{seas}
#' @param index.ref if not NULL, a vector of integers indicating which elements of
#' the beginning of each series to use as a reference point for converting to an index.  
#' If NULL, no conversion takes place and the data are presented on the original scale.
#' @param index.basis if index.ref is not NULL, the basis point for converting
#' to an index, most commonly 100 or 1000.  See examples.
#' @param ... other arguments for the geom
#' @inheritParams ggplot2::stat_identity
#' @family time series stats for ggplot2
#' @seealso \code{\link{seas}}
#' @examples
#' \dontrun{
#' ap_df <- tsdf(AirPassengers)
#' 
#' # SEATS with defaults:
#' ggplot(ap_df, aes(x = x, y = y)) +
#'    stat_seas(start = c(1949, 1), frequency = 12)
#'    
#' # X11 with no outlier treatment:
#' ggplot(ap_df, aes(x = x, y = y)) +
#'   stat_seas(start = c(1949, 1), frequency = 12, x13_params = list(x11 = "", outlier = NULL))
#'
#' # Multiple time series example:    
#' ggplot(ldeaths_df, aes(x = YearMon, y = deaths, colour = sex)) +
#'   geom_point() +
#'   facet_wrap(~sex) +
#'   stat_seas(start = c(1974, 1), frequency = 12) +
#'   ggtitle("Seasonally adjusted lung deaths")
#'   
#' # example use of index:  
#' ggplot(ap_df, aes(x = x, y = y)) +
#'   stat_seas(start = c(1949, 1), frequency = 12, x13_params = list(x11 = "", outlier = NULL),
#'   index.ref = 1, index.basis = 1000) +
#'   labs(y = "Seasonally adjusted index\n(first observation = 1000)")
#'   }
stat_seas <- function(mapping = NULL, data = NULL, geom = "line",
                    position = "identity", show.legend = NA, 
                    inherit.aes = TRUE, x13_params = NULL, 
                    index.ref = NULL, index.basis = 100, ...) {
   ggplot2::layer(
      stat = StatSeas, data = data, mapping = mapping, geom = geom, 
      position = position, show.legend = show.legend, inherit.aes = inherit.aes,
      params = list(x13_params = x13_params, 
                    na.rm = FALSE, index.ref = index.ref, index.basis = index.basis, ...)
      # note that this function is unforgiving of NAs.
   )
}

