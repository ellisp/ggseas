#' Monthly Deaths from Lung Diseases in the UK
#'
#' A long form combination of \code{fdeaths} and \code{mdeaths} from the \code{datasets} package.
#'
#' \itemize{
#'   \item YearMon. Approximate, regular decimal representation of the beginning 
#'   of the period of measurement.  January 1974 is 1974.000
#'   \item sex.
#'   \item deaths. Monthly deaths from bronchitis, emphysema and asthma.
#'   ...
#' }
#'
#' @format A data frame with 141 rows and 3 variables.
#' @source P. J. Diggle (1990) \emph{Time Series: A Biostatistical Introduction}. Oxford, table A.3
#' @seealso \code{\link{ldeaths}}
"ldeaths_df"





#' New Zealand Balance of Payments selected variables 1972 to 2015
#' 
#' Selected exports and imports series from New Zealand's "BPM6 Quarterly (year ended in quarter), Balance of 
#' payments selected series (Qrtly-Mar/Jun/Sep/Dec)".
#' 
#' "BPM6" refers to the sixth edition of the IMF's Balance of Payments and
#' International Investment Position Manual, which is the method used by Statistics
#' New Zealand to prepare these data.
#' 
#' Note:
#' \itemize{
#'   \item 'Value' is in millions of New Zealand dollars and is not adjusted for inflation.
#'   \item 'nei' means 'not elsewhere included'.
#'   \item 'Category' items are not mutually exclusive; for example, 'Travel' is a 
#'   superset of 'Travel; Business'.
#'   \item TimePeriod is the last day of the reference period ie \code{1972-03-31}
#'   means the first three months of 1972.
#' }
#' 
#' This dataset was downloaded from \url{http://www.stats.govt.nz/infoshare/} and 
#' transformed in the following way:
#' 
#' \itemize{
#'   \item missing values were filtered out (ie of series that started later 
#'   than the longest series)
#'   \item estimates of balance were removed, leaving only exports and imports
#'   \item the single variable categorisation was split into three (Sector, Direction
#'    and Category) in accordance with 'tidy data' principles
#'   }
#' @source Statistics New Zealand \url{http://www.stats.govt.nz/browse_for_stats/economic_indicators/balance_of_payments/info-releases.aspx}
#' 
"nzbop"