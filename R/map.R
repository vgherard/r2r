new_map <- function(throw, default) {
	keys <- new.env(parent = emptyenv(), size = 0L)
	values <- new.env(parent = emptyenv(), size = 0L)
	structure(
		list(),
		keys = keys,
		values = values,
		throw = throw,
		default = default,
		class = "map"
		) # return
}

#' @export
map <- function(..., throw = FALSE, default = NULL)
{
	m <- new_map(throw, default)
	for (pair in list(...))
		insert(m, pair[[1]], pair[[2]])
	return(m)
}

#' @export
insert.map <- function(x, key, value, ...)
{
	keys <- attr(x, "keys")
	values <- attr(x, "values")
	h <- get_env_key(keys, key)
	keys[[h]] <- key
	values[[h]] <- value
}

#' @export
delete.map <- function(x, key, ...)
{
	keys <- attr(x, "keys")
	values <- attr(x, "values")
	h <- get_env_key(keys, key)
	keys[[h]] <- values[[h]] <- NULL
}


#' @export
query.map <- function(x, key)
{
	keys <- attr(x, "keys")
	values <- attr(x, "values")
	h <- get_env_key(keys, key)
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
	h <- get_env_key(keys, key)
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

