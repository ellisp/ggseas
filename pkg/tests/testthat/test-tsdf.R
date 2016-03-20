

test_that("tsdf works with univariate time series", {
   ap_df <- tsdf(AirPassengers)
   expect_equal(nrow(ap_df), 144)
   expect_equal(ncol(ap_df), 2)
})


test_that("tsdf works with multivariate time series", {
   tmp1 <- cbind(fdeaths, mdeaths)
   tmp2 <- tsdf(tmp1)
   expect_equal(nrow(tmp2), 72)
   expect_equal(ncol(tmp2), 3)
})

test_that("ggplot can draw graphic with tsdf output", {
   tmp1 <- tsdf(cbind(fdeaths, mdeaths))
   tmp2 <- ggplot(tmp1, aes(x = x)) +
      geom_line(aes(y = fdeaths)) +
      geom_line(aes(y = mdeaths))
   expect_equal(class(tmp2), c("gg", "ggplot"))
   expect_equal(length(tmp2$layers), 2)
})