#' @title Hash maps and sets
#'
#' @author Valerio Gherardi
#'
#' @description Objects of class \code{hashmap} and \code{hashset} store
#' collections of key/value pairs (\code{hashmap}), or just keys
#' (\code{hashset}), providing constant time read and write operations. Both
#' the keys and the optional values can be arbitrary R objects. \code{hashmap}s
#' and \code{hashset}s provide an R implementation of
#' \href{https://en.wikipedia.org/wiki/Hash_table}{hash tables}.
#'
#' See \link[r2r]{hashtable_methods} for the list of available methods for
#' \code{hashmap} and \code{hashset} class objects.
#'
#' @param ... these arguments can be used to specify a set of initial elements
#' to be inserted in the \code{hashmap} or \code{hashset}. For \code{hashmap()},
#' each of these should be a \code{list} of two elements (a key-value pair).
#' @param hash the (string valued) hash function applied to keys. Required for
#' advanced use only; see Details.
#' @param compare the (boolean valued) comparison function used for testing key
#' equality. Required for advanced use only; see Details.
#' @param key_preproc key pre-processing function applied to keys before hashing
#' and comparison. Required for advanced use only; see Details.
#' @param throw \code{TRUE} or \code{FALSE}. If \code{TRUE}, an exception is
#' thrown upon query of a missing key; otherwise, a default value (specified
#' through the \code{default} argument) is returned.
#' @param default default value associated with missing keys. This will be
#' returned only if \code{throw} is \code{FALSE}.
#'
#' @return a \code{hashmap} and a \code{hashset} class object for
#' \code{hashmap()} and \code{hashset()}, respectively.
#'
#' @details \code{hashmap}s and \code{hashset}s implement hash tables,
#' building on top of base R built-in \code{\link[base]{environment}}s,
#' which by themselves are, essentially, string -> R object hash maps.
#' In order to handle keys of non-string type, a string valued hash function
#' \code{\link[r2r]{default_hash_fn}()} is provided, which leverages on
#' \code{\link[digest]{digest}()} for handling arbitrary R object keys.
#'
#' By default, key equality is tested through \code{\link[base]{identical}()}.
#' For some use cases, it may be sensible to employ a different comparison
#' function, which can be assigned through the \code{compare} argument. In this
#' case, one must also make sure that equal (in the sense of \code{compare()})
#' keys get also assigned the same hashes by \code{hash()}. A simple way to
#' ensure this is to use to use a key pre-processing function, to be applied
#' before both key hashing \emph{and} comparison. The \code{key_preproc}
#' argument provides a short-cut to this, by automatically composing both the
#' provided \code{hash()} and \code{compare()} functions with
#' \code{key_preproc()} function. This is illustrated in an example below.
#'
#' One might also want to set set specific hash and/or key comparison functions
#' for efficiency reasons, e.g. if the \code{default_hash_fn()} function produces
#' many collisions between inequivalent keys.
#'
#' When \code{throw} is \code{TRUE}, querying a missing key will cause an error.
#' In this case, an \link[rlang]{rlang} condition of class
#' \code{"r2r_missing_key"} is returned, which can be useful for testing
#' purposes.
#'
#' @examples
#' m <- map(
#'         list("foo", 1),
#'         list("bar", 1:5),
#'         list(data.frame(x = letters, y = LETTERS), "baz")
#'         )
#' m[[ data.frame(x = letters, y = LETTERS) ]]
#'
#' # Set of character keys, case insensitive.
#' m <- set("A", "B", "C", key_preproc = tolower)
#' m[["a"]]
#'
#' @seealso \link[r2r]{hashtable_methods}
#' @name hashtable
NULL

#' @title Methods for S3 classes \code{map} and \code{set}
#'
#' @author Valerio Gherardi
#'
#' @description
#'
#' @name hashtable_methods
NULL
