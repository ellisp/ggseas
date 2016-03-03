library(Cairo)
CairoPDF("examples/examples.pdf", 11, 8)

ap_df <- tsdf(AirPassengers)


#=========stat_rollmean==========
print(
   ggplot(ap_df, aes(x = x, y = y)) +
    stat_rollapplyr(width = 12)
   )



print(
   ggplot(ldeaths_df, aes(x = YearMon, y = deaths, colour = sex)) +
   facet_wrap(~sex) +
   stat_rollapplyr(width = 12, align = "center", index.ref = 1:12, index.basis = 1000) +
   ggtitle("Rolling annual median lung deaths, indexed (average month in 1974 = 1000)")
   )

print(
   ggplot(ldeaths_df, aes(x = YearMon, y = deaths, colour = sex)) +
   geom_point() +
   facet_wrap(~sex) +
   stat_rollapplyr(width = 12, align = "center", FUN = median) +
   ggtitle("Rolling annual median lung deaths")
   )

#=================stat_decomp=============

 # default additive decomposition (doesn't work well in this case!):
 print(
    ggplot(ap_df, aes(x = x, y = y)) +
     stat_decomp(frequency = 12)
 )
 
 # multiplicative decomposition, more appropriate:
 print(
 ggplot(ap_df, aes(x = x, y = y)) +
    stat_decomp(frequency = 12, type = "multiplicative")
 )
 
 # multiplicative decomposition with index
 print(
 ggplot(ap_df, aes(x = x, y = y)) +
    stat_decomp(frequency = 12, type = "multiplicative", 
                index.ref = 1:12, index.basis = 1000) +
    labs(y = "Seasonally adjusted, index\n(first 12 months average = 1000")
 )


 print(
  ggplot(ldeaths_df, aes(x = YearMon, y = deaths, color = sex)) +
    stat_decomp(frequency = 12, index.ref = 1) +
     labs(y = "Deaths index (Jan 1974 = 100)")
 )
  
 #=======================stl=================
  # periodic if fixed seasonality; doesn't work well:
 print( 
 ggplot(ap_df, aes(x = x, y = y)) +
     stat_stl(frequency = 12, s.window = "periodic")
  
 )
  # seasonality varies a bit over time, works better:
 print( 
 ggplot(ap_df, aes(x = x, y = y)) +
     stat_stl(frequency = 12, s.window = 7)
 )
 
 print(
  ggplot(ap_df, aes(x = x, y = y)) +
     stat_stl(frequency = 12, s.window = 7, index.ref = 1)
 )
 
 print(
  ggplot(ldeaths_df, aes(x = YearMon, y = deaths, colour = sex)) +
    geom_point() +
    facet_wrap(~sex) +
    stat_stl(frequency = 12, s.window = 7) +
    ggtitle("Seasonally adjusted lung deaths")
 )
  
  #=====================seas=============
  print(
     ggplot(ap_df, aes(x = x, y = y)) +
        stat_seas(start = c(1949, 1), frequency = 12)
  )
  
  print(
     ggplot(ap_df, aes(x = x, y = y)) +
        stat_seas(start = c(1949, 1), frequency = 12, x13_params = list(x11 = "", outlier = NULL))
  )
  
  print(
     ggplot(ap_df, aes(x = x, y = y)) +
        stat_seas(start = c(1949, 1), frequency = 12, x13_params = list(x11 = "", outlier = NULL),
                  index.ref = 1, index.basis = 1000) +
        labs(y = "Seasonally adjusted index\n(first observation = 1000)")
  )
  
  
  
    
  #============ordering shouldn't matter================
  ldeaths_sorted <- ldeaths_df[order(ldeaths_df$deaths), ]
  
  print(
  ggplot(ldeaths_sorted, aes(x = YearMon, y = deaths, colour = sex)) +
     stat_decomp(frequency = 12) +
     stat_rollapplyr(width = 12, linetype = 2)
  )
  
  print(
  ggplot(ldeaths_sorted, aes(x = YearMon, y = deaths, colour = sex)) +
     stat_seas(frequency = 12, start = c(1949, 1))
  )
  
  print(
  ggplot(ldeaths_sorted, aes(x = YearMon, y = deaths, colour = sex)) +
     stat_stl(frequency = 12, s.window = 7)
  )
  
  #============stat_index============
  print(
  ggplot(ldeaths_df, aes(x = YearMon, y = deaths, color = sex)) +
     stat_index(index.ref = 1:12, index.basis = 1000) +
     ylab("Deaths index\n(average of first 12 months = 1000")
  )
  
  #===================ggsdc===============
  
  print(
  ggsdc(ap_df, aes(x = x, y = y), method = "decompose", frequency = 12) +
     geom_line()
  )
  
  print(
  ggsdc(ap_df, aes(x = x, y = y), method = "decompose", frequency = 12, type = "multiplicative") +
     geom_line()
   )
  
  print(
  ggsdc(ap_df, aes(x = x, y = y), method = "decompose", frequency = 12, type = "multiplicative") +
     geom_line(colour = "blue", size = 2) +
     theme_light(8)
  )
  
  print(
  ggsdc(ap_df, aes(x = x, y = y), method = "stl", frequency = 12, s.window = 7) +
     labs(x = "", y = "Air passenger numbers") +
     geom_point()
  )
  
  print(
  ggsdc(ap_df, aes(x = x, y = y), method = "stl", frequency = 12, s.window = "periodic") +
     geom_line() + geom_point()
  )
  
  print(
  ggsdc(ap_df, aes(x = x, y = y), method = "seas", frequency = 12, start = c(1949, 1)) +
     geom_line()
  )
  
  print(
  ggsdc(ldeaths_df, aes(x = YearMon, y = deaths, colour = sex), s.window = 7, frequency = 12) +
     geom_line()
  )
 
  print(
     ggsdc(ldeaths_df, aes(x = YearMon, y = deaths, colour = sex), s.window = 7, frequency = 12,
           index.ref = 1:12, index.basis = 1000) +
        geom_line() +
        ylab("Lung deaths index (average month in 1974 = 1000)")
  )
  
  
   
  print(
  ggsdc(ldeaths_df, aes(x = YearMon, y = deaths, colour = sex), method = "seas", 
        frequency = 12, start = c(1949, 1)) +
     geom_line()
  )
  
  # does it work with factors:
  ldeaths_df$sex <- as.factor(ldeaths_df$sex)
  print(
     ggsdc(ldeaths_df, aes(x = YearMon, y = deaths, colour = sex), method = "decompose", frequency = 12) +
     geom_line()
  )
  
  print(
   ggsdc(ldeaths_df, aes(x = YearMon, y = deaths, colour = sex), method = "decompose", 
      frequency = 12, type = "multiplicative") +
   geom_line()
)

  print(
ggsdc(ldeaths_df, aes(x = YearMon, y = deaths, colour = sex), method = "seas", 
      frequency = 12, start = c(1949, 1)) +
   geom_line()
  )
  

library(mbieDBmisc)
TRED <- odbcConnect("TRED_Prod")
tmp <- ImportTS2(TRED, Dataset_ID = 1)
detach("package:mbieDBmisc", unload = TRUE)
detach("package:mbie", unload = TRUE)

print(
ggsdc(tmp, aes(x = TimePeriod, y = Value, colour = CV1), frequency = 4, s.window = 7) +
   geom_line()
)

print(
ggsdc(tmp, aes(x = TimePeriod, y = Value, colour = CV1), frequency = 4, 
      start = c(1987, 2), method = "seas") +
   geom_line()
)

print(
ggsdc(nzbop, aes(x = TimePeriod, y = Value, colour = Category), frequency = 4, s.window = 7) +
   geom_line() +
   theme(legend.position = "none")
)

bop <- subset(nzbop, Account = "Current account")

print(
ggsdc(bop, aes(x = TimePeriod, y = Value, colour = Category), frequency = 4, method = "decomp") +
   geom_line() 
)

print(
ggsdc(bop, aes(x = TimePeriod, y = Value, colour = Category), frequency = 4, s.window = 7) +
   geom_line() 
)

# don't run - tests for an error message:
# ggsdc(bop, aes(x = TimePeriod, y = Value, colour = Category), frequency = 4, 
#       method = "seas", start = c(1971, 2)) +
#    geom_line() 

print(
ggsdc(subset(nzbop, Account == "Financial account"),
             aes(x = TimePeriod, y = Value, colour = Category),
             frequency = 4, s.window = 7) +
   geom_line()
)

ca <- subset(nzbop, Account == "Current account" & !Balance)

print(
   ggsdc(ca, aes(x = TimePeriod, y = Value, colour = Category),
      frequency = 4, method = "seas", start = c(1971, 2)) +
   geom_line()
)

serv <- subset(nzbop, Account == "Current account" & 
                  Category %in% c("Services; Exports total", "Services; Imports total"))
print(
ggsdc(serv, aes(x = TimePeriod, y = Value, colour = Category),
      method = "seas", start = c(1971, 2), frequency = 4) +
   geom_line()
)

print(
ggsdc(serv, aes(x = TimePeriod, y = Value, colour = Category),
      method = "stl", s.window = 7, frequency = 4) +
   geom_line()
)

dev.off()