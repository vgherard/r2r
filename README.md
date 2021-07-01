
<!-- README.md is generated from README.Rmd. Please edit that file -->

# r2r

<!-- badges: start -->

[![R-CMD-check](https://github.com/vgherard/r2r/workflows/R-CMD-check/badge.svg)](https://github.com/vgherard/r2r/actions)
[![Codecov test
coverage](https://codecov.io/gh/vgherard/r2r/branch/master/graph/badge.svg)](https://codecov.io/gh/vgherard/r2r?branch=master)
<!-- badges: end -->

`r2r` provides a flexible implementation of hash tables in R, allowing
for:

-   arbitrary R objects as keys and values,
-   arbitrary key comparison and hash functions,
-   customizable behaviour (throw or return a default value) on missing
    key exceptions.

## Installation

You can install the development version of `r2r` from
[GitHub](https://github.com/vgherard/r2r) with:

``` r
# install.packages("devtools")
devtools::install_github("vgherard/r2r")
```

## Usage

``` r
library(r2r)
m <- hashmap()

# Insert and query a single key-value pair
m[[ "user" ]] <- "vgherard"
m[[ "user" ]]
#> [1] "vgherard"

# Insert and query multiple key-value pairs
m[ c(1, 2, 3) ] <- c("one", "two", "three")
m[ c(1, 3) ]
#> [[1]]
#> [1] "one"
#> 
#> [[2]]
#> [1] "three"

# Keys and values can be arbitrary R objects
m[[ lm(mpg ~ wt, mtcars) ]] <- c(TRUE, FALSE, TRUE)
m[[ lm(mpg ~ wt, mtcars) ]]
#> [1]  TRUE FALSE  TRUE
```

## Getting help

For further details, including an introductory vignette illustrating the
features of `r2r` hash maps, you can consult the `r2r`
[website](https://vgherard.github.io/r2r/). If you encounter a bug, want
to suggest a feature or need further help, you can [open a GitHub
issue](https://github.com/vgherard/r2r/issues).
