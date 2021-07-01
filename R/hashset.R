# r2r -- R-Object to R-Object Hash Maps
# Copyright (C) 2021  Valerio Gherardi
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.



#------------------------------ Internal constructor --------------------------#

new_hashset <- function(hash_fn, compare_fn, key_preproc_fn) {
	res <- new_hashtable(hash_fn, compare_fn, key_preproc_fn)
	class(res) <- c("r2r_hashset", class(res))
	return(res)
}


#--------------------------------- Constructor --------------------------------#

#' @rdname hashtable
#' @export
hashset <- function(...,
		    hash_fn = default_hash_fn,
		    compare_fn = identical,
		    key_preproc_fn = identity
		    )
{
	validate_hashset_args(hash_fn, compare_fn, key_preproc_fn)
	s <- new_hashset(hash_fn, compare_fn, key_preproc_fn)
	for (key in list(...))
		insert(s, key)
	return(s)
}

validate_hashset_args <- function(hash_fn, compare_fn, key_preproc_fn)
{
	msg <- NULL

	if (!is.function(hash_fn))
		msg <- "'hash_fn' must be a function."
	else if (!is.function(compare_fn))
		msg <- "'compare_fn' must be a function."
	else if (!is.function(key_preproc_fn))
		msg <- "'key_preproc_fn' must be a function."

	if (!is.null(msg))
		rlang::abort(msg, class = "r2r_domain_error")
}



#----------------------------- Basic R/W operations ---------------------------#

#' @rdname insert
#' @export
insert.r2r_hashset <- function(x, key, ...)
{
	keys <- attr(x, "keys")
	h <- get_env_key(keys, key, attr(x, "hash_fn"), attr(x, "compare_fn"))
	keys[[h]] <- key
}

#' @rdname delete
#' @export
delete.r2r_hashset <- function(x, key)
{
	keys <- attr(x, "keys")
	h <- get_env_key(keys, key, attr(x, "hash_fn"), attr(x, "compare_fn"))
	if (exists(h, envir = keys, inherits = FALSE))
		rm(list = h, envir = keys)
	return(invisible(NULL))
}

#' @rdname query
#' @export
query.r2r_hashset <- function(x, key) {
	keys <- attr(x, "keys")
	h <- get_env_key(keys, key, attr(x, "hash_fn"), attr(x, "compare_fn"))
	exists(h, envir = keys, inherits = FALSE)
}



#------------------------------ Subsetting methods ----------------------------#

#' @rdname subsetting_hashtables
#' @export
"[[.r2r_hashset" <- function(x, i)
	query.r2r_hashset(x, i)

#' @rdname subsetting_hashtables
#' @export
"[.r2r_hashset" <- function(x, i)
{
	`validate_[_arg`(i)
	lapply(i, function(key) query.r2r_hashset(x, key))
}


#' @rdname subsetting_hashtables
#' @export
"[[<-.r2r_hashset" <- function(x, i, value) {
	if (identical(value, TRUE))
		insert.r2r_hashset(x, i)
	else if (identical(value, FALSE))
		delete.r2r_hashset(x, i)
	else
		rlang::abort("'value' must be either TRUE or FALSE.",
			     class = "r2r_hashset_value_error"
			     )
	x
}

#' @rdname subsetting_hashtables
#' @export
"[<-.r2r_hashset" <- function(x, i, value) {
	`validate_[<-_args`(i, value)
	lapply(seq_along(i),
	       function(n) `[[<-.r2r_hashset`(x, i[[n]], value[[n]])
	       )
	return(x)
}

#------------------------- Extra key/value access opearations -----------------#

#' @rdname has_key
#' @export
has_key.r2r_hashset <- query.r2r_hashset



#---------------------------------- Print methods -----------------------------#

#' @export
print.r2r_hashset <- function(x, ...)
{
	cat("An r2r hashset.")
	return(invisible(x))
}

#' @export
summary.r2r_hashset <- function(object, ...)
{
	cat("An r2r hashset.")
	return(invisible(object))
}

#' @export
str.r2r_hashset <- summary.r2r_hashset
