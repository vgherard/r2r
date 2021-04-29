#' @export
new_set <- function() {
	s <- new.env(parent = emptyenv(), size = 0L)
	structure(s, class = "set")
}

#' @export
insert <- function(s, key, ...)
	UseMethod("insert", s)

#' @export
insert.set <- function(s, key, ...)
{
	h <- hash(key)
	lst <- s[[h]]
	for (x in lst)
		if (identical(x, key))
			return(key)
	s[[h]] <- c(lst, list(key))
	return(key)
}

#' @export
query <- function(s, key) UseMethod("query", s)

#' @export
query.set <- function(s, key)
{
	lst <- s[[hash(key)]]
	for (x in lst)
		if (identical(x, key))
			return(TRUE)
	return(FALSE)
}
