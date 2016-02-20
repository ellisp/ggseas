

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
#' to X-13-SEATS-ARIMA from the \code{seasonal} package
#' @param start starting time for the data; only needed if \code{method = 'seas'}.
#' @seealso \code{\link{decompose}}, \code{\link{stl}}, \code{\link{seas}}
#' @details etc etc etc
#' @examples
#' print("hello world")
ggsdc <- function(data, mapping, frequency, method = c("stl", "decompose", "seas"),
                  start = NULL) {
   # data = ldeaths_df; mapping = aes(x = YearMon, y = deaths, colour = sex)
   # data = AirPassengers; mapping = aes(x =)
   cv <- as.character(mapping$colour)
   
   mapping
   