library(knitr)
knit("README.Rmd", "README.md")

library(devtools)
document("pkg")
build("pkg")
source("examples/examples.R")


