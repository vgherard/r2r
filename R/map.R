#' @export
new_map <- function() {
	x <- new.env(parent = emptyenv(), size = 0L)
	structure(x, class = "map")
}

#' @export
insert.map <- function(x, key, value, ...)
{
	h <- hash(key)
	lst <- x[[h]]
	for (el in lst)
		if (identical(el[[1]], key))
			return(el[[2]])
	x[[h]] <- c(lst, list(list(key, value)))
	return(key)
}

#' @export
query.map <- function(x, key)
{
	lst <- x[[hash(key)]]
	for (el in lst)
		if (identical(el[[1]], key))
			return(el[[2]])
	return(NULL)
}
