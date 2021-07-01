# r2r -- R-Object to R-Object Hash Maps
# Copyright (C) 2021  Valerio Gherardi
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#' @title Insert keys or key/value pairs into an hash table.
#'
#' @author Valerio Gherardi
#'
#' @description These generics are used for inserting a single key or key/value
#' pair into an \code{hashset} or \code{hashmap}, respectively. For vectorized
#' insertions, see the \link[r2r]{subsetting_hashtables} documentation page.
#' @param x an \code{hashset} or \code{hashmap}.
#' @param key an arbitrary R object. Key to be inserted into the hash table.
#' @param ... further arguments passed to or from other methods.
#' @return \code{key} for the \code{hashset} method,
#' \code{value} for the \code{hashmap} method.
#' @examples
#' s <- hashset()
#' insert(s, "foo")
#' s[["foo"]]
#' @name insert
#'
#' @export
insert <- function(x, key, ...)
	UseMethod("insert", x)

#' @title Delete keys or key/value pairs from an hash table.
#'
#' @author Valerio Gherardi
#'
#' @description These generics are used for deleting a single key or key/value
#' pair from an \code{hashset} or \code{hashmap}, respectively.
#' @param x an \code{hashset} or \code{hashmap}.
#' @param key an arbitrary R object. Key to be deleted from the hash table.
#' @return \code{NULL}, invisibly.
#' @examples
#' s <- hashset(1, 2, 3)
#' delete(s, 3)
#' s[[3]]
#' @name delete
#'
#' @export
delete <- function(x, key)
	UseMethod("delete", x)

#' @title Query keys from an hash table.
#'
#' @author Valerio Gherardi
#'
#' @description These generics are used for querying a single key from an
#' \code{hashset} or \code{hashmap}, respectively. For vectorized queries,
#' see the \link[r2r]{subsetting_hashtables} documentation page.
#' @param x an \code{hashset} or \code{hashmap}.
#' @param key an arbitrary R object. Key to be queried from the hash table.
#' @return \code{TRUE} or \code{FALSE}, for \code{hashset}s. For
#' \code{hashmap}s, if the queried key exists in the hash table, returns the
#' associated value (an a priori arbitrary R object); otherwise, behaves as
#' specified by \code{\link{on_missing_key}(x)}
#' (see also \link[r2r]{hashtable}).
#' @examples
#' s <- hashset(1, 2, 3)
#' query(s, 3)
#' @name query
#'
#' @export
query <- function(x, key)
	UseMethod("query", x)

#' @title List all keys from an hash table
#'
#' @author Valerio Gherardi
#'
#' @description These generics are used for listing all keys registered in an
#' \code{hashset} or \code{hashmap}, respectively.
#' @param x an \code{hashset} or \code{hashmap}.
#' @return a list. Registered keys in the hash table \code{x}.
#' @examples
#' s <- hashset(1, 2, 3)
#' keys(s)
#' @name keys
#'
#' @export
keys <- function(x)
	UseMethod("keys", x)

#' @title List all values from an hash map
#'
#' @author Valerio Gherardi
#'
#' @description This function is used to list all values associated to keys in
#' an \code{hashmap}. Implemented as a generic, but currently only the
#' \code{hashmap} method is defined.
#' @param x an \code{hashset} or \code{hashmap}.
#' @return a list. Values associated to keys in the hash map \code{x}.
#' @examples
#' m <- hashmap(list("a", 1), list("b", 2))
#' values(m)
#' @name values
#'
#' @export
values <- function(x)
	UseMethod("values", x)

#' @title Key existence in hash tables
#'
#' @author Valerio Gherardi
#'
#' @description This generics are used to check whether a key exists in a given
#' \code{hashset} or \code{hashmap}.
#' @param x an \code{hashset} or \code{hashmap}.
#' @param key an arbitrary R object. Key to be checked for existence in the
#' hash table.
#' @return \code{TRUE} or \code{FALSE}.
#' @examples
#' m <- hashmap(list("a", 1), list("b", 2))
#' has_key(m, "a")
#' m %has_key% "b"
#' @name has_key
#'
#' @export
has_key <- function(x, key)
	UseMethod("has_key", x)

#' @rdname has_key
#' @export
`%has_key%` <- has_key

#' @title Hash table properties
#'
#' @author Valerio Gherardi
#'
#' @description This generics are used to get and (where allowed) set various
#' properties of \code{hashset} and \code{hashmap} objects.
#' @param x an \code{hashset} or \code{hashmap}.
#' @name hashtable_properties
NULL

#' @title Get hash function of an hash table
#'
#' @author Valerio Gherardi
#'
#' @description Returns the hash function used for key hashing in an hash table
#' (\code{hashset} or \code{hashmap}).
#' @param x an \code{hashset} or \code{hashmap}.
#' @return a function.
#' @examples
#' s <- hashset()
#' hash_fn(s)
#' @name hash_fn
#'
#' @export
hash_fn <- function(x)
	UseMethod("hash_fn", x)

#' @title Get key comparison function of an hash table
#'
#' @author Valerio Gherardi
#'
#' @description Returns the key comparison function of an hash table
#' (\code{hashset} or \code{hashmap}).
#' @param x an \code{hashset} or \code{hashmap}.
#' @return a function.
#' @examples
#' s <- hashset()
#' compare_fn(s)
#' @name compare_fn
#'
#' @export
compare_fn <- function(x)
	UseMethod("compare_fn", x)

#' @title On missing key behaviour
#'
#' @author Valerio Gherardi
#'
#' @description These generics are used to get or set the behaviour of an
#'  \code{hashmap} upon query of a missing key (currently, only an
#'  \code{hashmap} method is implemented).
#' @param x an \code{hashmap}.
#' @return a string, either \code{"throw"} or \code{"default"}.
#' @details For more details, see the \link{hashtable} documentation page.
#' @examples
#' m <- hashmap()
#' on_missing_key(m)
#' on_missing_key(m) <- "throw"
#' @name on_missing_key
#'
#' @export
on_missing_key <- function(x)
	UseMethod("on_missing_key", x)

#' @rdname on_missing_key
#' @param value a string, either \code{"throw"} or \code{"default"}. Action to
#' be taken upon query of a missing key.
#' @export
`on_missing_key<-` <- function(x, value)
	UseMethod("on_missing_key<-", x)

#' @title Default \code{hashmap} values
#'
#' @author Valerio Gherardi
#'
#' @description These generics are used to get or set the default value of an
#'  \code{hashmap}, optionally returned upon query of a missing key.
#' @param x an \code{hashmap}.
#' @return an arbitrary R objec.
#' @details For more details, see the \link{hashtable} documentation page.
#' @examples
#' m <- hashmap()
#' default(m)
#' default(m) <- 840
#' @name default
#'
#' @export
default <- function(x)
	UseMethod("default", x)

#' @rdname default
#' @param value an arbitrary R object. Default value to be associated to missing
#' keys in the \code{hashmap}.
#' @export
`default<-` <- function(x, value)
	UseMethod("default<-", x)
