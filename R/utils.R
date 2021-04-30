mget_all <- function(env)
{
	names <- ls(envir = env, all.names = TRUE, sorted = FALSE)
	res <- mget(names, envir = env, inherits = FALSE)
	names(res) <- NULL
	return(res)
}
