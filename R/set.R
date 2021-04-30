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
	while (!is.null(match <- x[[h]])) {
		if (identical(match, key))
			return(key)
		h <- paste0(h, "0")
	}
	x[[h]] <- key
	return(key)
}

#' @export
query <- function(x, key) UseMethod("query", x)

#' @export
query.set <- function(x, key)
{
	h <- hash(key)
	while (!is.null(match <- x[[h]])) {
		if (identical(match, key))
			return(TRUE)
		h <- paste0(h, "0")
	}
	return(FALSE)
}
