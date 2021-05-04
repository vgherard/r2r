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

# Internal constructor for S3 class 'map'
new_hashmap <- function(throw, default, hash, compare, key_preproc) {
	hash_preproc <- function(x)
		hash(key_preproc(x))
	compare_preproc <- function(x, y)
		compare(key_preproc(x), key_preproc(y))
	keys <- new.env(parent = emptyenv(), size = 0L)
	values <- new.env(parent = emptyenv(), size = 0L)
	structure(
		list(),
		keys = keys,
		values = values,
		hash = hash_preproc,
		compare = compare_preproc,
		throw = throw,
		default = default,
		class = c("r2r_hashmap", "r2r_hashtable")
	) # return
}

#' @rdname hashtable
#' @export
hashmap <- function(...,
		throw = FALSE,
		default = NULL,
		hash = default_hash_fn,
		compare = identical,
		key_preproc = identity
		)
{
	m <- new_hashmap(throw, default, hash, compare, key_preproc)
	for (pair in list(...))
		insert(m, pair[[1]], pair[[2]])
	return(m)
}

#' @export
print.r2r_hashmap <- function(x, ...)
{
	cat("An r2r hashmap.")
	return(invisible(x))
}

#' @rdname hashtable_methods
#' @export
insert.r2r_hashmap <- function(x, key, value, ...)
{
	keys <- attr(x, "keys")
	values <- attr(x, "values")
	h <- get_env_key(keys, key, attr(x, "hash"), attr(x, "compare"))
	keys[[h]] <- key
	values[[h]] <- value
}

#' @rdname hashtable_methods
#' @export
delete.r2r_hashmap <- function(x, key, ...)
{
	keys <- attr(x, "keys")
	values <- attr(x, "values")
	h <- get_env_key(keys, key, attr(x, "hash"), attr(x, "compare"))
	keys[[h]] <- values[[h]] <- NULL
}

#' @rdname hashtable_methods
#' @export
query.r2r_hashmap <- function(x, key)
{
	keys <- attr(x, "keys")
	values <- attr(x, "values")
	h <- get_env_key(keys, key, attr(x, "hash"), attr(x, "compare"))
	if (exists(h, envir = keys, inherits = FALSE))
		return(values[[h]])
	else if (attr(x, "throw"))
		stop("key not found")
	else
		return(attr(x, "default"))
}

#' @rdname hashtable_methods
#' @export
length.r2r_hashmap <- function(x) length(attr(x, "keys"))

#' @rdname hashtable_methods
#' @export
has_key.r2r_hashmap <- function(x, key)
{
	keys <- attr(x, "keys")
	h <- get_env_key(keys, key, attr(x, "hash"), attr(x, "compare"))
	!is.null(keys[[h]])
}

#' @rdname hashtable_methods
#' @export
keys.r2r_hashmap <- function(x)
	mget_all(attr(x, "keys"))

#' @rdname hashtable_methods
#' @export
values.r2r_hashmap <- function(x)
	mget_all(attr(x, "values"))

#' @rdname hashtable_methods
#' @export
"[[.r2r_hashmap" <- function(x, i)
	query.map(x, i)

#' @rdname hashtable_methods
#' @export
"[.r2r_hashmap" <- function(x, i)
	lapply(i, function(key) query.map(x, key))

#' @rdname hashtable_methods
#' @export
"[[<-.r2r_hashmap" <- function(x, i, value) {
	insert.map(x, i, value)
	x
}

#' @rdname hashtable_methods
#' @export
"[<-.r2r_hashmap" <- function(x, i, value) {
	lapply(seq_along(i), function(n) `[[<-.map`(x, i[[n]], value[[n]]) )
	x
}
