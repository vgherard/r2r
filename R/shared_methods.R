#------------------------- Extra key/value access opearations -----------------#

#' @export
keys.r2r_hashtable <- function(x)
	mget_all(attr(x, "keys"))



#----------------------------- Property getters/setters -----------------------#

#' @export
hash_fn.r2r_hashtable <- function(x)
	attr(x, "hash_fn")

#' @export
`hash_fn<-.r2r_hashtable` <- function(x, f) {
	attr(x, "hash_fn") <- f
	return(x)
}

#' @export
compare_fn.r2r_hashtable <- function(x)
	attr(x, "compare_fn")

#' @export
`compare_fn<-.r2r_hashtable` <- function(x, f) {
	attr(x, "compare_fn") <- f
	return(x)
}
