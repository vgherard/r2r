test_that("low-level constructor returns the expected structure", {
	hash_fn <- default_hash_fn
	compare_fn <- identical
	key_preproc_fn <- identity

	s <- new_hashset(hash_fn, compare_fn, key_preproc_fn)

	expect_s3_class(s, c("r2r_hashset", "r2r_hashtable"), exact = TRUE)
})

test_that("low-level constructor correctly assigns hash and compare fn's", {
	hash_fn <- default_hash_fn
	compare_fn <- identical
	key_preproc_fn <- Arg

	s <- new_hashset(hash_fn, compare_fn, key_preproc_fn)

	exp_hash_fn <- function(x)
		hash_fn(key_preproc_fn(x))
	exp_compare_fn <- function(x, y)
		compare_fn(key_preproc_fn(x), key_preproc_fn(y))

	# Fix defining environment of expectations
	environment(exp_hash_fn) <- environment(attr(s, "hash_fn"))
	environment(exp_compare_fn) <- environment(attr(s, "compare_fn"))

	expect_identical(attr(s, "hash_fn"), exp_hash_fn)
	expect_identical(attr(s, "compare_fn"), exp_compare_fn)
})

test_that("validator catches some invalid arguments", {
	hash_fn <- default_hash_fn
	compare_fn <- identical
	key_preproc_fn <- identity

	# Valid arguments
	expect_error(
		validate_hashset_args(hash_fn, compare_fn, key_preproc_fn),
		NA
		)

	# Invalid hash_fn
	expect_error(
		validate_hashset_args(data.frame(), compare_fn, key_preproc_fn),
		class = "r2r_domain_error"
	)

	# Invalid compare_fn
	expect_error(
		validate_hashset_args(hash_fn, 840L, key_preproc_fn),
		class = "r2r_domain_error"
	)

	# key_preproc_fn
	expect_error(
		validate_hashset_args(hash_fn, compare_fn, "840"),
		class = "r2r_domain_error"
	)
})

test_that("user-level constructor throws no error with default arguments", {
	expect_error(hashset(), NA)
})

test_that("user-level constructor throws no error with ellipsis arguments", {
	expect_error(hashset(1, "hello", data.frame()), NA)
})

test_that("user-level and low-level constructor outputs agree (simple case)", {
	# Test with default arguments
	s <- hashset()
	r <- new_hashset(default_hash_fn, identical, identity)

	# Fix for irrelevant differences
	attr(r, "keys") <- attr(s, "keys")
	environment(attr(r, "hash_fn")) <- environment(attr(s, "hash_fn"))
	environment(attr(r, "compare_fn")) <- environment(attr(s, "compare_fn"))

	expect_identical(s, r)
})

test_that("user-level and low-level constructor outputs agree (complex case)", {
	# Test with custom arguments
	hash_fn <- identity
	compare_fn <- `==`
	key_preproc_fn <- tolower
	s <- hashset(
		hash_fn = hash_fn,
		compare_fn = compare_fn,
		key_preproc_fn = key_preproc_fn
		)
	r <- new_hashset(hash_fn, compare_fn, key_preproc_fn)

	# Fix for irrelevant differences
	attr(r, "keys") <- attr(s, "keys")
	environment(attr(r, "hash_fn")) <- environment(attr(s, "hash_fn"))
	environment(attr(r, "compare_fn")) <- environment(attr(s, "compare_fn"))

	expect_identical(s, r)
})
