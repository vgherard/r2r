dgst <- digest::getVDigest()
hash <- function(key) {
	if (is.atomic(key) && length(key) == 1L)
		as.character(key)
	else
		dgst(key)
}
