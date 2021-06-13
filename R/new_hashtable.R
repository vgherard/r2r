new_hashtable <- function(hash_fn, compare_fn, key_preproc_fn) {
	hash_fn_preproc <- function(x)
		hash_fn(key_preproc_fn(x))
	compare_fn_preproc <- function(x, y)
		compare_fn(key_preproc_fn(x), key_preproc_fn(y))
	keys <- new.env(parent = emptyenv(), size = 0L)
	structure(list(),
		  keys = keys,
		  hash_fn = hash_fn_preproc,
		  compare_fn = compare_fn_preproc,
		  class = "r2r_hashtable"
	)
}
