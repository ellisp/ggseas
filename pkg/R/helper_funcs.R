

index_help <- function(x, ref, basis = 100, na.rm = FALSE){
   # x should be a vector
   # ref should a vector of indices of x to use as the reference point for turning
   # x into an index
   ref_av <- mean(x[ref], na.rm = na.rm)
   x2 <- x / ref_av * basis
   return(x2)
}

## example usage: index so average of first 12 months =500:
# plot(index_help(AirPassengers, ref = 1:12, basis = 500))
