StatIndex <- ggproto("StatIndex", Stat, 
                          required_aes = c("x", "y"),
                          
                          compute_group = function(data, scales, 
                                                   index.ref, index.basis, ...) {
                             data <- data[order(data$x), ]
                             data$y <- index_help(data$y, ref = index.ref, 
                                                  basis = index.basis)
                             
                             result <- data.frame(x = data$x, y = data$y)
                             return(result)
                          }
)




#' Index Stat
#' 
#' Convert a time series from the original scale to an index for ggplot2
#' 
#' @export
#' @import ggplot2
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
#' @param index.ref if not NULL, a vector of integers indicating which elements of
#' the beginning of each series to use as a reference point for converting to an index.  
#' If NULL, no conversion takes place and the data are presented on the original scale.
#' @param index.basis if index.ref is not NULL, the basis point for converting
#' to an index, most commonly 100 or 1000.  See examples.
#' @param ... other arguments for the geom
#' @family time series stats for ggplot2
#' @examples
#' ap_df <- tsdf(AirPassengers)
#' 
#' ggplot(ldeaths_df, aes(x = YearMon, y = deaths, color = sex)) +
#'    stat_index(index.ref = 1:12, index.basis = 1000) +
#'    ylab("Deaths index\n(average of first 12 months = 1000")
#'    
stat_index <- function(mapping = NULL, data = NULL, geom = "line",
                       position = "identity", show.legend = NA, 
                       inherit.aes = TRUE, index.ref = NULL, 
                       index.basis = 100, ...) {
   ggplot2::layer(
      stat = StatIndex, data = data, mapping = mapping, geom = geom, 
      position = position, show.legend = show.legend, inherit.aes = inherit.aes,
      params = list(na.rm = FALSE, index.ref = index.ref, index.basis = index.basis, ...)
      # note that this function is unforgiving of NAs.
   )
}

