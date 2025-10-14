library(tidyverse)      # For data manipulation and visualization
library(nycflights13)   # For flight data to practice with

#### 25  Functions
x <- c(1,2,3,4,5)
(x - mean(x)/sd(x))


# You can create a function:

standardize <- function(x){
  (x - mean(x)/sd(x))
}

standardize(x)

# Once loaded, you can explore the data

head(flights)
tail(flights)

# 25.2 Vector functions

df <- tibble(
  a = rnorm(5),
  b = rnorm(5),
  c = rnorm(5),
  d = rnorm(5)
)

df |>
  mutate (
    a = (a - min(a, na.rm = TRUE)) / (max(a, na.rm = TRUE) - min(a, na.rm = TRUE)),
    b = (b - min(b, na.rm = TRUE)) / (max(b, na.rm = TRUE) - min(b, na.rm = TRUE)),
    c = (c - min(c, na.rm = TRUE)) / (max(c, na.rm = TRUE) - min(c, na.rm = TRUE)),
    d = (d - min(d, na.rm = TRUE)) / (max(d, na.rm = TRUE) - min(d, na.rm = TRUE)),
  )


# 25.2.1 Writing a function

rescale01 <- function(x){
  (x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
}

# Quick tests

rescale01(c(-10, 0, 10))

rescale01(c(1, 2, 3, NA, 5))


# 2) Use it in your data wrangling

set.seed(1)
df <- tibble(
  a = rnorm(5),
  b = rnorm(5),
  c = rnorm(5),
  d = rnorm(5)
)

df |>
  mutate(
    a = rescale01(a),
    b = rescale01(b),
    c = rescale01(c),
    d = rescale01(d)
)


