library(mbieDBmisc)
library(dplyr)
library(stringr)

# depends on having access to the"TRED" database
TRED <- odbcConnect("TRED_Prod")

ds <- sqlFetch(TRED, "timeseries.dataset")
ds %>% filter(prefix == "BOPQ.S0")

nzbop <- ImportTS2(TRED, "BPM6 Quarterly, Balance of payments major components (Qrtly-Mar/Jun/Sep/Dec)") %>%
   select(-CV1, - Obs_Status) %>%
   rename(Category = CV2) %>%
   mutate(Category = as.character(Category)) %>%
   filter(!is.na(Value)) %>%
   mutate(Account = str_extract(Category, ".* account"),
          Category = gsub(".* account[; ]*", "", Category)) %>%
   mutate(Category = gsub("^balance", "Balance", Category)) %>%
   mutate(Balance = grepl("[Bb]alance", Category)) %>%
   select(TimePeriod, Account, Category, Value, Balance)


save(nzbop, file = "pkg/data/nzbop.rda")

odbcClose(TRED)
