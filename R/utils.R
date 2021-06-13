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

mget_all <- function(env)
{
	names <- ls(envir = env, all.names = TRUE, sorted = FALSE)
	res <- mget(names, envir = env, inherits = FALSE)
	names(res) <- NULL
	return(res)
}

`validate_[_arg` <- function(i, name = "i")
	if (!is.atomic(i) && !is.list(i))
	{
		msg <- paste0("'", name, "' ",
			      "must be either an atomic vector or a list."
		)
		rlang::abort(msg, class = "r2r_domain_error")
	}

`validate_[<-_args` <- function(i, value)
{
	`validate_[_arg`(i)
	`validate_[_arg`(value, name = "value")
	if (length(i) != length(value))
	{
		msg <- "'i' and 'value' must have the same length."
		rlang::abort(msg, class = "r2r_domain_error")
	}
}
