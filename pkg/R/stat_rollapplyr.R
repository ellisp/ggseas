StatRollapplyr <- ggproto("StatRollapplyr", Stat, 
                      required_aes = c("x", "y"),
                      
                      compute_group = function(data, scales, width, align, FUN, 
                                               index.ref, index.basis, ...) {
                         data <- data[order(data$x), ]
                         if(!is.null(index.ref)){
                            data$y <- index_help(data$y, ref = index.ref, 
                                                 basis = index.basis)
                         }
                         y_ra <- zoo::rollapplyr(data$y, FUN = FUN, width = width, 
                                            fill = NA, align = align, ...)
                         
                         result <- data.frame(x = data$x, y = as.numeric(y_ra))
                         return(result)
                      }
)




#' Rolling summary Stat
#' 
#' Calculates a rolling summary, usually rolling average, on the fly for ggplot2
#' 
#' @export
#' @import ggplot2
#' @importFrom zoo rollapplyr
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
#' @param width The width to which the rolling version of FUN is applied
#' @param align specifies whether the transformed series should be left or 
#' right-aligned or centered compared to the rolling window of observations
#' @param FUN summary function, usually some kind of average, to apply on a rolling basis
#' @param index.ref if not NULL, a vector of integers indicating which elements of
#' the beginning of each series to use as a reference point for converting to an index.  
#' If NULL, no conversion takes place and the data are presented on the original scale.
#' @param index.basis if index.ref is not NULL, the basis point for converting
#' to an index, most commonly 100 or 1000.  See examples.
#' @param ... other arguments for the geom
#' @family time series stats for ggplot2
#' @seealso \code{\link{decompose}}
#' @details Calculates a rolling summary (usually rolling average) on the fly
#' for purposes of plotting with ggplot2.
#' @examples
#' ap_df <- tsdf(AirPassengers)
#' 
#' ggplot(ap_df, aes(x = x, y = y)) +
#'    stat_rollapplyr(width = 12)
#'    
#' # rolling average after converting to an index, 1000 = average value
#' # in the first 12 months.
#' ggplot(ap_df, aes(x = x, y = y)) +
#'    stat_rollapplyr(width = 12, index.ref = 1:12, index.basis = 1000)
#' 
#' ggplot(ldeaths_df, aes(x = YearMon, y = deaths, colour = sex)) +
#'   geom_point() +
#'   facet_wrap(~sex) +
#'   stat_rollapplyr(width = 12, FUN = median) +
#'   ggtitle("Seasonally adjusted lung deaths")
#'
stat_rollapplyr <- function(mapping = NULL, data = NULL, geom = "line",
                        position = "identity", show.legend = NA, 
                        inherit.aes = TRUE, width, align = "right", 
                        FUN = mean, index.ref = NULL, index.basis = 100, ...) {
   ggplot2::layer(
      stat = StatRollapplyr, data = data, mapping = mapping, geom = geom, 
      position = position, show.legend = show.legend, inherit.aes = inherit.aes,
      params = list(width = width, align = align, na.rm = FALSE, FUN = FUN, 
                    index.ref = index.ref, index.basis = index.basis, ...)
      # note that this function is unforgiving of NAs.
   )
}

