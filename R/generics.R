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
insert <- function(x, key, ...)
	UseMethod("insert", x)

#' @export
delete <- function(x, key)
	UseMethod("delete", x)

#' @export
query <- function(x, key)
	UseMethod("query", x)

#' @export
keys <- function(x)
	UseMethod("keys", x)

#' @export
values <- function(x)
	UseMethod("values", x)

#' @export
has_key <- function(x, key)
	UseMethod("has_key", x)

#' @export
`%has_key%` <- has_key

#' @export
hash_fn <- function(x)
	UseMethod("hash_fn", x)

#' @export
`hash_fn<-` <- function(x)
	UseMethod("hash_fn<-", x)

#' @export
compare_fn <- function(x)
	UseMethod("compare_fn", x)

#' @export
`compare_fn<-` <- function(x)
	UseMethod("compare_fn<-", x)

#' @export
on_missing_key <- function(x)
	UseMethod("on_missing_key", x)

#' @export
`on_missing_key<-` <- function(x)
	UseMethod("on_missing_key<-", x)


#' @export
default <- function(x)
	UseMethod("default", x)

#' @export
`default<-` <- function(x)
	UseMethod("default<-", x)
