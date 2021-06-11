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



#------------------------------ Internal constructor --------------------------#

new_hashmap <- function(
	on_missing_key, default, hash_fn, compare_fn, key_preproc_fn
	)
{
	throw <- ifelse(on_missing_key[[1]] == "default", FALSE, TRUE)
	hash_fn_preproc <- function(x)
		hash_fn(key_preproc_fn(x))
	compare_fn_preproc <- function(x, y)
		compare_fn(key_preproc_fn(x), key_preproc_fn(y))
	keys <- new.env(parent = emptyenv(), size = 0L)
	values <- new.env(parent = emptyenv(), size = 0L)
	structure(
		list(),
		keys = keys,
		values = values,
		hash_fn = hash_fn_preproc,
		compare_fn = compare_fn_preproc,
		throw = throw,
		default = default,
		class = c("r2r_hashmap", "r2r_hashtable")
	) # return
}



#--------------------------------- Constructor --------------------------------#

#' @rdname hashtable
#' @export
hashmap <- function(...,
		on_missing_key = c("default", "throw"),
		default = NULL,
		hash_fn = default_hash_fn,
		compare_fn = identical,
		key_preproc_fn = identity
		)
{
	m <- new_hashmap(
		on_missing_key, default, hash_fn, compare_fn, key_preproc_fn
		)
	for (pair in list(...))
		insert(m, pair[[1]], pair[[2]])
	return(m)
}



#----------------------------- Basic R/W operations ---------------------------#

#' @rdname insert
#' @param value an arbitrary R object. Value associated to \code{key}.
#' @export
insert.r2r_hashmap <- function(x, key, value, ...)
{
	keys <- attr(x, "keys")
	values <- attr(x, "values")
	h <- get_env_key(keys, key, attr(x, "hash_fn"), attr(x, "compare_fn"))
	keys[[h]] <- key
	values[[h]] <- value
}

#' @rdname delete
#' @export
delete.r2r_hashmap <- function(x, key)
{
	keys <- attr(x, "keys")
	values <- attr(x, "values")
	h <- get_env_key(keys, key, attr(x, "hash_fn"), attr(x, "compare_fn"))
	if (exists(h, envir = keys, inherits = FALSE)) {
		rm(list = h, envir = keys)
		rm(list = h, envir = values)
	}
	return(invisible(NULL))
}

#' @export
query.r2r_hashmap <- function(x, key)
{
	keys <- attr(x, "keys")
	values <- attr(x, "values")
	h <- get_env_key(keys, key, attr(x, "hash_fn"), attr(x, "compare_fn"))
	if (exists(h, envir = keys, inherits = FALSE))
		return(values[[h]])
	else if (attr(x, "throw"))
		rlang::abort("Key not found", class = "r2r_missing_key")
	else
		return(attr(x, "default"))
}



#------------------------------ Subsetting methods ----------------------------#

#' @export
"[[.r2r_hashmap" <- function(x, i)
	query.r2r_hashmap(x, i)

#' @export
"[.r2r_hashmap" <- function(x, i)
	lapply(i, function(key) query.r2r_hashmap(x, key))

#' @export
"[[<-.r2r_hashmap" <- function(x, i, value) {
	insert.r2r_hashmap(x, i, value)
	x
}

#' @export
"[<-.r2r_hashmap" <- function(x, i, value) {
	lapply(seq_along(i),
	       function(n) `[[<-.r2r_hashmap`(x, i[[n]], value[[n]])
	       )
	x
}

#------------------------- Extra key/value access opearations -----------------#

#' @rdname values
#' @export
values.r2r_hashmap <- function(x)
	mget_all(attr(x, "values"))

#' @export
has_key.r2r_hashmap <- function(x, key)
{
	keys <- attr(x, "keys")
	h <- get_env_key(keys, key, attr(x, "hash_fn"), attr(x, "compare_fn"))
	!is.null(keys[[h]])
}



#----------------------------- Property getters/setters -----------------------#

#' @rdname hashtable_properties
#' @export
on_missing_key.r2r_hashmap <- function(x)
	if (attr(x, "throw")) "throw" else "default"

#' @rdname hashtable_properties
#' @export
`on_missing_key<-.r2r_hashmap` <- function(x, action)
{
	if (identical(action, "throw"))
		attr(x, "throw") <- TRUE
	else if (identical(action, "default"))
		attr(x, "throw") <- FALSE
	else {
		msg <- "'action' must be either \"throw\" or \"default\""
		rlang::abort(msg, class = "r2r_domain_error")
	}
	return(x)
}

#' @rdname hashtable_properties
#' @export
default.r2r_hashmap <- function(x)
	attr(x, "default")

#' @rdname hashtable_properties
#' @export
`default<-.r2r_hashmap` <- function(x, value) {
	attr(x, "default") <- value
	return(x)
}




#---------------------------------- Print methods -----------------------------#

#' @export
print.r2r_hashmap <- function(x, ...)
{
	cat("An r2r hashmap.")
	return(invisible(x))
}

#' @export
summary.r2r_hashmap <- print.r2r_hashmap

#' @export
str.r2r_hashmap <- print.r2r_hashmap
