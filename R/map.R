#' @export
new_map <- function() {
	x <- new.env(parent = emptyenv(), size = 0L)
	structure(x, class = "map")
}

#' @export
insert.map <- function(x, key, value, ...)
{
	h <- hash(key)
	while (!is.null(match <- x[[h]])) {
		if (identical(match[[1]], key)) {
			match[[2]] <- value
			return(match)
		}
		h <- paste0(h, "0")
	}
	x[[h]] <- list(key, value)
	return(x[[h]])
}

#' @export
query.map <- function(x, key)
{
	h <- hash(key)
	while (!is.null(match <- x[[h]])) {
		if (identical(match[[1]], key))
			return(match[[2]])
		h <- paste0(h, "0")
	}
	return(NULL)
}
