
<!-- README.md is generated from README.Rmd. Please edit that file -->

# r2r

<!-- badges: start -->
<!-- badges: end -->

`r2r` provides a flexible implementation of hash tables in R, allowing
for:

-   arbitrary R objects as keys and values,
-   arbitrary key comparison and hash functions,
-   customizable behaviour (throw or return a default values) on missing
    key exceptions.

## Installation

You can install the development version of `r2r` from
[GitHub](https://github.com/vgherard/r2r) with:

``` r
# install.packages("devtools")
devtools::install_github("vgherard/r2r")
```

## Examples

``` r
library(r2r)
```

#### Basic Manipulations

We create an empty map with:

``` r
m <- map()
```

We can insert key-value pairs in `m` in several different ways:

``` r
m[["key"]] <- "value"
m[c(1, 2, 3)] <- c("a", "b", "c") # Vectorized over keys and values
m[[c(4, 5, 6)]] <- c("d", "e", "f") # Not vectorized
```

The following queries explain the differences between the `[[` and `[`
operator mentioned in the comments above:

``` r
m[["key"]]
#> [1] "value"

m[c(1, 2, 3)]
#> [[1]]
#> [1] "a"
#> 
#> [[2]]
#> [1] "b"
#> 
#> [[3]]
#> [1] "c"
m[[c(1, 2, 3)]]
#> NULL

m[c(4, 5, 6)]
#> [[1]]
#> NULL
#> 
#> [[2]]
#> NULL
#> 
#> [[3]]
#> NULL
m[[c(4, 5, 6)]]
#> [1] "d" "e" "f"
```

Single element insertions and queries can also be performed through the
generics `insert()` and `query()`

``` r
insert(m, "user", "vgherard") # Modifies `m` in place
query(m, "user")
#> [1] "vgherard"
```

#### Sets

In addition to hash maps, we can also create hash sets, which simply
store keys:

``` r
s <- set()
insert(s, 1)
s[[2]] <- T # equivalent to insert(s, 2)
s[c(1, 2, 3)]
#> [[1]]
#> [1] TRUE
#> 
#> [[2]]
#> [1] TRUE
#> 
#> [[3]]
#> [1] FALSE
```

#### Key and value types

There is no restriction on the type of object you can use as keys and
values. For instance:

``` r
m[[ lm(wt ~ mpg, mtcars) ]] <- list("This is my fit!", 840)
m[[ lm(wt ~ mpg, mtcars) ]]
#> [[1]]
#> [1] "This is my fit!"
#> 
#> [[2]]
#> [1] 840
m[[ lm(cyl ~ mpg, mtcars) ]]
#> NULL
```

#### Setting default values

You can set default values for missing keys. For instance:

``` r
m <- map(default = 0)
```

which is useful for creating a counter:

``` r
objects <- list(1, 1, "1", FALSE, "1", 1)
for (object in objects)
    m[[object]] <- m[[object]] + 1
m[["1"]]
#> [1] 2
```

Alternatively, you may throw an exception upon querying a missing key:

``` r
m <- map(throw = TRUE)
tryCatch(m[["Missing key"]], error = function(cnd) "Oops!")
#> [1] "Oops!"
```

#### Using custom key comparison and hash functions

`map`s and `set`s use by default `base::identical()` to compare keys.
For instance:

``` r
m <- map()
m[[1]] <- "double"
m[["1"]] <- "character"
m[[1]]
#> [1] "double"
```

This behavior can be changed by explicitly providing a key comparison
function. For this to work correctly, one must also explicitly provide
an hash function which produces the same hashes for equivalent keys. A
simple way to do this is to compose the `default_hash()` function with a
key preprocessing function; this is illustrated in the following
example.

We assume that keys are length one complex numbers, and consider two
keys equivalent when they have the same direction in the complex plane.
A sensible comparison function is:

``` r
compare <- function(z1, z2) 
    Arg(z1) == Arg(z2)
```

An hash function which depends only on the arguments of `z` is clearly
given by:

``` r
hash <- function(z) default_hash(Arg(z))
```

Thus we create our map as:

``` r
m <- map(hash = hash, compare = compare)
m[list(1, 1 + 1i, 1i)] <- list("EAST", "NORTH-EAST", "NORTH")
m[[10]]
#> [1] "EAST"
m[[100i]]
#> [1] "NORTH"
m[[2 + 2i]]
#> [1] "NORTH-EAST"
```
