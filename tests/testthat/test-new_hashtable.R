test_that("low-level constructor provides the desired structure", {
	hash_fn <- default_hash_fn
	compare_fn <- identical
	key_preproc_fn <- identity

	t <- new_hashtable(hash_fn, compare_fn, key_preproc_fn)

	expect_s3_class(t, "r2r_hashtable")

	expect_true(is.list(t)) # R object is an empty list
	expect_true(is.environment(attr(t, "keys")))
	expect_true(is.function(attr(t, "hash_fn")))
	expect_true(is.function(attr(t, "compare_fn")))
})

test_that("low-level constructor correctly assigns hash and compare fn's", {
	hash_fn <- default_hash_fn
	compare_fn <- identical
	key_preproc_fn <- Arg

	t <- new_hashtable(hash_fn, compare_fn, key_preproc_fn)

	exp_hash_fn <- function(x)
		hash_fn(key_preproc_fn(x))
	exp_compare_fn <- function(x, y)
		compare_fn(key_preproc_fn(x), key_preproc_fn(y))

	# Fix defining environment of expectations
	environment(exp_hash_fn) <- environment(attr(t, "hash_fn"))
	environment(exp_compare_fn) <- environment(attr(t, "compare_fn"))

	expect_identical(attr(t, "hash_fn"), exp_hash_fn)
	expect_identical(attr(t, "compare_fn"), exp_compare_fn)
})
