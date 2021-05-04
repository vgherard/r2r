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

#' @export
default_hash_fn <- function(key) {
	if (is.atomic(key) && length(key) == 1L)
		as.character(key)
	else
		digest(key)
}

#' Utility for collision handling
#' @param env an environment.
#' @param key an arbitrary R object.
#' @return a character of length one. Either an hash \code{h} of the input key,
#' such that \code{identical(env[[h]], key)} is \code{TRUE}, or a name which is
#' unbind in \code{env}, if no match is found.
#' @noRd
get_env_key <- function(env, key, hash, compare)
{
	h <- hash(key)
	while (!is.null(match <- env[[h]])) {
		if (compare(match, key))
			return(h)
		h <- paste0(h, "0")
	}
	return(h)
}
