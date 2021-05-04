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

new_set <- function(hash, compare, key_preproc) {
	hash_preproc <- function(x)
		hash(key_preproc(x))
	compare_preproc <- function(x, y)
		compare(key_preproc(x), key_preproc(y))
	keys <- new.env(parent = emptyenv(), size = 0L)
	structure(list(),
		  keys = keys,
		  hash = hash_preproc,
		  compare = compare_preproc,
		  class = "set"
		  )
}

#' @rdname hash_table
#' @export
hashset <- function(...,
		hash = default_hash_fn,
		compare = identical,
		key_preproc = identity
		)
{
	s <- new_set(hash, compare, key_preproc)
	for (key in list(...))
		insert(s, key)
	return(s)
}

#' @export
insert.set <- function(x, key, ...)
{
	keys <- attr(x, "keys")
	h <- get_env_key(keys, key, attr(x, "hash"), attr(x, "compare"))
	keys[[h]] <- key
}

#' @export
delete.set <- function(x, key, ...)
{
	keys <- attr(x, "keys")
	h <- get_env_key(keys, key, attr(x, "hash"), attr(x, "compare"))
	keys[[h]] <- NULL
}

#' @export
query.set <- function(x, key) {
	keys <- attr(x, "keys")
	h <- get_env_key(keys, key, attr(x, "hash"), attr(x, "compare"))
	!is.null(keys[[h]])
}

#' @export
length.set <- function(x) length(attr(x, "keys"))

#' @export
has_key.set <- query.set

#' @export
keys.set <- function(x)
	mget_all(attr(x, "keys"))

#' @export
"[[.set" <- function(x, i)
	query.set(x, i)

#' @export
"[.set" <- function(x, i)
	lapply(i, function(key) query.set(x, key))

#' @export
"[[<-.set" <- function(x, i, value) {
	if (value == TRUE)
		insert.set(x, i)
	else if (value == FALSE)
		delete.set(x, i)
	else
		stop("'value' must be either TRUE or FALSE.")
	x
}

#' @export
"[<-.set" <- function(x, i, value) {
	lapply(seq_along(i), function(n) `[[<-.set`(x, i[[n]], value[[n]]) )
	return(x)
}


