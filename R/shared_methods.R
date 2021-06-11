#------------------------------- Size of hash-table ---------------------------#

#' @title Size of hash tables
#'
#' @author Valerio Gherardi
#'
#' @description Returns the total number of keys in an hash table.
#' @param x an \code{hashset} or \code{hashmap}.
#' @param key an arbitrary R object. Key to be inserted into the hash table.
#' @param ... further arguments passed to or from other methods.
#' @return an integer. Number of keys in the hash table (or elements in a set).
#' @example
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

#' @rdname hashtable_properties
#' @export
hash_fn.r2r_hashtable <- function(x)
	attr(x, "hash_fn")

#' @rdname hashtable_properties
#' @export
compare_fn.r2r_hashtable <- function(x)
	attr(x, "compare_fn")
