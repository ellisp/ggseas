library(devtools)
library(knitr)

knit("README.Rmd", "README.md")


document("pkg")
test("pkg")
check("pkg")
build("pkg")
source("examples/examples.R")



