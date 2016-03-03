StatSTL <- ggproto("StatSTL", Stat, 
                      required_aes = c("x", "y"),
                      
                      compute_group = function(data, scales, frequency, s.window, 
                                               index.ref, index.basis, ...) {
                         data <- data[order(data$x), ]
                         y_ts <- ts(data$y, frequency = frequency)
                         y_stl <- stl(y_ts, s.window = s.window)
                         y_sa <- with(as.data.frame(y_stl$time.series), trend + remainder)
                         result <- data.frame(x = data$x, y = as.numeric(y_sa))
                         
                         if(!is.null(index.ref)){
                            result$y <- index_help(result$y, ref = index.ref, 
                                                   basis = index.basis)
                         }
                         
                         return(result)
                      }
)




#' LOESS seasonal adjustment Stat
#' 
#' Conducts seasonal adjustment on the fly for ggplot2, from LOESS seasonal decomposition
#' 
#' @export
#' @import ggplot2
#' @param frequency The frequency for the time series
#' @param s.window either the character string \code{"periodic"} or the span (in lags) of the 
#' loess window for seasonal extraction, which should be odd and at least 7, according to
#' Cleveland et al.  This has no default and must be chosen.
#' @param index.ref if not NULL, a vector of integers indicating which elements of
#' the beginning of each series to use as a reference point for converting to an index.  
#' If NULL, no conversion takes place and the data are presented on the original scale.
#' @param index.basis if index.ref is not NULL, the basis point for converting
#' to an index, most commonly 100 or 1000.  See examples.
#' @param ... other arguments for the geom
#' @inheritParams ggplot2::stat_identity
#' @family time series stats for ggplot2
#' @examples
#' ap_df <- tsdf(AirPassengers)
#' 
#' # periodic if fixed seasonality; doesn't work well:
#' ggplot(ap_df, aes(x = x, y = y)) +
#'    stat_stl(frequency = 12, s.window = "periodic")
#' 
#' # seasonality varies a bit over time, works better:
#' ggplot(ap_df, aes(x = x, y = y)) +
#'    stat_stl(frequency = 12, s.window = 7)
#' 
#' ggplot(ldeaths_df, aes(x = YearMon, y = deaths, colour = sex)) +
#' geom_point() +
#'   facet_wrap(~sex) +
#' stat_stl(frequency = 12, s.window = 7) +
#'    ggtitle("Seasonally adjusted lung deaths")
#'
stat_stl <- function(mapping = NULL, data = NULL, geom = "line",
                     position = "identity", show.legend = NA, 
                     inherit.aes = TRUE, frequency, s.window, 
                     index.ref = NULL, index.basis = 100, ...) {
   ggplot2::layer(
      stat = StatSTL, data = data, mapping = mapping, geom = geom, 
      position = position, show.legend = show.legend, inherit.aes = inherit.aes,
      params = list(frequency = frequency, s.window = s.window, na.rm = FALSE, 
                    index.ref = index.ref, index.basis = index.basis, ...)
      # note that this function is unforgiving of NAs.
   )
}

