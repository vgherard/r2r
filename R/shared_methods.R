#------------------------------- Size of hash-table ---------------------------#

#' @title Size of hash tables
#'
#' @author Valerio Gherardi
#'
#' @description Returns the total number of keys in an hash table.
#' @param x an \code{hashset} or \code{hashmap}.
#' @return an integer. Number of keys in the hash table (or elements in a set).
#' @examples
#' s <- hashset()
#' insert(s, "foo")
#' length(s)
#' @export
length.r2r_hashtable <- function(x) length(attr(x, "keys"))




#------------------------- Extra key/value access opearations -----------------#

#' @rdname keys
#' @export
keys.r2r_hashtable <- function(x)
	mget_all(attr(x, "keys"))



#----------------------------- Property getters/setters -----------------------#

#' @rdname hash_fn
#' @export
hash_fn.r2r_hashtable <- function(x)
	attr(x, "hash_fn")

#' @rdname compare_fn
#' @export
compare_fn.r2r_hashtable <- function(x)
	attr(x, "compare_fn")
