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
  
###### 25.2.2 Improving our function

In this section, we’ll improve the **rescale01()** function to make it faster, cleaner, and more reliable.  
We’ll also learn how to handle special values like **Inf** (infinity) and **NA** (missing values).

---

###### 🧠 Step 1: Recall the Original Function

Here’s our first version:

```r
rescale01 <- function(x) {
  (x - min(x, na.rm = TRUE)) /
    (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
}
```

###### 🔍 Explanation
| Function | What it does | Example | Output |
|-----------|---------------|----------|---------|
| `min(x, na.rm = TRUE)` | Finds the smallest value while ignoring missing values (`NA`) | `min(c(1,2,NA), na.rm = TRUE)` | `1` |
| `max(x, na.rm = TRUE)` | Finds the largest value while ignoring missing values | `max(c(1,2,NA), na.rm = TRUE)` | `2` |

This rescales your data so that the smallest number becomes **0** and the largest becomes **1**.

###### ✅ Example
```r
rescale01(c(10, 20, 30, 40, 50))
```
**Output:**
```
[1] 0.00 0.25 0.50 0.75 1.00
```

---

###### ⚙️ Step 2: Make It More Efficient with `range()`

The original function calls `min()` and `max()` multiple times.  
We can simplify this using **`range()`**, which returns both values in one call.

```r
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}
```

###### 🔍 Explanation
- `range(x, na.rm = TRUE)` → returns both the **minimum** and **maximum** values of `x`
- `rng[1]` → minimum value
- `rng[2]` → maximum value

###### ✅ Example
```r
rescale01(c(10, 20, 30, 40, 50))
```
**Output:**
```
[1] 0.00 0.25 0.50 0.75 1.00
```

Same result, but now **faster and cleaner**!

---

###### ⚠️ Step 3: What Happens with Infinite Values?

Let’s test when `x` contains infinity (`Inf`):

```r
x <- c(1:10, Inf)
rescale01(x)
```
**Output:**
```
[1] 0 0 0 0 0 0 0 0 0 0 NaN
```

🧐 The infinite value produced **NaN** (Not a Number).  
This happens because R tried to do math with `Inf` which is undefined in this context.

---

###### ✅ Step 4: Fix It with `finite = TRUE`

We can tell R to **ignore infinite values** when calculating the range:

```r
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE, finite = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}
```

###### ✅ Test Again
```r
x <- c(1:10, Inf)
rescale01(x)
```
**Output:**
```
[1] 0.0000000 0.1111111 0.2222222 0.3333333 0.4444444 0.5555556 0.6666667
[8] 0.7777778 0.8888889 1.0000000       Inf
```

🎉 The normal numbers are rescaled correctly, and `Inf` remains unchanged.

---

###### 🧠 Built-in Functions Explained

| Function | Description | Example | Output |
|-----------|--------------|----------|---------|
| `range(x, na.rm = TRUE)` | Returns both smallest and largest values | `range(c(2, 5, 8))` | `[1] 2 8` |
| `na.rm = TRUE` | Removes missing values before calculation | `mean(c(1, NA, 3), na.rm = TRUE)` → `2` | |
| `finite = TRUE` | Ignores `Inf` and `-Inf` | `range(c(1, 5, Inf), finite = TRUE)` → `[1] 1 5` |
| `Inf` | Represents infinity | `1/0` → `Inf` | |
| `NaN` | “Not a Number”, appears when result is undefined | `0/0` → `NaN` | |

---

###### 💡 Step 5: Why This Improvement Matters

Because our logic is wrapped in one function:
- We only need to make updates **once**.
- The function becomes **faster**, **cleaner**, and **reusable**.
- It can handle tricky data (with `Inf` or `NA`) safely.

This shows one big benefit of writing functions — a single update improves your entire workflow!

---

###### ✅ Final Improved Function

```r
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE, finite = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}
```

### 🧪 Test Cases
```r
rescale01(c(10, 20, 30, 40, 50))
#> [1] 0.00 0.25 0.50 0.75 1.00

rescale01(c(1:10, Inf))
#> [1] 0.00 0.11 0.22 0.33 0.44 0.56 0.67 0.78 0.89 1.00 Inf
```

---

## 🧩 Summary

| Concept | Explanation |
|----------|-------------|
| **Goal** | Rescale numbers to a 0–1 range |
| **Problem** | Repeated calculations and failure with `Inf` |
| **Solution** | Use `range()` with `finite = TRUE` |
| **Benefit** | Faster, cleaner, handles edge cases safely |

---

✅ **Key takeaway:** When improving a function, focus on efficiency, readability, and reliability.  
With `range()` and `finite = TRUE`, we make `rescale01()` smarter and more stable.

###### 25.2.3 Mutate functions


## 🎯 What Are “Mutate Functions”?
A **mutate function** is a function that:
- Takes one or more **vectors** as input.  
- Returns a **vector of the same length** as output.  

These functions work perfectly with **`mutate()`** or **`filter()`** in **dplyr**, because each output value corresponds to one input value.

Example:
```r
df |> mutate(new_column = my_function(old_column))
```

---

###### 🧠 1. Z-Score Function (Standardization)

### 🎯 Goal
Rescale a vector so that:
- Mean = 0  
- Standard deviation = 1

###### 🧑‍💻 Code
```r
z_score <- function(x) {
  (x - mean(x, na.rm = TRUE)) / sd(x, na.rm = TRUE)
}
```

###### 🔍 Explanation
| Function | Description | Example | Output |
|-----------|--------------|----------|---------|
| `mean(x, na.rm = TRUE)` | Finds the average while ignoring `NA` | `mean(c(1,2,NA), na.rm = TRUE)` | `1.5` |
| `sd(x, na.rm = TRUE)` | Finds the standard deviation | `sd(c(1,2,3))` | `1` |

###### ✅ Example
```r
z_score(c(10, 20, 30))
```
**Output:**
```
[1] -1  0  1
```

---

###### 🧠 2. Clamp Function (Limit Values Within a Range)

###### 🎯 Goal
Ensure all numbers stay between a minimum and maximum value.

###### 🧑‍💻 Code
```r
clamp <- function(x, min, max) {
  case_when(
    x < min ~ min,
    x > max ~ max,
    .default = x
  )
}
```

###### 🔍 Explanation
| Function | Description | Example | Output |
|-----------|--------------|----------|---------|
| `case_when()` | Tests multiple conditions | `case_when(2 < 3 ~ "Yes", TRUE ~ "No")` | `"Yes"` |
| `.default = x` | Keeps the value unchanged if no condition matches | | |

###### ✅ Example
```r
clamp(1:10, min = 3, max = 7)
```
**Output:**
```
[1] 3 3 3 4 5 6 7 7 7 7
```

---

###### 🧠 3. Make the First Letter Uppercase

### 🎯 Goal
Change the first letter of each word to uppercase.

###### 🧑‍💻 Code
```r
library(stringr)

first_upper <- function(x) {
  str_sub(x, 1, 1) <- str_to_upper(str_sub(x, 1, 1))
  x
}
```

###### 🔍 Explanation
| Function | Description | Example | Output |
|-----------|--------------|----------|---------|
| `str_sub(x, start, end)` | Extracts part of a string | `str_sub("hello", 1, 1)` | `"h"` |
| `str_to_upper()` | Converts to uppercase | `str_to_upper("h")` | `"H"` |

###### ✅ Example
```r
first_upper("hello")
```
**Output:**
```
[1] "Hello"
```

---

###### 🧠 4. Clean Number Function

##### 🎯 Goal
Remove symbols (`%`, `$`, `,`) from text numbers and convert them into numeric values.

######🧑‍💻 Code
```r
clean_number <- function(x) {
  is_pct <- str_detect(x, "%")
  num <- x |> 
    str_remove_all("%") |> 
    str_remove_all(",") |> 
    str_remove_all(fixed("$")) |> 
    as.numeric()
  if_else(is_pct, num / 100, num)
}
```

###### 🔍 Explanation
| Function | Description | Example | Output |
|-----------|--------------|----------|---------|
| `str_detect(x, "%")` | Checks if text contains `%` | `str_detect("45%", "%")` | `TRUE` |
| `str_remove_all()` | Removes unwanted symbols | `str_remove_all("12,300", ",")` | `"12300"` |
| `fixed("$")` | Treats `$` as a normal symbol | | |
| `as.numeric()` | Converts text to number | `as.numeric("123")` | `123` |
| `if_else()` | Returns one value if condition is true, another if false | `if_else(TRUE, 1, 0)` | `1` |

###### ✅ Examples
```r
clean_number("$12,300")
#> [1] 12300

clean_number("45%")
#> [1] 0.45
```

---

###### 🧠 5. Fix Missing Values

###### 🎯 Goal
Replace fake missing codes (like 997, 998, 999) with actual `NA` values.

####### 🧑‍💻 Code
```r
fix_na <- function(x) {
  if_else(x %in% c(997, 998, 999), NA, x)
}
```
###### 🔍 Explanation
| Function | Description | Example | Output |
|-----------|--------------|----------|---------|
| `%in%` | Checks if values exist in a list | `5 %in% c(1,5,10)` | `TRUE` |
| `if_else()` | Replaces values based on condition | `if_else(TRUE, "Yes", "No")` | `"Yes"` |

###### ✅ Example
```r
fix_na(c(1, 997, 5, 999))
```
**Output:**
```
[1]  1 NA  5 NA
```

---

###### 🧩 Summary

| Function | Purpose |
|-----------|----------|
| `z_score()` | Standardizes data (mean = 0, SD = 1) |
| `clamp()` | Limits values to a range |
| `first_upper()` | Capitalizes first letter |
| `clean_number()` | Cleans symbols from numbers |
| `fix_na()` | Converts coded missing values to NA |

---

###### ✅ Key Takeaways
- Mutate functions work best inside `mutate()` and `filter()`.
- They return vectors of the **same length** as input.
- Writing your own small functions makes your analysis **cleaner, faster, and reusable**.
- You can use them for both **numeric** and **string** variables.

---

##### 25.2.4 Summary functions


###### 🎯 What Are Summary Functions?
A **summary function** takes a **vector** as input and returns **a single value** as output.  
They are perfect for use in `summarize()` because they reduce many values into one summary — like mean, count, or total.

Example:
```r
summarize(df, avg = mean(x))
```

---

###### 🧠 1. Combine Words Nicely — `commas()`

###### 🎯 Goal
Turn a list of words into a single sentence separated by commas and “and”.

###### 🧑‍💻 Code
```r
commas <- function(x) {
  str_flatten(x, collapse = ", ", last = " and ")
}

commas(c("cat", "dog", "pigeon"))
```
###### 🟢 Output
```
[1] "cat, dog and pigeon"
```

###### 🔍 Explanation
| Function | Description | Example | Output |
|-----------|--------------|----------|---------|
| `str_flatten(x, collapse, last)` | Combines vector elements into one string. | `str_flatten(c("A","B","C"), ", ", " and ")` | `"A, B and C"` |

🧩 **In short:** Combines text neatly for easy reading.

---

###### 🧠 2. Coefficient of Variation — `cv()`

###### 🎯 Goal
Measure variability of data compared to its mean.

Formula: `CV = SD / Mean`

###### 🧑‍💻 Code
```r
cv <- function(x, na.rm = FALSE) {
  sd(x, na.rm = na.rm) / mean(x, na.rm = na.rm)
}

cv(runif(100, min = 0, max = 50))
cv(runif(100, min = 0, max = 500))
```

### 🟢 Output
```
[1] 0.5196276
[1] 0.5652554
```

###### 🔍 Explanation
| Function | Description | Example | Output |
|-----------|--------------|----------|---------|
| `sd(x)` | Standard deviation | `sd(c(1,2,3))` | `1` |
| `mean(x)` | Average value | `mean(c(1,2,3))` | `2` |
| `runif(n, min, max)` | Creates random numbers | `runif(3, 0, 10)` | `[1] 3.2 8.1 1.5` |

🧩 **In short:** Tells you how “spread out” the data is.

---

###### 🧠 3. Count Missing Values — `n_missing()`

###### 🎯 Goal
Count how many `NA` values exist in a vector.

###### 🧑‍💻 Code
```r
n_missing <- function(x) {
  sum(is.na(x))
}

n_missing(c(2, NA, 4, NA, 8))
```
###### 🟢 Output
```
[1] 2
```

###### 🔍 Explanation
| Function | Description | Example | Output |
|-----------|--------------|----------|---------|
| `is.na(x)` | Detects missing values | `is.na(c(1, NA, 3))` | `[1] FALSE TRUE FALSE` |
| `sum(x)` | Adds TRUEs as 1s | `sum(c(TRUE, FALSE, TRUE))` | `2` |

🧩 **In short:** Quickly counts missing values.

---

###### 🧠 4. Mean Absolute Percentage Error — `mape()`

###### 🎯 Goal
Compare model predictions with actual values.  
Formula: `MAPE = mean(abs((actual - predicted) / actual))`

###### 🧑‍💻 Code
```r
mape <- function(actual, predicted) {
  sum(abs((actual - predicted) / actual)) / length(actual)
}

actual <- c(100, 200, 300)
predicted <- c(110, 190, 310)
mape(actual, predicted)
```

###### 🟢 Output
```
[1] 0.0444
```

### 🔍 Explanation
| Function | Description | Example | Output |
|-----------|--------------|----------|---------|
| `abs(x)` | Absolute (positive) value | `abs(-3)` | `3` |
| `length(x)` | Counts elements | `length(c(1,2,3))` | `3` |
| `sum(x)` | Adds up numbers | `sum(c(1,2,3))` | `6` |

🧩 **In short:** Measures how close predictions are to actual data (smaller = better).

---

###### 🧠 5. Check File and Folder Properties

###### 🎯 Goal
Check if something is a directory or if it’s readable.

###### 🧑‍💻 Code
```r
is_directory <- function(x) {
  file.info(x)$isdir
}

is_readable <- function(x) {
  file.access(x, 4) == 0
}
```

###### 🔍 Explanation
| Function | Description | Example | Output |
|-----------|--------------|----------|---------|
| `file.info(x)` | Returns file info | `file.info("data")$isdir` | `TRUE` |
| `file.access(x, 4)` | Checks read permission | `file.access("file.csv", 4)` | `0` (can read) or `-1` (cannot read) |

🧩 **In short:** Helps check folders and file permissions before reading data.

---

###### 💡 RStudio Shortcuts for Functions

| Shortcut | Action |
|-----------|---------|
| **F2** | Jump to the function definition |
| **Ctrl + .** | Quickly find any function or file |

---

##### 25.2.5 Exercises




##### 25.1 Introduction
##### 25.1 Introduction






### 7.1.1 Writing robust functions

### 7.2 Further Reading