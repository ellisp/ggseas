library(devtools)
library(knitr)

knit("README.Rmd", "README.md")


document("pkg")
test("pkg")
check("pkg")
build("pkg")
build_vignettes("pkg")

source("examples/examples.R")
source("examples/test-tibbles.R")



