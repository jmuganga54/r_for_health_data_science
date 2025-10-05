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
  


**The Pipe `|>`**

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

**Groups of dplyr verbs**

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
  
  **Counting instead of distinct** 
  
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
  
  **Solution**
  
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
  
  **Solution**
  ```
  flights |> 
  arrange(desc(dep_delay)) |> 
  head()
  ```
  
3. Sort flights to find the fastest flights. (Hint: Try including a math calculation inside of your function.)
 
 **Solution**
  ```
    flights |>
      filter(!is.na(air_time), air_time > 0) |>       # keep valid rows
      arrange(desc(distance / air_time * 60)) |>      # compute mph inside arrange
      head(10)
  
  ```
  
  >[!TIP]
  > What’s happening on above solution?
  > * `distance / air_time * 60` is the speed in miles per hour.
  > * `arrange(desc(...))` sorts from fastest to slowest.
  > * `head(10)` just shows the first 10 fastest flights.
  > * speed = distance / time
  
4. Was there a flight on every day of 2013?

  **Solution**
  ```
  flights |>
    distinct(year, day, month) |>
    summarise(n_days=n())
  
  ```

5. Which flights traveled the farthest distance? Which traveled the least distance?

  **Solution**
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
  > * `max(distance, na.rm = TRUE)` → finds the longest distance, ignoring any missing values.  
  > * `min(distance, na.rm = TRUE)` → finds the shortest distance.  
  > * `filter()` → keeps only rows that match those values.  
  > * `select()` → just displays useful columns so the output is clear.  
  
  
6. Does it matter what order you used `filter()` and `arrange()` if you’re using both? Why/why not? Think about the results and how much work the functions would have to do.

  **Solution**  
  
  **Yes**, the results will be the same, but the amount of work R does depends on the order you use:  
    * `filter()` first: Narrow down the dataset to only the rows you need, then sort them.       
      ✅ Faster and more efficient.    
    * `arrange()` first: Sort the entire dataset (even rows you’ll later throw away), then filter.   
      ❌ Slower and unnecessary extra work.  
 
    
  > [!IMPORTANT]
  > * The final result looks the same.  
  > * But filtering first is better because R only sorts the smaller dataset, not the whole thing.
  
  >[!TIP]
  >Rule of thumb: Filter early, arrange later.
  
##### 3.3 Columns

There are four main verbs in `dplyr` that work with columns (without changing rows):  

  * `mutate()` → create new columns.
  
  * `select()` → choose which columns to keep.
  
  * `rename()` → rename columns.
  
  * `relocate()` → move columns around.
  
###### 3.3.1 mutate() – Create new columns

  `mutate()` adds new variables that are calculated from existing ones.
  
  ```
    flights |> 
      mutate(
        gain = dep_delay - arr_delay,        # time made up in air
        speed = distance / air_time * 60     # flight speed in mph
      )
  
  ```
  >[!NOTE]
  > Adds gain and speed as new columns.
  
  **You can control where new columns appear:**
  ```
    flights |> 
    mutate(gain = dep_delay - arr_delay, .before = 1)   # add before first column

  ```
  
  **Or only keep the columns you used:**
  
  >[!TIP]
  > What .keep = "used" means
  > * Normally, when you use `mutate()`, your new columns are added to the existing dataset — so you still see all the original columns.
  > * But sometimes you only want to see the columns that were involved in the calculation (to keep things clean).
  > * That’s what `.keep = "used"` does — it tells R:
  > * “Only keep the columns I used or created in this mutate step.”
  
  ```
    flights |> 
    mutate(
      gain = dep_delay - arr_delay,
      hours = air_time / 60,
      gain_per_hour = gain / hours,
      .keep = "used"
    )

  ```
  This code will return a tibble with only these columns:
  
  ```
    dep_delay, arr_delay, air_time, gain, hours, gain_per_hour

  ```
  >[!NOTE]
  > * Instead of showing all 19 original columns from flights.
  > * ✅ Useful when you just want to focus on your calculated results.
  
  >[!IMPORTANT]
  > * ⚠️ Remember: unless you assign with `<-`, the new columns won’t be saved.
  > * When you run a command like the one above, R prints the result, but it doesn’t save it anywhere.
  > * That means if you type `flights` again later, it will still be the old version — your new columns are gone.
  > * To save your new data frame, you must assign it to an object using `<-`:
  
  ```
    flights_summary <- flights |> 
    mutate(
      gain = dep_delay - arr_delay,
      hours = air_time / 60,
      gain_per_hour = gain / hours,
      .keep = "used"
  )

  ```
  Now, `flights_summary` keeps those new columns and you can use it later.
  
  >[!TIP]
  > * `.keep = "used"` → keeps only columns used or created.
  > * `<-` → saves your result to a new dataset (otherwise it disappears after printing).
  
  
###### 3.3.2 `select()` – Pick columns
  **`select()` helps you focus on specific columns.**
  ```
    flights |> select(year, month, day)          # pick specific columns
    flights |> select(year:day)                  # pick a range of columns
    flights |> select(!year:day)                 # drop a range of columns
    flights |> select(where(is.character))       # keep only character columns

  ```
  **You can also rename while selecting:**
  
  You can rename columns directly inside `select()` by using `=`
  
  – the new name goes on the `left`, and the old name on the `right`.
  
  ```
    flights |> select(tail_num = tailnum)
  ```
  
  This keeps the column tailnum but shows it as tail_num in the output.
    
  **Check columns names**
  
  ```
    colnames(flights)

  ```
  
  **Helper Functions in `select()`**
  
  | Function              | What It Does                                   | Example                       | Result                         |
| --------------------- | ---------------------------------------------- | ----------------------------- | ------------------------------ |
| `starts_with("abc")`  | Selects columns that **start with** `"abc"`    | `select(starts_with("dep"))`  | Picks `dep_time`, `dep_delay`  |
| `ends_with("xyz")`    | Selects columns that **end with** `"xyz"`      | `select(ends_with("time"))`   | Picks `dep_time`, `arr_time`   |
| `contains("ijk")`     | Selects columns that **contain** `"ijk"`       | `select(contains("delay"))`   | Picks `dep_delay`, `arr_delay` |
| `num_range("x", 1:3)` | Selects numbered columns like `x1`, `x2`, `x3` | `select(num_range("x", 1:3))` | Picks `x1`, `x2`, `x3`         |


    
    
  
###### 3.3.2 `rename()` – Rename columns
  ```
    flights |> rename(tail_num = tailnum)
  ```
  >[!NOTE]
  > * Same as `select()`, but it doesn’t drop any columns.
  
  **Cleaning Column Names Automatically**
  
  Sometimes your dataset has messy or inconsistent column names, like this:
  
  ```
    data <- data.frame(
    "Flight Number" = c(1, 2),
    "Departure Time" = c("10:00", "12:00"),
    "Arrival-Time" = c("11:30", "13:30")
  )
  
  colnames(data)
  ## [1] "Flight Number" "Departure Time" "Arrival-Time"

  ```
  
  Typing those long names with spaces or symbols is annoying 😩.
  
  You can fix them automatically using the `janitor` package:
  
  ```
    library(janitor)
    
    clean_data <- data |> clean_names()
    colnames(clean_data)
    ## [1] "flight_number" "departure_time" "arrival_time"

  ```
  ✅ Now all column names are lowercase, use underscores instead of spaces, and are easy to type.
  
  >[!TIP]
  > * Use `janitor::clean_names()` to automatically tidy up column names —
it converts them into clean, consistent, and R-friendly names.

###### 3.3.4 `relocate()` – Move columns
  **Reorder columns to make the dataset easier to read.**
  ```
    flights |> relocate(time_hour, air_time)   # move to the front
  ```
  **You can also move columns relative to others:**
  ```
    flights |> relocate(year:dep_time, .after = time_hour)   # move after time_hour
    flights |> relocate(starts_with("arr"), .before = dep_time) # move before dep_time
  ```
###### 3.3.5 Exercises
1. Compare `dep_time`, `sched_dep_time`, and `dep_delay`. How would you expect those three numbers to be related?

  **Solution**
  
  __The three variables__
  
  | Column           | Meaning                                                                                 |
  | ---------------- | --------------------------------------------------------------------------------------- |
  | `dep_time`       | The **actual departure time** of the flight                                             |
  | `sched_dep_time` | The **scheduled (planned)** departure time                                              |
  | `dep_delay`      | The **difference** (in minutes) between the two — how early or late the flight departed |
  

  
  *How they are related*
  
  You can think of it as a simple relationship:
  ```
    dep_delay = dep_time - sched_dep_time
  ```
  
  (but measured in minutes, not clock time).
  
  
  >[!NOTE]
  > What to expect
  > * If a flight left on time, then
  >   `dep_delay = 0`
  > * If a flight left late, then
  >  `dep_delay` is positive (`dep_time` > `sched_dep_time`).
  > * If a flight left early, then
  >  `dep_delay` is negative (`dep_time` > `sched_dep_time`).
  
  **Example in R**
  ```
  flights |>
    select(dep_time, sched_dep_time, dep_delay) |>
    head(10)

  ```
  Example output:
  
  ```
    # A tibble: 10 × 3
     dep_time sched_dep_time dep_delay
        <int>          <int>     <dbl>
   1      517            515         2
   2      533            529         4
   3      542            540         2
   4      544            545        -1
   5      554            600        -6
   6      554            558        -4
   7      555            600        -5
   8      557            600        -3
   9      557            600        -3
  10      558            600        -2

  ```
  >[!NOTE]
  > * You can see that when `dep_time` is later than `sched_dep_time`,
  > * `dep_delay` is positive — meaning the flight was late.
  > * When it’s earlier, the delay is negative — meaning it left early.
  
  >[!TIP]
  > * `dep_time` = actual departure time
  > * `sched_dep_time` = planned departure time
  > * `dep_delay` = the difference (in minutes) between them
  > → A positive value = left late, negative = left early, zero = on time.


2. Brainstorm as many ways as possible to select `dep_time`, `dep_delay`, `arr_time`, and `arr_delay` from flights.
  
  ```
  # Easiest (name them directly)
  flights |> select(dep_time, dep_delay, arr_time, arr_delay)
  
  #Using a vector of names (handy if you reuse it)
  cols <- c("dep_time", "dep_delay", "arr_time", "arr_delay")
  flights |> select(all_of(cols))    # strict: errors if a name is missing
  flights |> select(any_of(cols))    # forgiving: ignores missing names
  
  # Pattern helpers (tidyselect)
  #By prefix (safe & concise):
  flights |> select(starts_with("dep") | starts_with("arr"))
  
  # By exact regex pattern (most precise):
  flights |> select(matches("^(dep|arr)_(time|delay)$"))
  
  # Base R equivalents (no dplyr)
  #Direct column name vector:
  flights[,c("dep_time", "dep_delay", "arr_time", "arr_delay")]
  
  # With a regex on names:
  flights[, grepl("^(dep|arr)_(time|delay)$", names(flights))]
  
  # Using subset() (base R helper):
  subset(flights, select =c(dep_time, dep_delay, arr_time, arr_delay))

  ```
  >[!TIP]
  > Rule of thumb:
  > * Use exact names for clarity.
  > * Use `starts_with()` or `matches()` when patterns make the code shorter and safer.
  > * Use `all_of()` / `any_of()` when selecting from a dynamic list of names.
  
3. What happens if you specify the name of the same variable multiple times in a select() call?

  **Solution**
  If you use `select()` and repeat the same column name multiple times,
  
  👉 `R` will only keep one copy of that column in the result.

  In other words — duplicates are ignored automatically.
  
  Example
  
  Let’s try it with the flights dataset:
  
  ```
  flights |> 
  select(year, month, day, dep_time, dep_time)

  ```
  ✅ Output (simplified):
  
  ```
    # A tibble: 336,776 × 4
      year month   day dep_time
     <int> <int> <int>    <int>
   1  2013     1     1      517
   2  2013     1     1      533
   3  2013     1     1      542
   4  2013     1     1      544
   5  2013     1     1      554

  ```
  >[!NOTE]
  > Notice that `dep_time` only appears once, even though we wrote it twice.
  
  💡 Why?
  `select()` always returns a unique set of column names —   
  so repeating a column doesn’t add extra copies or change the result.
  
  
4. What does the `any_of()` function do? Why might it be helpful in conjunction with this vector?

```
variables <- c("year", "month", "day", "dep_delay", "arr_delay")
```
  **Solution**
  
  What `any_of()` does
  
  `any_of()` is used inside `select()` (or similar functions) to safely select columns based on a list (vector) of names.
  
  If some names in that list don’t actually exist in the dataset,
  👉 `any_of()` just ignores them, instead of giving an error.
  
  Example
  
  You want to select those columns from the flights data:
  
  ```
  flights |> select(any_of(variables))

  ```
  ✅ Output (first few rows):
  
  ```
    # A tibble: 336,776 × 5
      year month   day dep_delay arr_delay
     <int> <int> <int>     <dbl>     <dbl>
   1  2013     1     1         2        11
   2  2013     1     1         4        20
   3  2013     1     1         2        33
   4  2013     1     1        -1       -18
   5  2013     1     1        -6       -25

  ```
  **Why it’s useful**
  
  If one of the names in your vector doesn’t exist — for example:
  
  ```
    variables <- c("year", "month", "day", "dep_delay", "arr_delay", "not_exist")

  ```
  then:
  
  * Using `all_of()` will cause an error ❌
  * Using `any_of()` will ignore the missing name and still work ✅

  ```
  # This works fine, ignoring "not_exist"
  flights |> select(any_of(variables))

  ```

5. Does the result of running the following code surprise you? How do the select helpers deal with upper and lower case by default? How can you change that default?

```
  flights |> select(contains("TIME"))

```
  **Solution**
  
  We’re using `select(contains("TIME"))` to find all columns that contain the word “TIME” in their names.
  
  ```
  flights |> select(contains("TIME"))
  ```
  
  **What happens?**
  
  By default, `contains()` in `dplyr` is not case-sensitive —  
  meaning it ignores uppercase or lowercase differences.
  
  So, even though the dataset has columns like `dep_time`, `arr_time`, and `sched_dep_time` (all lowercase), 
  
  `contains("TIME")` will still match them ✅.
  
  ✅ Output (simplified)
  
  ```
    # A tibble: 336,776 × 4
     dep_time sched_dep_time arr_time sched_arr_time
        <int>          <int>    <int>          <int>
   1      517            515      830            819
   2      533            529      850            830
   3      542            540      923            850
   4      544            545     1004           1022

  ```
  >[!NOTE]
  > * So even though we used uppercase "TIME",
  > * it found all the lowercase columns that contain “time”.
  
  **How to make it case-sensitive**
  
  If you want to match exactly how the column name is written
  
  (e.g., match only uppercase “TIME”), use the argument `ignore.case = FALSE`.
  
  ```
   flights |> select(contains("TIME", ignore.case = FALSE))
  ```
  ✅ Output:
  
  ```
  # A tibble: 336,776 × 0
  # ℹ Use `print(n = ...)` to see more rows

  ```
  
  >[!NOTE]
  > By default, `select()` helper functions like `contains()`, `starts_with()`, and `ends_with()` ignore uppercase/lowercase differences.
You can change that using `ignore.case = FALSE` if you want exact case matching.
  
  
6. Rename `air_time` to `air_time_min` to indicate units of measurement and move it to the beginning of the data frame.

  **Solution**
  We can do both tasks at once using `rename()` and `relocate()` from `dplyr`.
  ```

  flights |> 
    rename(air_time_min = air_time) |>     # Rename the column
    relocate(air_time_min, .before = 1)    # Move it to the first column
  ```
  
  **Output (simplified)**
  
  ```
    # A tibble: 336,776 × 19
     air_time_min  year month   day dep_time sched_dep_time dep_delay arr_time
            <dbl> <int> <int> <int>    <int>          <int>     <dbl>    <int>
   1          227  2013     1     1      517            515         2      830
   2          227  2013     1     1      533            529         4      850
   3          160  2013     1     1      542            540         2      923
   4          183  2013     1     1      544            545        -1     1004

  ```
  >[!TIP]
  > You can also move the column by name instead of position:
  
  ```
  flights |> 
  rename(air_time_min = air_time) |> 
  relocate(air_time_min, .before = year)

  ```
  Both give the same result. ✅
  
7. Why doesn’t the following work, and what does the error mean?

```
  flights |> 
    select(tailnum) |> 
    arrange(arr_delay)
  #> Error in `arrange()`:
  #> ℹ In argument: `..1 = arr_delay`.
  #> Caused by error:
  #> ! object 'arr_delay' not found
```
  
  **Solution**
  
  💥 What Happened
  1. In the first step,
  
  ```
    select(tailnum)
  ```
  you kept only one column — `tailnum`.
  
  2. Then, you tried to sort the data by arr_delay:
  
  ```
  arrange(arr_delay)

  ```
  But since `arr_delay` was removed in the first step,  
  R doesn’t know what it is — it’s not in your data anymore! 
  
  ✅ **The Fix**
  You have two main options depending on what you want:
  
  **Option 1: Keep both columns**
  If you want to arrange by `arr_delay`, keep it in the data:
  
  ```
    flights |> 
    select(tailnum, arr_delay) |> 
    arrange(arr_delay)

  ```
  💡 Now R knows what `arr_delay` is — because it’s still in your dataset!
  
  **Option 2: Arrange first, then select**
  If you only want to see `tailnum` but sort by delay:
  
  ```
    flights |> 
    arrange(arr_delay) |> 
    select(tailnum)

  ```
  ✅ This works because you sort before removing arr_delay.
  
  >[!IMPORTANT]
  > Key Takeaway
  > * You can’t arrange (or filter) by a column that no longer exists in your dataset.
  > * So, the order of functions matters when chaining with the pipe |>.
  

##### 3.4 The pipe 
  
  Chain small steps with the `pipe`
  
  The pipe `(|>)` lets you write data steps in the order you think:  
  take `data` then `filter` then `create a column` then `pick columns` then `sort.`
  
  ```
  flights |>
    filter(dest == "IAH") |>                          # keep flights to IAH
    mutate(speed = distance / air_time * 60) |>       # mph = miles / (min/60)
    select(year:day, dep_time, carrier, flight, speed) |> 
    arrange(desc(speed))                               # fastest first
  ```
  
  Example output (first rows):
  
  ```
    # A tibble: 7,198 × 7
     year month   day dep_time carrier flight speed
    <int> <int> <int>    <int> <chr>    <int> <dbl>
  1  2013     7     9      707 UA         226  522.
  2  2013     8    27     1850 UA        1128  521.
  3  2013     8    28      902 UA        1711  519.
  ...

  ```
  `Why this is nice`: the verb starts each line, so it reads like a recipe.
  
  **Without the pipe (harder to read)**
  
  a) **Nested calls (inside-inside-inside)**
  
  ```
    arrange(
    select(
      mutate(
        filter(flights, dest == "IAH"),
        speed = distance / air_time * 60
      ),
      year:day, dep_time, carrier, flight, speed
    ),
    desc(speed)
  )

  ```
  
  b) **Many temporary objects**
  
  ```
  flights1 <- filter(flights, dest == "IAH")
  flights2 <- mutate(flights1, speed = distance / air_time * 60)
  flights3 <- select(flights2, year:day, dep_time, carrier, flight, speed)
  arrange(flights3, desc(speed))

  ```
  Both work, but the pipe is usually easier to write and read.
  
  >[!TIP]
  >How to insert the pipe quickly
  > * RStudio shortcut: Ctrl/Cmd + Shift + M
  
  >[!TIP]
  > If your shortcut still inserts `%>%`, here’s how to switch it:
  > * Go to Tools ▸ Global Options
  > * Select Code ▸ Editing
  > * Under “Use native pipe operator when inserting with Ctrl+Shift+M”,
  > * ✅ Check the box that says Use native pipe operator (|>) instead of %>%
 > * Click Apply or OK
 
 `%>%` vs `|>` (which pipe?)
 
  You’ll see two pipes in R code:

  * Base pipe `|>` (recommended): built into R (since 4.1), simple, always available.

  * magrittr pipe `%>%` (from magrittr / tidyverse): very common in older tutorials.

  Both behave the same in simple cases:
  
  ```
  mtcars %>%                      # magrittr pipe
  group_by(cyl) %>%
  summarize(n = n())
  
  mtcars |>                       # base pipe
  group_by(cyl) |>
  summarize(n = n())

  ```
  
  >[!NOTE]
  > Recommendation: Learn `|>` for modern/base R; understand `%>%` because you’ll see it in lots of examples.
  
##### 3.3 Groups
So far, you’ve learned how to manipulate rows and columns.

Now, you’ll learn how to analyze data by groups — for example, finding the average delay per month or the longest flight per destination.

The main functions are:

The main functions are:

  * `group_by()` → divides data into groups
  
  * `summarise()` → calculates summary values for each group
  
  * `slice_*()` → extracts specific rows within each group
  
  * `ungroup()` → removes grouping
  
  * `.by` → an easier alternative for temporary grouping


  ###### 3.5.1 group_by()
  
  Use `group_by()` to split your dataset into smaller groups before applying another function.
  
  ```
    flights |> 
    group_by(month)

  ```
  >[!NOTE]
  > * The data doesn’t change — it just becomes grouped.
  > * You’ll see something like this in the output:
  
  ```
    # Groups: month [12]

  ```
  >[!IMPORTANT]
  > That means R will now treat each month as a separate group when doing calculations.
  
  ###### 3.5.2 `summarise()`
  
  `summarise()` calculates summary values (like mean, count, etc.) for each group.

  Example — find the average departure delay per month:
  
  ```
    flights |> 
    group_by(month) |> 
    summarize(avg_delay = mean(dep_delay, na.rm = TRUE))

  ```
  
  Output (simplified):
  
  ```
    # A tibble: 12 × 2
     month avg_delay
     <int>     <dbl>
  1      1      10.0
  2      2      10.8
  ...

  ```
  >[!NOTE]
  > `na.rm = TRUE` tells R to ignore missing values (NA).
  
  You can also get the number of flights per month:
  
  ```
    flights |> 
    group_by(month) |> 
    summarise(
      avg_delay = mean(dep_delay, na.rm = TRUE),
      n = n()   # counts rows in each group
    )

  ```
  
  ###### 3.5.3 The`slice_*()` Family
  
  These functions help you extract specific rows within each group:
  
    | Function              | Description                       |
  | --------------------- | --------------------------------- |
  | `slice_head(n = 1)`   | First row in each group           |
  | `slice_tail(n = 1)`   | Last row in each group            |
  | `slice_min(x, n = 1)` | Row(s) with smallest value of `x` |
  | `slice_max(x, n = 1)` | Row(s) with largest value of `x`  |
  | `slice_sample(n = 1)` | Random row(s) from each group     |
  
  Example — find the most delayed flight for each destination:
  
  ```
    flights |> 
    group_by(dest) |> 
    slice_max(arr_delay, n = 1) |> 
    relocate(dest)
  ```
  >[!IMPORTANT]
  > ⚠️ Sometimes you’ll see more than one row per group if multiple flights have the same delay.
  > Add `with_ties = FALSE` to keep only one.
  
  ###### 3.5.4 Grouping by Multiple Variables
  
  You can group by more than one variable, like `year`, `month`, and `day`:
  
  ```
    daily <- flights |> group_by(year, month, day)
  ```
  
  Then summarize:
  
  ```
    daily |> 
    summarise(
      n = n(),
      .groups = "drop_last"  # keeps grouping by year and month only
    )
  ```
  >[!NOTE]
  > Other `.groups` options:
  > * "drop" → remove all grouping
  > * "keep" → keep all original groups
  
  ###### 3.5.5 `ungroup()`
  
  Removes grouping completely:
  
  ```
    daily |> ungroup()
  ```
  Now every operation works on the whole dataset again, not per group.
  
  ```
    daily |> 
    ungroup() |> 
    summarise(
      avg_delay = mean(dep_delay, na.rm = TRUE),
      flights = n()
    )

  ```
  Output:
  
  ```
    # A tibble: 1 × 2
    avg_delay flights
        <dbl>   <int>
  1      12.6  336776

  ```
  
  ###### 3.5.6 .by (New in dplyr 1.1.0)
  
  Instead of using group_by(), you can group directly inside a function with .by.
  
  Example:
  
  ```
    flights |> 
    summarise(
      delay = mean(dep_delay, na.rm = TRUE),
      n = n(),
      .by = month
    )

  ```
  
  Or with multiple variables:
  
  ```
    flights |> 
    summarise(
      delay = mean(dep_delay, na.rm = TRUE),
      n = n(),
      .by = c(origin, dest)
    )

  
  ```
  ✅ It’s simpler because you don’t need to remember to ungroup() afterward.
  
  >[!TIP] Summary
  
    | Function      | Purpose                                     |
  | ------------- | ------------------------------------------- |
  | `group_by()`  | Create groups for analysis                  |
  | `summarise()` | Calculate summary stats per group           |
  | `slice_*()`   | Extract specific rows per group             |
  | `ungroup()`   | Remove grouping                             |
  | `.by`         | Group temporarily within a single operation |

  
  
  
  
  
  


  
  
  
  
  
  
  
  
  
  
  
  

### 4.1 dplyr verbs: select, mutate, filter, arrange

### 4.2 More dplyr verbs: group_by and summarise
### 4.3 Further Reading

## Summary
