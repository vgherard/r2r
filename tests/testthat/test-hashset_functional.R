test_that("insert/query/delete operations work as expected for simple case", {
	s <- hashset()

	insert(s, "a")
	insert(s, 840)
	insert(s, data.frame())

	expect_identical(query(s, "a"), TRUE)
	expect_identical(query(s, "b"), FALSE)
	expect_identical(query(s, 840), TRUE)
	expect_identical(query(s, "840"), FALSE)
	expect_identical(query(s, data.frame()), TRUE)
	expect_identical(query(s, data.frame(x = 1:10)), FALSE)

	delete(s, "a")
	expect_identical(query(s, "a"), FALSE)
	expect_identical(query(s, 840), TRUE)
	expect_identical(query(s, data.frame()), TRUE)
})

test_that("Non vectorized subsetting works as expected for simple case", {
	s <- hashset()

	s[["a"]] <- TRUE
	s[[840]] <- TRUE
	s[[data.frame()]] <- TRUE

	expect_identical(s[["a"]], TRUE)
	expect_identical(s[["b"]], FALSE)
	expect_identical(s[[840]], TRUE)
	expect_identical(s[["840"]], FALSE)
	expect_identical(s[[data.frame()]], TRUE)
	expect_identical(s[[data.frame(x = 1:10)]], FALSE)

	s[["a"]] <- FALSE
	expect_identical(s[["a"]], FALSE)
	expect_identical(s[[840]], TRUE)
	expect_identical(s[[data.frame()]], TRUE)

	# Throws an error if value is not TRUE or FALSE
	expect_error(s[["b"]] <- 1, class = "r2r_hashset_value_error")
})

test_that("Vectorized subsetting works as expected for simple case", {
	s <- hashset()

	s[ list("a", 840, data.frame()) ] <- c(T, T, T)

	expect_identical(
		s[ list("a", "b", 840, "840", data.frame()) ],
		list(T, F, T, F, T)
	)

	s[ list("a", 840) ] <- c(F, F)
	expect_identical(
		s[ list("a", "b", 840, "840", data.frame()) ],
		list(F, F, F, F, T)
	)
})

test_that("length() returns number of elements in the set", {
	s <- hashset()

	expect_identical(length(s), 0L)

	insert(s, "a"); insert(s, "b"); insert(s, "c")
	expect_identical(length(s), 3L)

	delete(s, "c")
	expect_identical(length(s), 2L)
})

test_that("print methods return the hashset itself, invisibly", {
	s <- hashset()

	capture_output(
	for (fn in list(print, summary, str)) {
		o <-  expect_invisible(fn(s))
		expect_identical(o, s)
	})

})


