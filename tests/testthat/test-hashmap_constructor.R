test_that("low-level constructor returns the expected structure", {
	hash_fn <- default_hash_fn
	compare_fn <- identical
	key_preproc_fn <- identity
	on_missing_key <- "default"
	default <- 0L

	m <- new_hashmap(
		hash_fn, compare_fn, key_preproc_fn, on_missing_key, default
		)

	expect_s3_class(m, c("r2r_hashmap", "r2r_hashtable"), exact = TRUE)

	expect_true(is.environment(attr(m, "values")))
	expect_true(is.logical(attr(m, "throw")))
	expect_true("default" %in% names(attributes(m)))
})


test_that("validator catches some invalid arguments", {
	hash_fn <- default_hash_fn
	compare_fn <- identical
	key_preproc_fn <- identity
	on_missing_key <- "default"
	a_pair <- list(1, 2)

	# Valid arguments
	expect_error(
		validate_hashmap_args(a_pair,
				      hash_fn = hash_fn,
				      compare_fn = compare_fn,
				      key_preproc_fn = key_preproc_fn,
				      on_missing_key = on_missing_key
		),
		NA
	)

	# Invalid ellipses
	not_a_list <- 1
	not_a_pair <- list(1)
	for (invalid_dots in list(not_a_list, not_a_pair))
		expect_error(
			validate_hashmap_args(
				invalid_dots,
				hash_fn = hash_fn,
				compare_fn = compare_fn,
				key_preproc_fn = key_preproc_fn,
				on_missing_key = on_missing_key
				),
			class = "r2r_domain_error"
			)

	# Invalid on_missing_key
	for (invalid_on_missing_key in list("do what you want", 840))
		expect_error(
			validate_hashmap_args(
				a_pair,
				hash_fn = hash_fn,
				compare_fn = compare_fn,
				key_preproc_fn = key_preproc_fn,
				on_missing_key = invalid_on_missing_key
				),
			class = "r2r_domain_error"
			)
})

test_that("user-level constructor throws no error with default arguments", {
	expect_error(hashmap(), NA)
})

test_that("user-level constructor throws no error with ellipsis arguments", {
	expect_error(hashmap(list(1, "hello"), list(data.frame(), 5)), NA)
})

test_that("user-level and low-level constructor outputs agree (simple case)", {
	# Test with default arguments
	m <- hashmap()
	r <- new_hashmap(
		default_hash_fn,
		identical,
		identity,
		"default",
		NULL
		)

	# Fix for irrelevant differences
	attr(r, "keys") <- attr(m, "keys")
	attr(r, "values") <- attr(m, "values")
	environment(attr(r, "hash_fn")) <- environment(attr(m, "hash_fn"))
	environment(attr(r, "compare_fn")) <- environment(attr(m, "compare_fn"))

	expect_identical(m, r)
})

test_that("user-level and low-level constructor outputs agree (complex case)", {
	# Test with custom arguments
	on_missing_key <- "throw"
	default <- 840
	m <- hashmap(on_missing_key = on_missing_key, default = default)
	r <- new_hashmap(
		default_hash_fn,
		identical,
		identity,
		"throw",
		default
	)

	# Fix for irrelevant differences
	attr(r, "keys") <- attr(m, "keys")
	attr(r, "values") <- attr(m, "values")
	environment(attr(r, "hash_fn")) <- environment(attr(m, "hash_fn"))
	environment(attr(r, "compare_fn")) <- environment(attr(m, "compare_fn"))

	expect_identical(m, r)
})
