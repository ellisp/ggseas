


StatDecomp <- ggproto("StatDecomp", Stat, 
                    required_aes = c("x", "y"),
                    
                    compute_group = function(data, scales, frequency, type, ...) {
                       y_ts <- ts(data$y, frequency = frequency)
                       y_dc <- decompose(y_ts, type = type)
                       if(type == "additive"){
                          y_sa = y_dc$x - y_dc$seasonal   
                       } else {
                          y_sa = y_dc$x / y_dc$seasonal   
                       }
                       
                       result <- data.frame(x = data$x, y = as.numeric(y_sa))
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
#' @param ... other arguments for the geom
#' @inheritParams ggplot2::stat_identity
#' @family time series stats for ggplot2
#' @seealso \code{\link{decompose}}
#' @details Classical decomposition is a very basic way of performing seasonal
#' adjustment and is not recommended if you have access to X13-SEATS-ARIMA 
#' (\code{stat_seas}).  \code{stat_decomp} cannot allow the seasonality to vary
#' over time, or take outliers into account in calculating seasonality.
#' @examples
#' ap_df <- data.frame(
#'       x = as.numeric(time(AirPassengers)),
#'       y = as.numeric(AirPassengers)
#'    )
#' 
#' # default additive decomposition (doesn't work well in this case!):
#' ggplot(ap_df, aes(x = x, y = y)) +
#'    stat_decomp(frequency = 12)
#' 
#' # multiplicative decomposition, more appropriate:
#' ggplot(ap_df, aes(x = x, y = y)) +
#'    stat_decomp(frequency = 12, type = "multiplicative")
#' 
#' ggplot(ldeaths_df, aes(x = YearMon, y = deaths, colour = sex)) +
#'   geom_point() +
#'   facet_wrap(~sex) +
#'   stat_decomp(frequency = 12) +
#'   ggtitle("Seasonally adjusted lung deaths")
#'
stat_decomp <- function(mapping = NULL, data = NULL, geom = "line",
                      position = "identity", show.legend = NA, 
                      inherit.aes = TRUE, frequency, type = c("additive", "multiplicative"), ...) {
   type <- match.arg(type)
   ggplot2::layer(
      stat = StatDecomp, data = data, mapping = mapping, geom = geom, 
      position = position, show.legend = show.legend, inherit.aes = inherit.aes,
      params = list(frequency = frequency, type = type, 
                    na.rm = FALSE, ...)
      # note that this function is unforgiving of NAs.
   )
}

