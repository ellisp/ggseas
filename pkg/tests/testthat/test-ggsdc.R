
test_that("ggsdc decompose produces a plot with four facets", {
   ap_df <- tsdf(AirPassengers)
   tmp <- ggsdc(ap_df, aes(x = x, y = y), method = "decompose") +
      geom_line() +
      labs(x = "Time", y = "Air Passengers")
   expect_equal(dim(tmp$data), c(576, 3))
   expect_equal(tmp$labels$y, "Air Passengers")
})
   
test_that("ggsdc stl produces a plot with four facets", {
   ap_df <- tsdf(AirPassengers)
   tmp <- ggsdc(ap_df, aes(x = x, y = y), method = "stl", s.window = 7) +
      geom_line() +
      labs(x = "Time", y = "Air Passengers")
   expect_equal(dim(tmp$data), c(576, 3))
   expect_equal(tmp$labels$y, "Air Passengers")
})
