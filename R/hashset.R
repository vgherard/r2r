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
		  class = c("r2r_hashmap", "r2r_hashtable")
		  )
}

#' @rdname hashtable
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
print.r2r_hashset <- function(x, ...)
{
	cat("An r2r hashset.")
	return(invisible(x))
}

#' @export
insert.r2r_hashset <- function(x, key, ...)
{
	keys <- attr(x, "keys")
	h <- get_env_key(keys, key, attr(x, "hash"), attr(x, "compare"))
	keys[[h]] <- key
}

#' @export
delete.r2r_hashset <- function(x, key, ...)
{
	keys <- attr(x, "keys")
	h <- get_env_key(keys, key, attr(x, "hash"), attr(x, "compare"))
	keys[[h]] <- NULL
}

#' @export
query.r2r_hashset <- function(x, key) {
	keys <- attr(x, "keys")
	h <- get_env_key(keys, key, attr(x, "hash"), attr(x, "compare"))
	!is.null(keys[[h]])
}

#' @export
length.r2r_hashset <- function(x) length(attr(x, "keys"))

#' @export
has_key.r2r_hashset <- query.r2r_hashset

#' @export
keys.r2r_hashset <- function(x)
	mget_all(attr(x, "keys"))

#' @export
"[[.r2r_hashset" <- function(x, i)
	query.r2r_hashset(x, i)

#' @export
"[.r2r_hashset" <- function(x, i)
	lapply(i, function(key) query.r2r_hashset(x, key))

#' @export
"[[<-.r2r_hashset" <- function(x, i, value) {
	if (value == TRUE)
		insert.r2r_hashset(x, i)
	else if (value == FALSE)
		delete.r2r_hashset(x, i)
	else
		stop("'value' must be either TRUE or FALSE.")
	x
}

#' @export
"[<-.r2r_hashset" <- function(x, i, value) {
	lapply(seq_along(i), function(n) `[[<-.set`(x, i[[n]], value[[n]]) )
	return(x)
}


