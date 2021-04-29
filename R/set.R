#' @export
new_set <- function() {
	x <- new.env(parent = emptyenv(), size = 0L)
	structure(x, class = "set")
}

#' @export
insert <- function(x, key, ...)
	UseMethod("insert", x)

#' @export
insert.set <- function(x, key, ...)
{
	h <- hash(key)
	lst <- x[[h]]
	for (el in lst)
		if (identical(el, key))
			return(key)
	x[[h]] <- c(lst, list(key))
	return(key)
}

#' @export
query <- function(x, key) UseMethod("query", x)

#' @export
query.set <- function(x, key)
{
	lst <- x[[hash(key)]]
	for (el in lst)
		if (identical(el, key))
			return(TRUE)
	return(FALSE)
}
