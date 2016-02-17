library(knitr)
knit("README.Rmd", "README.md")

library(devtools)
build("pkg")

