test_that("mget_all() returns a list with every R object in an environment", {
	  env <- new.env()
	  env[["a"]] <- a <- 1:10
	  env[["b"]] <- b <- data.frame()
	  env[["c"]] <- c <- "A string"

	  expect_identical(mget_all(env), list(a,b,c))
})

test_that("[-argument validators throw errors on invalid cases", {
	# No errors
	expect_error(`validate_[_arg`(1:10), NA)
	expect_error(`validate_[_arg`(list("a", "b", "c")), NA)
	# Errors
	cls <- "r2r_domain_error"
	expect_error(`validate_[_arg`(new.env()), class = cls)
	expect_error(`validate_[_arg`(function(x) x), class = cls)
	expect_error(`validate_[<-_args`(1:3, c("a", "b")), class = cls)
})
