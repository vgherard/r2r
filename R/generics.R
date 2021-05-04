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

#' @rdname hashtable_methods
#' @export
insert <- function(x, key, ...)
	UseMethod("insert", x)

#' @rdname hashtable_methods
#' @export
delete <- function(x, key)
	UseMethod("delete", x)

#' @rdname hashtable_methods
#' @export
query <- function(x, key)
	UseMethod("query", x)

#' @rdname hashtable_methods
#' @export
has_key <- function(x, key)
	UseMethod("has_key", x)

#' @rdname hashtable_methods
#' @export
keys <- function(x)
	UseMethod("keys", x)

#' @rdname hashtable_methods
#' @export
values <- function(x)
	UseMethod("values", x)

#' @rdname hashtable_methods
#' @export
`%has_key%` <- has_key
