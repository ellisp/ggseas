StatRollmean <- ggproto("StatRollmean", Stat, 
                      required_aes = c("x", "y"),
                      
                      compute_group = function(data, scales, width, align, ...) {
                         data <- data[order(data$x), ]
                         y_ra <- zoo::rollapplyr(data$y, FUN = mean, width = width, 
                                            fill = NA, align = align, ...)
                         
                         result <- data.frame(x = data$x, y = as.numeric(y_ra))
                         return(result)
                      }
)




#' Rolling Mean Stat
#' 
#' Calculates rolling mean on the fly for ggplot2
#' 
#' @export
#' @import ggplot2
#' @param width The width
#' @param align specifies whether the transformed series should be left or 
#' right-aligned or centered compared to the rolling window of observations
#' @param ... other arguments for the geom
#' @inheritParams ggplot2::stat_identity
#' @family time series stats for ggplot2
#' @seealso \code{\link{decompose}}
#' @details blah blah blah
#' @examples
#' ap_df <- tsdf(AirPassengers)
#' 
#' ggplot(ap_df, aes(x = x, y = y)) +
#'    stat_rollmean(width = 12)
#' 
#' ggplot(ldeaths_df, aes(x = YearMon, y = deaths, colour = sex)) +
#'   geom_point() +
#'   facet_wrap(~sex) +
#'   stat_rollmean(width = 12) +
#'   ggtitle("Seasonally adjusted lung deaths")
#'
stat_rollmean <- function(mapping = NULL, data = NULL, geom = "line",
                        position = "identity", show.legend = NA, 
                        inherit.aes = TRUE, width, align = "right", ...) {
   ggplot2::layer(
      stat = StatRollmean, data = data, mapping = mapping, geom = geom, 
      position = position, show.legend = show.legend, inherit.aes = inherit.aes,
      params = list(width = width, align = align, na.rm = FALSE, ...)
      # note that this function is unforgiving of NAs.
   )
}

