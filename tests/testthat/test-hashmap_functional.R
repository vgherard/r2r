test_that("insert/query/delete operations work as expected for simple case", {
	m <- hashmap()

	insert(m, "a", "letter")
	insert(m, 840, "number")
	insert(m, data.frame(), "data")

	expect_identical(query(m, "a"), "letter")
	expect_identical(query(m, "b"), NULL)
	expect_identical(query(m, 840), "number")
	expect_identical(query(m, "840"), NULL)
	expect_identical(query(m, data.frame()), "data")
	expect_identical(query(m, data.frame(x = 1:10)), NULL)
	expect_true(has_key(m, "a"))

	delete(m, "a")
	expect_false(has_key(m, "a"))
	expect_identical(query(m, "a"), NULL)
	expect_identical(query(m, 840), "number")
	expect_identical(query(m, data.frame()), "data")
})

test_that("Non vectorized subsetting works as expected for simple case", {
	m <- hashmap()

	m[["a"]] <- "letter"
	m[[840]] <- "number"
	m[[data.frame()]] <- "data"

	expect_identical(m[["a"]], "letter")
	expect_identical(m[["b"]], NULL)
	expect_identical(m[[840]], "number")
	expect_identical(m[["840"]], NULL)
	expect_identical(m[[data.frame()]], "data")
	expect_identical(m[[data.frame(x = 1:10)]], NULL)
})

test_that("Vectorized subsetting works as expected for simple case", {
	m <- hashmap()

	m[ list("a", 840, data.frame()) ] <- c("letter", "number", "data")

	expect_identical(
		m[ list("a", "b", 840, "840", data.frame()) ],
		list("letter", NULL, "number", NULL, "data")
	)

})

test_that("length() returns number of elements in the map", {
	m <- hashmap()

	expect_identical(length(m), 0L)

	insert(m, "a", 1); insert(m, "b", 2); insert(m, "c", 3)
	expect_identical(length(m), 3L)

	delete(m, "c")
	expect_identical(length(m), 2L)
})

test_that("print methods return the hashnap itself, invisibly", {
	m <- hashmap()

	capture_output(
		for (fn in list(print, summary, str)) {
			o <-  expect_invisible(fn(m))
			expect_identical(o, m)
		})

})

test_that("customizing missing key behaviour works as expected in simple case",
{
	m <- hashmap()

	expect_identical(on_missing_key(m), "default")

	expect_error(
		on_missing_key(m) <- TRUE, class = "r2r_domain_error"
		)

	expect_error(
		on_missing_key(m) <- "throw", NA
	)

	expect_identical(on_missing_key(m), "throw")

	expect_error(m[[1]], class = "r2r_missing_key")

})

test_that("setting a custom default value works as expected", {
	m <- hashmap()
	x <- 840841842
	default(m) <- x
	expect_identical(default(m), x)
	expect_identical(m[[1]], x)
})
