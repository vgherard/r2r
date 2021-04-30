#' @export
insert <- function(x, key, ...)
	UseMethod("insert", x)

#' @export
query <- function(x, key)
	UseMethod("query", x)

#' @export
delete <- function(x, key)
	UseMethod("delete", x)

#' @export
has_key <- function(x, key)
	UseMethod("has_key", x)

#' @export
keys <- function(x)
	UseMethod("keys", x)

#' @export
values <- function(x)
	UseMethod("values", x)

#' @export
`%has_key%` <- has_key
