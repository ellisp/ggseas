

ap_df <- tsdf(AirPassengers)





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

library(dplyr)
nzbpm <- ImportTS2(TRED, "BPM6 Quarterly (year ended in quarter), Balance of payments selected series (Qrtly-Mar/Jun/Sep/Dec)") %>%
   select(-CV1, - Obs_Status) %>%
   rename(Category = CV2) %>%
   filter(!is.na(Value)) %>%
   mutate(Category = gsub("Current account year ended in quarter; ", "", Category, fixed = TRUE),
          Direction = ifelse(grepl("Exports", Category), "Exports", "Balance"),
          Direction = ifelse(grepl("Imports", Category), "Imports", Direction)
          ) %>%
   filter(Direction != "Balance") %>%
   mutate(Category = gsub("Exports ", "", Category),
          Category = gsub("Exports; ", "", Category),
          Category = gsub("Imports ", "", Category),
          Category = gsub("Imports; ", "", Category)) %>%
   mutate(Sector = ifelse(grepl("Services", Category), "Services", "Goods (fob)")) %>%
   mutate(Category = gsub("Services; ", "", Category),
          Category = gsub("Goods; (fob) ", "", Category, fixed = TRUE)) %>%
   mutate(Category = gsub("^total", "Total", Category))

head(nzbpm)
unique(nzbpm[ , c("Category", "Direction", "Sector")])

ggsdc(nzbpm, aes(x = TimePeriod, y = Value, colour = Category), frequency = 4, s.window = 7) +
   geom_line() +
   theme(legend.position = "none")


bpm <- subset(nzbpm, Direction == "Exports" & Sector == "Services" & Category != "Total")

ggsdc(bpm, aes(x = TimePeriod, y = Value, colour = Category), frequency = 4, method = "decomp") +
   geom_line() 


ggsdc(bpm, aes(x = TimePeriod, y = Value, colour = Category), frequency = 4, s.window = 7) +
   geom_line() 


ggsdc(bpm, aes(x = TimePeriod, y = Value, colour = Category), frequency = 4, 
      method = "seas", start = c(1972, 1)) +
   geom_line() 


unique(nzbpm$Category)
