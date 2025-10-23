## Topic

In this session, we will discuss:

  * 7 Writing your own functions
  * 7.1 Writing your own functions
  * 7.1.1 Writing robust functions
  * 7.2 Further Reading


## keywords & Notes

### 7 Writing your own functions

In this session, we learn how to create our own functions in R.

Functions help us `reuse code`, `avoid repetition`, and make our `work cleaner and easier to understand`.

Before starting, you should go through [Chapter 25](https://r4ds.hadley.nz/functions.html) of R for Data Science to understand the basics.

After that, you’ll practice by doing short exercises to check your understanding.

> In short:
> This session teaches us how to turn repeated code into simple, reusable functions — a key step toward writing efficient and professional R code.

The content below is adapted from Chapter 25 oof R for Data Science to understand the basics.

In this session, we will discuss:

* 25  Functions
* 25.1 Introduction
* 25.1.1 Prerequisites


#### 25  Functions

##### 25.1 Introduction

Functions are small reusable pieces of code that help you automate tasks and make your work cleaner and faster.

Instead of copying and pasting the same code many times, you can put it inside a function and call it whenever you need it.

💡 **Why write functions?**
  * `Clarity` – You can give your function a clear name, making your code easier to read.  
  * `Easy updates` – If you need to make changes, you only edit the function once.  
  * `Fewer mistakes` – Avoid errors that come from copying and forgetting to update something.  
  * `Reusability` – You can use the same function across different projects.  

🧠 **When to write a function**
If you find yourself copying and pasting the same code three times or more, that’s a good sign you should turn it into a function.

⚙️ **Types of functions**
There are three main kinds:
  * `Vector functions` – take vectors as input and return a vector.
  * `Data frame functions` – take a data frame and return another data frame.
  * `Plot functions` – take a data frame and return a plot.
  

🧩 Example idea
Instead of writing this again and again:

```
x <- c(1,2,3,4,5)
(x - mean(x)) / sd(x)

```
Output:

```
[1] -0.8973666  0.1026334  1.1026334  2.1026334  3.1026334
```

You can create a function:

```
x <- c(1,2,3,4,5)
standardize <- function(x) {
  (x - mean(x)) / sd(x)
}

standardize(x)

```

Output:

```
[1] -0.8973666  0.1026334  1.1026334  2.1026334  3.1026334
```

> ✅ In short:
> Functions help us save time, avoid errors, and make code more readable and reusable — an essential skill for every data scientist.

##### 25.1.1 Prerequisites

Before we start writing our own functions, we’ll use some tools and data that will help us practice.

We’ll work with:

 * `The tidyverse` — a collection of R packages (like `dplyr`, `ggplot2`, and `tibble`) for data manipulation and visualization.  
 * `nycflights13` — a dataset about all flights that departed from New York City in 2013. It’s great for examples and practice.

🧠 Load the required packages:
```
library(tidyverse)      # For data manipulation and visualization
library(nycflights13)   # For flight data to practice with

```

Once loaded, you can explore the data:

```
head(flights)

```

>[!TIP]
> Before writing your own functions, make sure you’ve loaded the tidyverse for useful tools and nycflights13 for data to experiment with.


##### 25.2 Vector functions

Vector functions are functions that take one or more vectors as input and return a vector as output.

They are useful when you want to apply the same operation to many columns or data points.

💡 Example: Rescaling Columns

Let’s look at this example that creates a tibble (a modern data frame) with four random numeric columns:

```
df <- tibble(
  a = rnorm(5),
  b = rnorm(5),
  c = rnorm(5),
  d = rnorm(5)
)
df

```

🟢 Example Output:

```
# A tibble: 5 × 4
       a       b       c       d
   <dbl>   <dbl>   <dbl>   <dbl>
1  1.21   -0.47   0.56    -0.80
2 -0.32    0.37   0.12     0.28
3  0.44   -0.11  -1.05    -0.18
4 -0.65    1.02   0.81     0.94
5  0.31   -0.92  -0.44    -0.24

```

Now we rescale each column to range between 0 and 1.

This helps compare values on the same scale.

```
df |> mutate(
  a = (a - min(a, na.rm = TRUE)) / (max(a, na.rm = TRUE) - min(a, na.rm = TRUE)),
  b = (b - min(b, na.rm = TRUE)) / (max(b, na.rm = TRUE) - min(b, na.rm = TRUE)),
  c = (c - min(c, na.rm = TRUE)) / (max(c, na.rm = TRUE) - min(c, na.rm = TRUE)),
  d = (d - min(d, na.rm = TRUE)) / (max(d, na.rm = TRUE) - min(d, na.rm = TRUE))
)
```

🟢 Example Output:
```
# A tibble: 5 × 4
       a     b     c     d
   <dbl> <dbl> <dbl> <dbl>
1 0.619  0.597 1     0.558
2 0.0879 0     0.263 0.961
3 1      0.315 0.822 0.856
4 0      0.202 0.537 0    
5 0.622  1     0     1   

```

>[!CAUTION]
> ⚠️ Common Mistake:
> Notice the line:

```
b = (b - min(a, na.rm = TRUE)) / ...
```
There’s a typo — it uses min(a, …) instead of min(b, …).
This happened because of copy-pasting code repeatedly.

> ✅ Lesson:
> Instead of repeating similar code for each column (which can cause mistakes),
we can create a function that rescales a vector automatically — making our code cleaner, shorter, and safer.

🧠 Key Takeaway:
  * Vector functions help apply the same logic to many elements at once.  
  * Avoid copy-paste errors by writing reusable functions.   
  * You’ll learn how to turn this code into a simple function next!  


###### 25.2.1 Writing a function

When you catch yourself repeating the same `code` for different columns, it’s time to write a function.

Here, we’re rescaling columns so each goes from 0 to 1. The repeated pattern is:

```
(a - min(a, na.rm = TRUE)) / (max(a, na.rm = TRUE) - min(a, na.rm = TRUE))
(b - min(b, na.rm = TRUE)) / (max(b, na.rm = TRUE) - min(b, na.rm = TRUE))
(c - min(c, na.rm = TRUE)) / (max(c, na.rm = TRUE) - min(c, na.rm = TRUE))
(d - min(d, na.rm = TRUE)) / (max(d, na.rm = TRUE) - min(d, na.rm = TRUE))

```

If we replace the changing part with a placeholder (think “slot”):
```
(█ - min(█, na.rm = TRUE)) / (max(█, na.rm = TRUE) - min(█, na.rm = TRUE))

```
…it’s clear we only need one input: the vector to rescale.

  1) Build the function
  
  Function template:
  
  ```
  name <- function(arguments) {
    body
  }
  
  ```
  
  Our rescaling function:
  
  ```
  rescale01 <- function(x) {
    (x - min(x, na.rm = TRUE)) /
      (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
  }
  
  ```
  Quick tests
  
  ```
  rescale01(c(-10, 0, 10))
  #> [1] 0.0 0.5 1.0
  
  rescale01(c(1, 2, 3, NA, 5))
  #> [1] 0.00 0.25 0.50   NA 1.00
  
  ```
  2) Use it in your data wrangling
  
  ```
  library(dplyr)
  library(tibble)
  
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
  #> # A tibble: 5 × 4
  #>       a      b     c     d
  #>   <dbl>  <dbl> <dbl> <dbl>
  #> 1 0.795  0.134 0.458 0.000
  #> 2 0.000  1.000 1.000 0.557
  #> 3 1.000  0.000 0.000 1.000
  #> 4 0.339  0.353 0.291 0.752
  #> 5 0.880  0.210 0.580 0.394
  
  ```
  > Why this is better:
  > * No copy–paste mistakes (like using min(a, ...) when scaling b).
  > * One clear place to edit if you need to change the logic later.
  > * Cleaner, more readable code.
  
  3) (Nice to know) Reduce duplication further with `across()`
  
  ```
  df |>
    mutate(across(a:d, rescale01))
  
  ```
  This applies `rescale01()` to all columns `a` through `d` in one shot.
  
  > (In [Chapter 26](https://r4ds.hadley.nz/iteration.html), you’ll learn how to use `across()` to reduce the duplication even further so all you need is `df |> mutate(across(a:d, rescale01))`).
  
  
# 25.2.2 Improving Our Function (Beginner-Friendly Guide)

This guide shows how to **improve a rescaling function** in R that maps numbers to the range **0–1**.  
We’ll make it **faster**, **safer**, and **easier to maintain**, and we’ll look at how to handle edge cases like `NA` and `Inf`.

---

## Why improve the original function?

The first version computed `min()` **twice** and `max()` **once** on the same vector. That’s unnecessary work.  
We can replace those three calls with a single call to **`range()`**, which returns **both** the minimum and maximum.

### Original version
```r
rescale01 <- function(x) {
  (x - min(x, na.rm = TRUE)) /
    (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
}
```

---

## Make it efficient with `range()`

`range(x, na.rm = TRUE)` returns a numeric vector of length 2:  
- `rng[1]` → minimum value  
- `rng[2]` → maximum value

### Improved version
```r
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}
```

### Example
```r
rescale01(c(10, 20, 30, 40, 50))
#> [1] 0.00 0.25 0.50 0.75 1.00
```

**Explanation:**  
- `range(c(10, 20, 30, 40, 50))` is `[10, 50]`  
- Subtract 10 (min), then divide by 40 (max - min)

---

## Handling `Inf` (infinite values)

If your data includes `Inf`, the previous version can produce `NaN` outputs.

### Example showing the problem
```r
x <- c(1:10, Inf)
rescale01(x)
#>  [1] 0 0 0 0 0 0 0 0 0 0 NaN
```

### Fix: ask `range()` to ignore infinite values

Use `finite = TRUE` so `range()` computes min/max from **finite** values only.

```r
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE, finite = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}
```

### Test again
```r
x <- c(1:10, Inf)
rescale01(x)
#>  [1] 0.0000000 0.1111111 0.2222222 0.3333333 0.4444444 0.5555556 0.6666667
#>  [8] 0.7777778 0.8888889 1.0000000       Inf
```

**What happened?**  
- The **finite values** (1–10) were rescaled to 0–1.  
- `Inf` stayed `Inf` (we didn’t modify it), but it **no longer breaks** the calculation.

---

## Built-in functions explained

| Function | What it does | Example | Output |
|---|---|---|---|
| `range(x, na.rm = TRUE)` | Returns **c(min, max)**, optionally ignoring `NA` | `range(c(2, 5, NA), na.rm = TRUE)` | `2 5` |
| `min(x, na.rm = TRUE)` | Smallest value, optionally ignoring `NA` | `min(c(3, NA, 7), na.rm = TRUE)` | `3` |
| `max(x, na.rm = TRUE)` | Largest value, optionally ignoring `NA` | `max(c(3, NA, 7), na.rm = TRUE)` | `7` |
| `finite = TRUE` | Ignores `Inf`/`-Inf` when finding range | `range(c(1, Inf), finite = TRUE)` | `1 1` |

> **Tip:** `na.rm = TRUE` tells functions to **remove NAs** before computing.  
> **Tip:** `finite = TRUE` tells `range()` to ignore **infinite values** too.

---

## Edge cases to consider

1. **All values are the same** (e.g., `x = c(5, 5, 5)`):  
   - The denominator `(max - min)` becomes **0**, leading to `NaN`.  
   - You may want to **special-case** this to return zeros.

2. **All values are `NA`**:  
   - `range()` returns `c(NA, NA)` → result is all `NA`.  
   - That’s usually okay, but be aware.

### Safer version handling constant vectors

```r
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE, finite = TRUE)
  if (any(!is.finite(rng))) return(x * NA_real_)  # all NA/Inf
  if (rng[1] == rng[2]) return((x - rng[1]) * 0) # constant vector → all zeros
  (x - rng[1]) / (rng[2] - rng[1])
}
```

### Tests
```r
rescale01(c(5, 5, 5))
#> [1] 0 0 0

rescale01(c(NA, NA))
#> [1] NA NA
```

---

## Why functions make changes easier

Because the rescaling logic lives in **one function**, any improvement (like handling `Inf`)  
is done **once** and instantly benefits **everywhere** you use it. No more copy–paste fixes.

---

## Mini-exercise (with solution)

**Exercise:** Rescale this vector and explain the result:
```r
y <- c(-5, 0, 5, 10, Inf, NA)
rescale01(y)
```

**Solution (expected behavior):**
- Finite numbers (`-5, 0, 5, 10`) are rescaled to 0–1  
- `Inf` stays `Inf`  
- `NA` stays `NA`  

Example output (your exact values may vary slightly):
```
[1] 0.00 0.33 0.67 1.00   Inf   NA
```

---

## TL;DR

- Use `range()` to compute min & max **in one step**.  
- Add `finite = TRUE` to avoid `Inf` causing `NaN`.  
- Wrap logic in a **single function** so fixes are applied **everywhere** automatically.



##### 25.1 Introduction
##### 25.1 Introduction






### 7.1.1 Writing robust functions

### 7.2 Further Reading