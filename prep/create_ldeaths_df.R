library(tidyr)
library(dplyr)

ldeaths_df <- cbind(fdeaths, mdeaths, YearMon = time(fdeaths)) %>%
   as.data.frame() %>%
   gather(sex, deaths, -YearMon) %>%
   mutate(sex = ifelse(sex == "fdeaths", "female", "male"))


save(ldeaths_df, file = "data/ldeaths_df.rda")