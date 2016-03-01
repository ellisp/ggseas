

ap_df <- tsdf(AirPassengers)


#=========stat_rollmean==========
ggplot(ap_df, aes(x = x, y = y)) +
    stat_rollmean(width = 12)


ggplot(ldeaths_df, aes(x = YearMon, y = deaths, colour = sex)) +
   geom_point() +
   facet_wrap(~sex) +
   stat_rollmean(width = 12, align = "center") +
   ggtitle("Rolling annual average lung deaths")

#=================stat_decomp=============

ggplot(ap_df, aes(x = x, y = y)) +
   stat_seas(start = c(1949, 1), frequency = 12)

 ggplot(ap_df, aes(x = x, y = y)) +
    stat_seas(start = c(1949, 1), frequency = 12, x13_params = list(x11 = "", outlier = NULL))

 # default additive decomposition (doesn't work well in this case!):
 ggplot(ap_df, aes(x = x, y = y)) +
     stat_decomp(frequency = 12)
 
 # multiplicative decomposition, more appropriate:
 ggplot(ap_df, aes(x = x, y = y)) +
    stat_decomp(frequency = 12, type = "multiplicative")
 

 #=======================stl=================
  # periodic if fixed seasonality; doesn't work well:
  ggplot(ap_df, aes(x = x, y = y)) +
     stat_stl(frequency = 12, s.window = "periodic")
  
  # seasonality varies a bit over time, works better:
  ggplot(ap_df, aes(x = x, y = y)) +
     stat_stl(frequency = 12, s.window = 7)
  
  ggplot(ldeaths_df, aes(x = YearMon, y = deaths, colour = sex)) +
    geom_point() +
    facet_wrap(~sex) +
    stat_stl(frequency = 12, s.window = 7) +
    ggtitle("Seasonally adjusted lung deaths")
  
  
  
  #============ordering================
  ldeaths_sorted <- ldeaths_df[order(ldeaths_df$deaths), ]
  
  ggplot(ldeaths_sorted, aes(x = YearMon, y = deaths, colour = sex)) +
       stat_decomp(frequency = 12)
  
  ggplot(ldeaths_sorted, aes(x = YearMon, y = deaths, colour = sex)) +
     stat_seas(frequency = 12, start = c(1949, 1))
  
  ggplot(ldeaths_sorted, aes(x = YearMon, y = deaths, colour = sex)) +
     stat_stl(frequency = 12, s.window = 7)
  
  
  #===================ggsdc===============
  
  ggsdc(ap_df, aes(x = x, y = y), method = "decompose", frequency = 12) +
     geom_line()
  ggsdc(ap_df, aes(x = x, y = y), method = "decompose", frequency = 12, type = "multiplicative") +
     geom_line()
  
  ggsdc(ap_df, aes(x = x, y = y), method = "decompose", frequency = 12, type = "multiplicative") +
     geom_line(colour = "blue", size = 2) +
     theme_light(8)
  
  ggsdc(ap_df, aes(x = x, y = y), method = "stl", frequency = 12, s.window = 7) +
     labs(x = "", y = "Air passenger numbers") +
     geom_point()
  
  ggsdc(ap_df, aes(x = x, y = y), method = "stl", frequency = 12, s.window = "periodic") +
     geom_line() + geom_point()
  
  ggsdc(ap_df, aes(x = x, y = y), method = "seas", frequency = 12, start = c(1949, 1)) +
     geom_line()
  
  
  ggsdc(ldeaths_df, aes(x = YearMon, y = deaths, colour = sex), s.window = 7, frequency = 12) +
     geom_line()
  
  
  ggsdc(ldeaths_df, aes(x = YearMon, y = deaths, colour = sex), method = "seas", 
        frequency = 12, start = c(1949, 1)) +
     geom_line()
  
  
  # does it work with factors:
  ldeaths_df$sex <- as.factor(ldeaths_df$sex)
ggsdc(ldeaths_df, aes(x = YearMon, y = deaths, colour = sex), method = "decompose", frequency = 12) +
     geom_line()
  
ggsdc(ldeaths_df, aes(x = YearMon, y = deaths, colour = sex), method = "decompose", 
      frequency = 12, type = "multiplicative") +
   geom_line()


ggsdc(ldeaths_df, aes(x = YearMon, y = deaths, colour = sex), method = "seas", 
      frequency = 12, start = c(1949, 1)) +
   geom_line()
  
  

library(mbieDBmisc)
TRED <- odbcConnect("TRED_Prod")
tmp <- ImportTS2(TRED, Dataset_ID = 1)

ggsdc(tmp, aes(x = TimePeriod, y = Value, colour = CV1), frequency = 4, s.window = 7) +
   geom_line()

ggsdc(tmp, aes(x = TimePeriod, y = Value, colour = CV1), frequency = 4, 
      start = c(1987, 2), method = "seas") +
   geom_line()

ggsdc(nzbop, aes(x = TimePeriod, y = Value, colour = Category), frequency = 4, s.window = 7) +
   geom_line() +
   theme(legend.position = "none")


bop <- subset(nzbop, Account = "Current account")

ggsdc(bop, aes(x = TimePeriod, y = Value, colour = Category), frequency = 4, method = "decomp") +
   geom_line() 


ggsdc(bop, aes(x = TimePeriod, y = Value, colour = Category), frequency = 4, s.window = 7) +
   geom_line() 


# don't run - tests for an error message:
ggsdc(bop, aes(x = TimePeriod, y = Value, colour = Category), frequency = 4, 
      method = "seas", start = c(1971, 2)) +
   geom_line() 

ggsdc(subset(nzbop, Account == "Financial account"),
             aes(x = TimePeriod, y = Value, colour = Category),
             frequency = 4, s.window = 7) +
   geom_line()


View(subset(nzbop, Account == "Capital account"))

ca <- subset(nzbop, Account == "Current account" & !Balance)

ggsdc(ca, aes(x = TimePeriod, y = Value, colour = Category),
      frequency = 4, method = "seas", start = c(1971, 2)) +
   geom_line()


serv <- subset(nzbop, Account == "Current account" & 
                  Category %in% c("Services; Exports total", "Services; Imports total"))
ggsdc(serv, aes(x = TimePeriod, y = Value, colour = Category),
      method = "seas", start = c(1971, 2), frequency = 4) +
   geom_line()

ggsdc(serv, aes(x = TimePeriod, y = Value, colour = Category),
      method = "stl", s.window = 7, frequency = 4) +
   geom_line()

