## Topic
In this session, we will discuss:  

* [4.1 dplyr verbs: select, mutate, filter, arrange](#41-dplyr-verbs-select-mutate-filter-arrange)
* [4.2 More dplyr verbs: group_by and summarise](#42-more-dplyr-verbs-group-by-and-summarise)
* [4.3 Further Reading](#43-murther-reading)

## keywords & Notes

This chapter introduces the `Tidyverse`, focusing on the `dplyr package`. While there are many ways to code in R, `Tidyverse` is taught here because it is intuitive for beginners. You should first study [Chapter 4 of Wickham & Grolemund’s book](https://r4ds.hadley.nz/data-transform.html) and then complete the `check-in exercises`. The notes use the pipe operator `%>%`, but you may also use the newer `|>` operator (explained in Chapter 4.4).

>[!IMPORTANT]
>Learn Tidyverse with dplyr, practice with the exercises, and choose the pipe style (%>% or |>) you prefer.

> The content below is adapted from Chapter 4 of Wickham & Grolemund’s book.”

#### 3  Data transformation

##### 3.1 Introduction

This chapter focuses on `data transformation` with `dplyr`. 

Since raw data is rarely in the right form for visualization, you’ll learn how to `create new variables, summarise data, rename variables, and reorder observations` to make analysis easier. 

The chapter introduces key tools for transforming `data frames`, starting with `row operations`, then `column operations`, and shows how to `combine steps with the pipe`. It also covers `grouped operations` and ends with a case study using `NYC flight data (2013)`. Later chapters will revisit these functions in more detail for specific data types.

###### 3.1.1 Prerequisites

This chapter introduces the `dplyr package` (part of the `tidyverse`), using the `nycflights13 dataset` and `ggplot2` for visualization. When loading `tidyverse`, you may see `conflicts`, meaning some `dplyr functions` replace `base R functions`. If you want the `base R version`, you can explicitly call it with `packagename::functionname()`.

>[!NOTE]
>Pro tip: If not installed, install tidyverse package first and nycflights13 package

```
#install packages

install.packages("tidyverse")
install.packages("nycflights13")
```
* Loading Packages

  ```
    library(nycflights13)
    library(tidyverse)
    
    #> ── Attaching core tidyverse packages ─────────────── tidyverse 2.0.0 ──
    #> ✔ dplyr     1.1.4     ✔ readr     2.1.5
    #> ✔ ggplot2   4.0.0     ✔ tibble    3.3.0
    #> ✔ lubridate 1.9.4     ✔ tidyr     1.3.1
    #> ✔ purrr     1.1.0     ✔ stringr   1.5.2
    #> ✔ forcats   1.0.1
    #> ── Conflicts ────────────────────────────────── tidyverse_conflicts() ──
    #> ✖ dplyr::filter() masks stats::filter()
    #> ✖ dplyr::lag()    masks stats::lag()

  ```

* Understanding Conflicts

  When you load `dplyr` (or the `tidyverse`), some of its functions have the same names as functions that already exist in `base R` (the default `R installation`).

  For example:

  * `filter()`

    * In base R (`stats::filter`) → it’s for filtering time series (e.g., moving averages).

    * In dplyr (`dplyr::filter`) → it’s for filtering rows in data frames.

  * `lag()`

    * In base R (`stats::lag`) → works with time series objects.

    * In dplyr (`dplyr::lag`) → shifts values in vectors or columns.

  When you load ``dplyr`, its versions `mask` or `replace` the base versions. That means if you just type `filter()`, R will use `dplyr’s function`, not the `base R` one.

  If you need the base version, call it with the package name:
  
  `General Syntax`: Whenever you want to be explicit about where a function comes from, use:
  
  ```
    packagename::functionname()

  ```
  For example:
  
  ```
  
    # dplyr filter - used for subsetting rows in data frames
    dplyr::filter(mtcars, cyl == 6)
    ## Returns only rows from 'mtcars' where cyl == 6
    
    # base R stats filter - used for time series, not data frames
    stats::filter(1:10, rep(1/3, 3))
    ## Applies a moving average filter on numbers 1 to 10

  
  ```

###### 3.1.1 nycflights13

* Exploring the flights dataset

  We’ll use `nycflights13::flights`, which contains   336,776 flights  departing New York City in 2013. The dataset is a tibble, a tidyverse-friendly version of a data frame.
  
* Viewing the dataset

  ```
  library(nycflights13)
  flights
  
  ```
  Output (first few rows only, since it’s a tibble):
  
  ```
    # A tibble: 336,776 × 19
     year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time
     <int> <int> <int>    <int>          <int>     <dbl>    <int>          <int>
   1  2013     1     1      517            515         2      830            819
   2  2013     1     1      533            529         4      850            830
   3  2013     1     1      542            540         2      923            850
     
  ```
  >[!NOTE]
  > Tibbles only print the first rows and as many columns as fit on the screen (unlike data frames that try to print everything).
  
* Exploring structure with `glimpse()`
  
  ```
  glimpse(flights)
  ```
  Output (shortened):
  
  ```
      Rows: 336,776
    Columns: 19
    $ year     <int> 2013, 2013, 2013, ...
    $ month    <int> 1, 1, 1, 1, ...
    $ dep_time <int> 517, 533, 542, ...
    $ dep_delay <dbl> 2, 4, 2, -1, ...
    $ carrier  <chr> "UA", "UA", "AA", ...
    $ time_hour <dttm> 2013-01-01 05:00:00, ...
  ```
  
  >[!TIP]
  >Here, variable types are shown:

    * `<int>` = integer

    * `<dbl>` = double (decimal numbers)

    * `<chr>` = character (text)

    * `<dttm`> = date-time

* Viewing options
  * `view(flights)` → opens an interactive spreadsheet in RStudio.

  * `print(flights, width = Inf)` → shows all columns in the console.

  * `glimpse(flights)` → 
  

>[!TIP]
>The flights tibble contains `336,776 rows` × `19 columns` about NYC flights in 2013. Tibbles print neatly, and you can inspect their structure with `view()`, `print(width=Inf)`, or `glimpse()`. Column types (int, dbl, chr, dttm) are key, since the operations you can apply depend on the type.


* `What is a tibble?` 
    * A `tibble` is a modern version of a data frame, created by the `tibble package` (part of the tidyverse).
  
    * It improves how data frames behave:
    
       * Printing → Only shows the first 10 rows and only the columns that fit on screen.
      
       * Column types → Always displayed (so you know if a column is integer, double, text, etc.).
      
       * Strings → Stay as character by default (unlike data.frame(), which may turn them into factors unless you tell it not to).
      
       * Subsetting → Tibbles are stricter, helping avoid confusing results.
       
    * How to create a tibble
      You can use the `tibble()` function:
      
      ```
        library(tibble)
    
        # Create a tibble
        tb <- tibble(
        ID = c("N198", "N805", "N333"),
        Age = c(30, 60, 26),
        Blood = c(0.4, 0.2, 0.6)
        )
    
        tb
      ```
      Output:
      
      ```
        # A tibble: 3 × 3
        ID      Age Blood
        <chr> <dbl> <dbl>
        1 N198     30   0.4
        2 N805     60   0.2
        3 N333     26   0.6
      ```
      >[!NOTE]
      > Notice how it prints neatly, shows types (`<chr>`, `<dbl>`), and      doesn’t overwhelm you with all rows.
      
      
    * Converting a data frame to tibble
    
      If you already know data.frame(), you can convert it:
      
      ```
        df <- data.frame(
          ID = c("N198","N805","N333"), Age = c(30,60,26), 
          Blood = c(0.4,0.2,0.6)
        )
  
        tb2 <- as_tibble(df)   # convert to tibble
        tb2
      ```
      
      > [!NOTE]
      > In short:A tibble is just a better data frame. You create it with `tibble()`, or by converting with `as_tibble()`. It prints nicely, keeps characters as characters, shows types, and avoids surprises when subsetting.
      
    * Tibble Subsetting Cheatsheet  

      | Operation                | Example                   | What it returns |
      |--------------------------|---------------------------|-----------------|
      | Select a column by name  | `tb["x"]`                 | A **tibble** (1 column) |
      | Extract column as vector | `tb[["x"]]` or `tb$x`     | A **vector** |
      | Select multiple columns  | `tb[c("x","y")]`          | A **tibble** with 2 columns |
      | Select rows & columns    | `tb[1:2, ]`               | First 2 rows (tibble) |
      | Access by row + column   | `tb[2, "x"]`              | A **tibble** (single cell, still tibble-like) |
      | Column does not exist    | `tb[ , "not_exist"]`      | ❌ **Error** (`Column not_exist not found`) |
      
      For example:
      
      ```
        library(tibble)
  
        tb <- tibble(x = 1:3, y = letters[1:3])
        
        tb["x"]       # tibble with 1 column
        tb[["x"]]     # numeric vector
        tb$x          # numeric vector
        tb[c("x","y")] # tibble with both columns
        tb[1:2, ]     # first two rows
        tb[2, "x"]    # tibble with 1 cell
      ```

  
  

###### 3.1.1 dplyr basics

The `dplyr package` has special functions (called `verbs`) that make it easier to work with data.

What all `dplyr verbs` have in common:

   1. The first input is always your data frame (like `flights`).
  
   2. You refer to columns directly by name (no quotes).
  
   3. The result is always a new data frame.
  
   4. You can combine steps using the pipe `|>` (read as “then”).
  


The Pipe `|>`

Think of `|>` as saying “then”.

```
  x |> f(y)         # same as f(x, y)
  x |> f(y) |> g(z) # same as g(f(x, y), z)
```

>[!IMPORTANT]
>This makes your code easier to read step by step.

Example with flights

Let’s say we want the *average arrival delay* of flights going to *Houston* (IAH), grouped by *day*.

```
  flights |> 
    filter(dest == "IAH") |>       # keep flights going to IAH
    group_by(year, month, day) |>  # group the data by date
    summarize(
      avg_delay = mean(arr_delay, na.rm = TRUE)  # calculate mean delay
    )
```

Output (first few rows):

```
  # A tibble: 365 × 4
     year month   day avg_delay
    <int> <int> <int>     <dbl>
  1  2013     1     1      7.33
  2  2013     1     2     -6.45
  3  2013     1     3      2.80
  ...
```

Groups of dplyr verbs

* Row verbs → pick rows

    * Example: `filter()` → choose rows that match a condition

* Column verbs → pick or change columns

    * Example: `select()` → choose specific columns

    * Example: `mutate()` → create new columns

* Group verbs → group data before summarizing

    * Example: `group_by()` + `summarize()`

* Table verbs → combine multiple datasets (you’ll learn later, e.g. `join())`

>[!TIP]
>In short:  
>dplyr verbs always start with your data.  
> * Use the pipe |> to say “then” and connect steps.  
> * Learn the main verbs: filter(), select(), mutate(), arrange(),   
> * summarize(), and group_by().  
 
      
##### 3.2 Rows

`Row` Verbs in `dplyr`

When working with data, sometimes you only want certain rows or you want to reorder them. The main dplyr verbs for rows are:

  1. `filter()` → keeps rows that match a condition (doesn’t change order).
  
  2. `arrange()` → changes the order of rows (doesn’t remove any).
  
  3. `distinct()` → keeps only unique rows (can also check uniqueness on specific columns).

>[!NOTE]
> These functions only affect rows, not columns (except `distinct()` if you tell it to).

###### 3.2.1 `filter()` – keep rows that match conditions
  
  `filter()` lets you keep only the rows that meet certain conditions.
  
  ```
    # Flights with departure delay greater than 120 minutes
    flights |> filter(dep_delay > 120)
  
  ```
  Output (first rows, tibble preview):
  
  ```
      # A tibble: 9,723 × 19
         year month day dep_time dep_delay arr_time arr_delay carrier ...
        2013     1   1      848       853     1001      851    MQ
        2013     1   1      957       144     1056      123    UA
    ...
  
  ```
  
  >[!NOTE]
  > You can use comparisons:
  > * `>` greater than
  > * `<` less than
  > * `>=` greater or equal
  > * `<=` less or equal
  > * `==` equal to
  > * `!=` not equal to
  
  
  Combine conditions
  
  ```
    # Flights on January 1
    flights |> filter(month == 1 & day == 1)
    
    # Flights in January OR February
    flights |> filter(month == 1 | month == 2)
    
    # Shortcut using %in%
    flights |> filter(month %in% c(1, 2))
  ```
  
  > [!NOTE]
  > `%in%` is a shortcut for checking multiple values.
  
  
  Saving results
  
  ```
  jan1 <- flights |> filter(month == 1 & day == 1)
  
  ```
  
  >[!CAUTION]
  > Common mistakes
  > Using `=` instead of `==`:
  
  ```
    flights |> filter(month = 1)  
    # Error: Did you mean `month == 1`?
  
  ```
  >[!CAUTION]
  > Writing conditions like English:
  
  ```
    flights |> filter(month == 1 | 2)
    # Doesn’t work as expected!
  
  ```


###### 3.2.3 `arrange()` – reorder rows

  `arrange()` reorders rows based on column values.
  
  ```
    # Sort flights by year, month, day, and departure time
    flights |> arrange(year, month, day, dep_time)
  
  ```
  `Earliest flights appear first.`
  
  ```
    # Sort by largest delay first
    flights |> arrange(desc(dep_delay))
  
  ```
  `Flights with longest delays at the top.`
  
  > [!NOTE]
  > `arrange()` only changes the order, not the number of rows.

###### 3.2.4 `distinct()` – unique rows

  `distinct()` removes duplicates.
  
  ```
    # Unique destinations
    flights |> distinct(dest)
    
    # Unique origin-destination pairs
    flights |> distinct(origin, dest)
  
  ```
  Example output:
  
  ```
    # A tibble: 224 × 2
      origin dest
      <chr>  <chr>
    1 EWR    IAH
    2 LGA    IAH
    3 JFK    MIA
    ...
  ```
  Keep all other columns with `.keep_all = TRUE`:
  
  ```
  flights |> distinct(origin, dest, .keep_all = TRUE)
  
  ```
  
  *Counting instead of distinct* 
  
  If you want to know how many times each pair occurs, use count():
  
  ```
    flights |> count(origin, dest, sort = TRUE)
  
  ```
  
  Example output:
  
  ```
    # A tibble: 224 × 3
      origin dest      n
      <chr>  <chr> <int>
    1 JFK    LAX   11262
    2 LGA    ATL   10263
    3 LGA    ORD    8857
    ...
  
  ```

>[!TIP]
> Summary
> * `filter()` → keep rows matching conditions (e.g., delays, dates).
> * `arrange()` → reorder rows (ascending or descending).
> * `distinct()` → keep only unique rows (optionally keep other columns).
> * `count()` → count how often each combination appears.


>[!TIP]
> In `filter(),` commas act like `&`.
> So `filter(a, b) = filter(a & b)`.
> If you want “or”, you must use `|` (there’s no comma shortcut for “or”).

```
  filter(dep_delay >= 60, (dep_delay - arr_delay) > 30) 
  # same as
  filter(dep_delay >= 60 & (dep_delay - arr_delay) > 30)

```

>[!TIP]
> `na.rm = TRUE` → "drop missing values before doing the calculation".
> Without it, many summary functions (`mean()`, `sum()`, `min()`, etc.) will give back NA if there’s even one missing value.

```
  flights |> 
    summarise(avg_delay = mean(dep_delay, na.rm = TRUE))
```



>[!TIP]
> `n()` is a special dplyr function that simply counts how many rows are in each group.
> * If no grouping, it counts all rows.
> * If grouped, it counts rows per group.
> * The left-hand side (n) is just the column name you want to give to the result.
> * The right-hand side (n()) is the function that does the counting.

Example without grouping:

```
  flights |> 
    summarise(n = n())

```
Output:
```
  # A tibble: 1 × 1
        n
    <int>
  1 336776

```

###### 3.2.5 Exercises

1. In a single pipeline for each condition, find all flights that meet the condition:

  * Had an arrival delay of two or more hours
  * Flew to Houston (IAH or HOU)
  * Were operated by United, American, or Delta
  * Departed in summer (July, August, and September)
  * Arrived more than two hours late but didn’t leave late
  * Were delayed by at least an hour, but made up over 30 minutes in flight
  
  *Solution*
  
  ```
  # Arrival delay of two or more hours
  flights |> filter(arr_delay >= 120)
  
  # Flew to Houston (IAH or HOU)
  flights |> filter(dest %in% c("IAH","HOU"))
  
  # Were operated by United, American, or Delta
  flights |> filter(carrier %in% c("UA", "AA", "DL"))
  
  # Departed in summer (July, August, and September)
  flights |> filter(month %in% 7:9)
  
  #Arrived more than two hours late but didn’t leave late
  flights |> filter(arr_delay > 120 & dep_delay == 0)
  
  # Were delayed by at least an hour, but made up over 30 minutes in flight
  filter(dep_delay >= 60, (dep_delay - arr_delay) > 30)
  
  ```
  
2. Sort flights to find the flights with the longest departure delays. Find the flights that left earliest in the morning.
  
  *Solution*
  ```
  flights |> 
  arrange(desc(dep_delay)) |> 
  head()
  ```
  
3. Sort flights to find the fastest flights. (Hint: Try including a math calculation inside of your function.)
 
 *Solution*
  ```
    flights |>
      filter(!is.na(air_time), air_time > 0) |>       # keep valid rows
      arrange(desc(distance / air_time * 60)) |>      # compute mph inside arrange
      head(10)
  
  ```
  
  >[!TIP]
  > What’s happening on above solution?
  > `distance / air_time * 60` is the speed in miles per hour.
  > `arrange(desc(...))` sorts from fastest to slowest.
  > `head(10)` just shows the first 10 fastest flights.
  > speed = distance / time
  
4. Was there a flight on every day of 2013?

  *Solution*
  ```
  flights |>
    distinct(year, day, month) |>
    summarise(n_days=n())
  
  ```

5. Which flights traveled the farthest distance? Which traveled the least distance?

  *Solution*
  ```
    # Farthest flight(s)
    flights |>
      filter(distance == max(distance, na.rm = TRUE)) |>
      select(year, month, day, carrier, flight, origin, dest, distance)
    
    # Shortest flight(s)
    flights |>
      filter(distance == min(distance, na.rm = TRUE)) |>
      select(year, month, day, carrier, flight, origin, dest, distance)
  
  ```
  >[!TIP]
  > What happens above: 
  > `max(distance, na.rm = TRUE)` → finds the longest distance, ignoring any missing values.  
  > `min(distance, na.rm = TRUE)` → finds the shortest distance.  
  > `filter()` → keeps only rows that match those values.  
  > `select()` → just displays useful columns so the output is clear.  
  
  
6. Does it matter what order you used `filter()` and `arrange()` if you’re using both? Why/why not? Think about the results and how much work the functions would have to do.

  *Solution*  
  Yes — the results are the same, but the amount of work R has to do is different depending on the order.
    * `filter()` first: You reduce the dataset to only the rows you care about, then sort them. This is usually faster and more efficient.
    * `arrange()` first: You sort the entire dataset before filtering. This is slower and unnecessary work, because many rows will be discarded after filtering anyway.
    
  > [!IMPORTANT]
  > The final result looks the same.
  > But filtering first is better because R only sorts the smaller dataset, not the whole thing.
  
  >[!TIP]
  >Rule of thumb: Filter early, arrange later.

### 4.1 dplyr verbs: select, mutate, filter, arrange

### 4.2 More dplyr verbs: group_by and summarise
### 4.3 Further Reading

## Summary
