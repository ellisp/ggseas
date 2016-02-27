library(mbieDBmisc)
library(dplyr)

# depends on having access to the"TRED" database
TRED <- odbcConnect("TRED_Prod")


nzbop <- ImportTS2(TRED, "BPM6 Quarterly (year ended in quarter), Balance of payments selected series (Qrtly-Mar/Jun/Sep/Dec)") %>%
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
   mutate(Category = gsub("^total", "Total", Category)) %>%
   select(TimePeriod, Direction, Category, Sector, Value)

save(nzbop, file = "pkg/data/nzbop.rda")

odbcClose(TRED)
