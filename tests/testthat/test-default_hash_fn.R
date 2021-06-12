test_that("output are length one characters for some inputs", {
	inputs <- list(
		1, 1:10, list("a", TRUE, 3i), list(list(list()))
	)
	for (input in inputs) {
		output <- default_hash_fn(input)
		expect_vector(output, ptype = character(), size = 1L)
	}
})

test_that("is equivalent to as.character() for atomic length-one input", {
	inputs <- list(1L, 1, "1", 1i, TRUE, raw(1L))
	for (input in inputs)
		expect_identical(default_hash_fn(input), as.character(input))
})
