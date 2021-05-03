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

new_map <- function(hash, compare, throw, default) {
	keys <- new.env(parent = emptyenv(), size = 0L)
	values <- new.env(parent = emptyenv(), size = 0L)
	structure(
		list(),
		keys = keys,
		values = values,
		hash = hash,
		compare = compare,
		throw = throw,
		default = default,
		class = "map"
		) # return
}

#' @export
map <- function(...,
		hash = default_hash,
		compare = identical,
		throw = FALSE,
		default = NULL
		)
{
	m <- new_map(hash, compare, throw, default)
	for (pair in list(...))
		insert(m, pair[[1]], pair[[2]])
	return(m)
}

#' @export
insert.map <- function(x, key, value, ...)
{
	keys <- attr(x, "keys")
	values <- attr(x, "values")
	h <- get_env_key(keys, key, attr(x, "hash"), attr(x, "compare"))
	keys[[h]] <- key
	values[[h]] <- value
}

#' @export
delete.map <- function(x, key, ...)
{
	keys <- attr(x, "keys")
	values <- attr(x, "values")
	h <- get_env_key(keys, key, attr(x, "hash"), attr(x, "compare"))
	keys[[h]] <- values[[h]] <- NULL
}


#' @export
query.map <- function(x, key)
{
	keys <- attr(x, "keys")
	values <- attr(x, "values")
	h <- get_env_key(keys, key, attr(x, "hash"), attr(x, "compare"))
	if (!is.null(keys[[h]]))
		return(values[[h]])
	else if (attr(x, "throw"))
		stop("key not found")
	else
		return(attr(x, "default"))
}

#' @export
length.map <- function(x) length(attr(x, "keys"))

#' @export
has_key.map <- function(x, key)
{
	keys <- attr(x, "keys")
	h <- get_env_key(keys, key, attr(x, "hash"), attr(x, "compare"))
	!is.null(keys[[h]])
}

#' @export
keys.map <- function(x)
	mget_all(attr(x, "keys"))

#' @export
values.map <- function(x)
	mget_all(attr(x, "values"))

#' @export
"[[.map" <- function(x, i)
	query.map(x, i)

#' @export
"[.map" <- function(x, i)
	lapply(i, function(key) query.map(x, key))

#' @export
"[[<-.map" <- function(x, i, value) {
	insert.map(x, i, value)
	x
}

#' @export
"[<-.map" <- function(x, i, value) {
	lapply(seq_along(i), function(n) `[[<-.map`(x, i[[n]], value[[n]]) )
	x
}

