dgst <- digest::getVDigest()

hash <- function(key) {
	if (is.atomic(key) && length(key) == 1L)
		as.character(key)
	else
		dgst(key)
}

#' Utility for collision handling
#' @param env an environment.
#' @param key an arbitrary R object.
#' @return a character of length one. Either an hash \code{h} of the input key,
#' such that \code{identical(env[[h]], key)} is \code{TRUE}, or a name which is
#' unbind in \code{env}, if no match is found.
get_env_key <- function(env, key, compare)
{
h <- hash(key)
	while (!is.null(match <- env[[h]])) {
		if (compare(match, key))
			return(h)
		h <- paste0(h, "0")
	}
	return(h)
}
