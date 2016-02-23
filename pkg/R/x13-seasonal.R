


StatSeas <- ggproto("StatSeas", Stat, 
                  required_aes = c("x", "y"),
                  
                  compute_group = function(data, scales, frequency, start, x13_params, ...) {
                     data <- data[order(data$x), ]
                     y_ts <- ts(data$y, frequency = frequency, start = start)
                     y_sa <- seasonal::final(seasonal::seas(y_ts, list = x13_params))
                     result <- data.frame(x = data$x, y = as.numeric(y_sa))
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
#' @param ... other arguments for the geom
#' @inheritParams ggplot2::stat_identity
#' @family time series stats for ggplot2
#' @seealso \code{\link{seas}}
#' @examples
#' ap_df <- tsdf(AirPassengers)
#' 
#' # SEATS with defaults
#' ggplot(ap_df, aes(x = x, y = y)) +
#'    stat_seas(start = c(1949, 1), frequency = 12)
#'    
#' # X11 with no outlier treatment
#' ggplot(ap_df, aes(x = x, y = y)) +
#'   stat_seas(start = c(1949, 1), frequency = 12, x13_params = list(x11 = "", outlier = NULL))
#'    
#' ggplot(ldeaths_df, aes(x = YearMon, y = deaths, colour = sex)) +
#'   geom_point() +
#'   facet_wrap(~sex) +
#'   stat_seas(start = c(1974, 1), frequency = 12) +
#'   ggtitle("Seasonally adjusted lung deaths")

stat_seas <- function(mapping = NULL, data = NULL, geom = "line",
                    position = "identity", show.legend = NA, 
                    inherit.aes = TRUE, start, frequency, x13_params = NULL, ...) {
   ggplot2::layer(
      stat = StatSeas, data = data, mapping = mapping, geom = geom, 
      position = position, show.legend = show.legend, inherit.aes = inherit.aes,
      params = list(frequency = frequency, start = start, x13_params = x13_params, 
                    na.rm = FALSE, ...)
      # note that this function is unforgiving of NAs.
   )
}

