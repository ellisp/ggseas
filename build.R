library(devtools)
library(knitr)

knit("README.Rmd", "README.md")


document("pkg")
test("pkg")
check("pkg")
build("pkg")
build_vignettes("pkg")

source("examples/examples.R") # many of the examples in the helpfiles are in \dontrun{} brackets
                              # because of using X13-SEATS-ARIMA, so good to run separately here.

source("examples/test-tibbles.R")



