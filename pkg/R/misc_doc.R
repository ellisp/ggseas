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





#' New Zealand Balance of Payments major components 1971Q2 to 2015Q2
#' 
#' New Zealand's "BPM6 Quarterly, Balance of payments major components (Qrtly-Mar/Jun/Sep/Dec)".
#' 
#' "BPM6" refers to the sixth edition of the IMF's Balance of Payments and
#' International Investment Position Manual, which is the method used by Statistics
#' New Zealand to prepare these data.
#' 
#' Note:
#' \itemize{
#'   \item 'Value' is in millions of New Zealand dollars and is not adjusted for inflation.
#'   \item 'fob' means 'free on board'.
#'   \item 'inv.' stands for investment
#'   \item TimePeriod is the last day of the quarterly reference period ie \code{1971-06-30}
#'   means the fourth, fifth and six months of 1971.
#' }
#' 
#' This dataset was downloaded from \url{http://www.stats.govt.nz/infoshare/} and 
#' transformed in the following way:
#' 
#' \itemize{
#'   \item missing values were filtered out (ie of series that started later 
#'   than the longest series)
#'   \item a 'Balance' indicator variable was added for easier manipulation and filtering
#'   \item the single variable categorisation was split into two (Account
#'    and Category) to make it tidier.
#'   }
#' @source Statistics New Zealand \url{http://www.stats.govt.nz/browse_for_stats/economic_indicators/balance_of_payments/info-releases.aspx}
#' 
"nzbop"