library(knitr)
knit("README.Rmd", "README.md")

library(devtools)
document("pkg")
test("pkg")
build("pkg")
source("examples/examples.R")



