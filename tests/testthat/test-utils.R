test_that("mget_all() returns a list with every R object in an environment", {
	  env <- new.env()
	  env[["a"]] <- a <- 1:10
	  env[["b"]] <- b <- data.frame()
	  env[["c"]] <- c <- "A string"

	  expect_identical(mget_all(env), list(a,b,c))
})
