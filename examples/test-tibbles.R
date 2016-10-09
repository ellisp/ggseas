# in version 0.4.0 tibbles didn't work.  This forms a test case.  The fix seemed to
# be to convert it back into a data.frame which is surely undesirable.  But...
library(dplyr)

serv <- subset(nzbop, Account == "Current account" & 
                  Category %in% c("Services; Exports total", "Services; Imports total"))

# this always worked:
serv %>%
   group_by(Account) %>%
   ungroup() %>%
   as.data.frame() %>%
   ggsdc(aes(x = TimePeriod, y = Value, colour = Category),
         method = "stl", s.window = 7, frequency = 4,
         facet.titles = c("The original series", "The underlying trend", 
                          "Regular seasonal patterns", "All the randomness left")) +
   geom_line()

# this returns an error in v 0.4.0 and should be fixed.  Crashes if not working.
serv %>%
   group_by(Account) %>%
   ungroup() %>%
   ggsdc(aes(x = TimePeriod, y = Value, colour = Category),
         method = "stl", s.window = 7, frequency = 4,
         facet.titles = c("The original series", "The underlying trend", 
                          "Regular seasonal patterns", "All the randomness left")) +
   geom_line()

