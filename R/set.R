new_set <- function(compare) {
	keys <- new.env(parent = emptyenv(), size = 0L)
	structure(list(), keys = keys, compare = compare, class = "set")
}

#' @export
set <- function(..., compare = identical)
{
	s <- new_set(compare)
	for (key in list(...))
		insert(s, key)
	return(s)
}

#' @export
insert.set <- function(x, key, ...)
{
	keys <- attr(x, "keys")
	h <- get_env_key(keys, key, attr(x, "compare"))
	keys[[h]] <- key
}

#' @export
delete.set <- function(x, key, ...)
{
	keys <- attr(x, "keys")
	h <- get_env_key(keys, key, attr(x, "compare"))
	keys[[h]] <- NULL
}

#' @export
query.set <- function(x, key) {
	keys <- attr(x, "keys")
	h <- get_env_key(keys, key, attr(x, "compare"))
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


