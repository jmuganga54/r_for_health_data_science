#install packages

install.packages("tidyverse")
install.packages("nycflights13")

#Loading Packages
library(nycflights13)
library(tidyverse)

# viewing the dataset
flights

# Exploring structure with `glimpse()`

glimpse(flights)

#viewing options
View(flights) #opens an interactive spreadsheet in RStudio.
print(flights, width = Inf) #shows all columns in the console.
glimpse(flights) #compact overview of variables & types.

#How to create a tibble
library(tibble)

tb <- tibble(
  ID = c("N198", "N805","N333"),
  Age = c(30, 60, 26),
  Blood = c(0.4, 0.2, 0.6)
)

tb

view(tb)
glimpse(tb)
print(tb,width=Inf)

# Converting a data frome to tibble

df <- data.frame(
  ID = c("N198", "N805","N333"),
  Age = c(30, 60, 26),
  Blood = c(0.4,0.2,0.6)
)

tb2 <- as_tibble(df) #convert to tibble
tb2

# Subsetting tibble

tb <- tibble(
  x = 1:3,
  y = letters[1:3]
)

tb["x"] # tibble with 1 column
tb[["x"]] # numeric vector
tb$x # numeric vector
tb[c("x","y")] # tibble with both columns
tb[1:2, ] # first two rows
tb[2,"x"] # tibble with 1 cell


#dplyr basics
glimpse(flights)

flights |>
  filter(dest == "IAH") |> # Keep flights going to IAH
  group_by(year,month,day) |> # group the data by date
  summarize(
    avg_delay = mean(arr_delay, na.rm=TRUE) # calculate mean delay
  )


#Rows
# filter() - choose row
jan_flights <- flights |> filter(month == 4)
jan_flights


flights |> filter(dep_delay > 120)

# Flights on January 1
flights |> filter(month == 2 & day == 2)

# Flights in January OR February
view(flights |> filter(month == 1 | month == 2))

# Shortcut using %in%
flights |> filter(month %in% c(1,2))

# Saving results
jan1 <- flights |> filter(month == 1 & day == 1)
jan1

# Order flights by departure delay (smallest to largest)
flights |> arrange(dep_delay)
flights |> arrange(day)

# Sort flights by year, month, day, and departure time
flights |> arrange(year, month, day, dep_time)

# Sort by largest delay first
flights |> arrange(desc(dep_delay))
    

# Find all unique destinations
flights |> distinct(dest)

# Find unique pairs of origin and destination
view(flights |> distinct(origin, dest))

# Keep all other columns with .keep_all = TRUE:
view(flights |> distinct(origin, dest, .keep_all = TRUE))

# Counting instead of distinct
# If you want to know how many times each pair occurs, use count():

flights |> count(origin, dest, sort = TRUE)

# Count how many rows there are (overall, or per group if grouped).
flights |> summarise(n = n())


#Exercise
# 1.In a single pipeline for each condition, find all flights that meet the condition:

# Had an arrival delay of two or more hours
glimpse(flights)
flights |> filter(arr_delay >= 120)


# Flew to Houston (IAH or HOU)
flights |> filter(dest %in% c("IAH","HOU"))


# Were operated by United, American, or Delta
flights |> filter(carrier %in% c("UA", "AA", "DL"))

# Departed in summer (July, August, and September)
flights |> filter(month %in% 7:9)


# Arrived more than two hours late but didn’t leave late
flights |> filter(arr_delay > 120 & dep_delay == 0)

# Were delayed by at least an hour, but made up over 30 minutes in flight
flights |> filter(dep_delay >= 60, (dep_delay - arr_delay) > 30)


# 2. Sort flights to find the flights with the longest departure delays. Find the flights that left earliest in the morning.
flights |> 
  arrange(desc(dep_delay)) |> 
  head()

# 3. Sort flights to find the fastest flights. (Hint: Try including a math calculation inside of your function.)

glimpse(flights)
view(flights |>
  filter(!is.na(air_time), air_time > 0) |>       # keep valid rows
  arrange(desc(distance / air_time * 60)) |>      # compute mph inside arrange
  head(10))

# 4. Was there a flight on every day of 2013?
flights |>
  distinct(year, day, month) |>
  summarise(n_days=n())

# 5. Which flights traveled the farthest distance? Which traveled the least distance?
# Farthest flight(s)
flights |>
  filter(distance == max(distance, na.rm = TRUE)) |>
  select(year, month, day, carrier, flight, origin, dest, distance)

# Shortest flight(s)
flights |>
  filter(distance == min(distance, na.rm = TRUE)) |>
  select(year, month, day, carrier, flight, origin, dest, distance)
  

## COLUMNS
#`mutate()` adds new variables that are calculated from existing ones.
flights |>
  mutate(
    gain = dep_delay - arr_delay, # time made up in air
    speed = distance / air_time * 60 # flight speed in mph
  )

# You can control where new columns appear
flights |>
  mutate(gain = dep_delay - arr_delay, .before = 1) # add before first column

# only keep the columns you used:
flights |>
  mutate(
    gain = dep_delay - arr_delay,
    hours = air_time / 60,
    gain_per_hour = gain / hours,
    .keep = "used"
  )

# When you run a command like the one above, R prints the result, but it doesn’t save it anywhere.
# That means if you type `flights` again later, it will still be the old version — your new columns are gone.

flights

# To save your new data frame, you must assign it to an object using `<-`:
flights_summary <- flights |>
  mutate(
    gain = dep_delay - arr_delay,
    hours = air_time / 60,
    gain_per_hour = gain / hours,
    .keep = "used"
  )

view(flights_summary)


# `select()` – Pick columns
flights |> select(year, month, day) # pick specific columns
flights |> select(year:day) # pick a range of columns
flights |> select(!year:day) # drop a range of columns
flights |> select(where(is.character)) # keep only character columns

# You can also rename while selecting:
flights |> select(tail_num = tailnum)

flights

# Check columns names
colnames(flights)

# `rename()` – Rename columns
flights |> rename(tail_num = tailnum)

# `relocate()` – Move columns
flights |> relocate(time_hour, air_time) # move to the front

# You can also move columns relative to others:
flights |> relocate(year:dep_time, .after = time_hour) # move after time_hour
view(flights |> relocate(starts_with("arr"), .before = dep_time)) # move before dep_time


# Exercises
# 1. Compare `dep_time`, `sched_dep_time`, and `dep_delay`. How would you expect those three numbers to be related?

flights |>
  select(dep_time, sched_dep_time, dep_delay) |>
  head(10)

#2. Brainstorm as many ways as possible to select `dep_time`, `dep_delay`, `arr_time`, and `arr_delay` from flights.


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

#3. What happens if you specify the name of the same variable multiple times in a select() call?

#Notice that `dep_time` only appears once, even though we wrote it twice.
flights |>
  select(year, month, day, dep_time, dep_time)

# 4. What does the `any_of()` function do? Why might it be helpful in conjunction with this vector?
variables <- c("year", "month", "day", "dep_delay", "arr_delay")

flights |> select(any_of(variables))

# 5. Does the result of running the following code surprise you? How do the select helpers deal with upper and lower case by default? How can you change that default?

# So even though we used uppercase "TIME",
# it found all the lowercase columns that contain “time”.
flights |> select(contains("TIME"))


# If you want to match exactly how the column name is written
# (e.g., match only uppercase “TIME”), use the argument `ignore.case = FALSE`.

flights |> select(contains("TIME", ignore.case = FALSE)) 

# 6. Rename `air_time` to `air_time_min` to indicate units of measurement and move it to the beginning of the data frame.

flights |> 
  rename(air_time_min = air_time) |>     # Rename the column
  relocate(air_time_min, .before = 1)    # Move it to the first column

# You can also move the column by name instead of position:
flights |> 
  rename(air_time_min = air_time) |> 
  relocate(air_time_min, .before = year)

# 7. Why doesn’t the following work, and what does the error mean?

# But since `arr_delay` was removed in the first step,  
# R doesn’t know what it is — it’s not in your data anymore! 
flights |> 
  select(tailnum) |> 
  arrange(arr_delay)
#> Error in `arrange()`:
#> ℹ In argument: `..1 = arr_delay`.
#> Caused by error:
#> ! object 'arr_delay' not found
#> 


# THE PIPE
# The pipe `(|>)` lets you write data steps in the order you think:  
#   take `data` then `filter` then `create a column` then `pick columns` then `sort.`

flights |> 
filter(dest == "IAH") |> # keep flights to IAH
mutate(speed = distance / air_time * 60) |>  # mph = miles / (min/60)
select(year:day, dep_time, carrier, flight, speed) |> 
arrange(desc(speed))    # fastest first

flights
  

# Groups

# Use group_by() to split your dataset into smaller groups before applying another function.

flights |>
  group_by(month)

# summarise() calculates summary values (like mean, count, etc.) for each group.

flights |>
  group_by(month) |>
  summarise(avg_delay = mean(dep_delay, na.rm = TRUE))

# You can also get the number of flights per month:

flights |>
  group_by(month) |>
  summarise(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    n = n() # counts rows in each group
  )

#Theslice_*() Family
# These functions help you extract specific rows within each group:

view(flights |>
  group_by(dest) |>
  slice_max(arr_delay, n = 1, with_ties = FALSE) |>
  relocate(dest)
)

view(flights |>
       group_by(dest) |>
       slice_min(arr_delay, n = 1) |>
       relocate(dest)
)

view(flights |>
       group_by(dest) |>
       slice_head(n = 1) |>
       relocate(dest)
)

view(flights |>
       group_by(dest) |>
       slice_tail(n = 1) |>
       relocate(dest)
)

view(flights |>
       group_by(dest) |>
       slice_sample(n = 1) |>
       relocate(dest)
)

# Grouping by Multiple Variables
daily <- flights |> group_by(year, month, day)
group_vars(daily)
# Thsummarise

daily |>
  summarise(
    n = n(),
    .groups = "drop_last" # keeps grouping by year and month only
)  

daily |>
  summarise(
    n = n(),
    .groups = "drop" #remove all grouping
  )  

group_vars(daily)

# Removes grouping completely:

daily |>
  ungroup() |>
  summarise(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    flights = n()
  ) 

# .by (New in dplyr 1.1.0)
# Instead of using group_by(), you can group directly inside a function with .by.

group_vars(flights |>
  summarise(
    delay = mean(dep_delay, na.rm = TRUE),
    n = n(),
    .by = month
  ))
  
# Exercises

# 1. Which carrier has the worst average delays? Challenge: can you disentangle the effects of bad airports vs. bad carriers? Why/why not? (Hint: think about flights |> group_by(carrier, dest) |> summarize(n()))

# We’ll start simple — calculate the average departure delay for each carrier.

flights |>
  group_by(carrier) |>
  summarise(avg_delay = mean(dep_delay, na.rm = TRUE)) |>
  arrange(desc(avg_delay))

# To explore that, we can check average delays by both carrier and destination.

flights |>
  group_by(carrier, dest) |>
  summarise(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    flights = n()
  ) |>
  arrange(desc(avg_delay))

# 2. Find the flights that are most delayed upon departure from each destination.

glimpse(flights)

flights |>
  group_by(flight, dest) |>
  summarise(
    avg_delay = mean(dep_delay, na.rm = TRUE)
  ) |>
  arrange(desc(avg_delay))

# 2. Find the flights that are most delayed upon departure from each destination.

# For each destination (`dest`), we want to look at all the flights going there, and then pick the one flight with the largest `dep_delay` (departure delay).

flights |>
  group_by(dest) |>
  slice_max(dep_delay, n = 1) |>
  select(dest, year, month, day, dep_time, dep_delay, carrier, flight) |>
  head(4)


# Learning

flights |>
  group_by(dest) |>
  slice_max(dep_delay, n = 1, with_ties = FALSE) |>
  select(dest, year, month, day, dep_time, dep_delay, carrier, flight) |>
  relocate(dest) |>
  head(4)


# 3. How do delays vary over the course of the day? Illustrate your answer with a plot.


#  ✅ Step 1: Summarize the average delay per hour

avg_delay_by_hour <- flights |>
  group_by(hour) |>
  summarise(
    avg_dep_delay = mean(dep_delay, na.rm = TRUE)
  )|>
  filter(!is.nan(avg_dep_delay), !is.na(avg_dep_delay)) 
  
  
  avg_delay_by_hour 
  
  
# ✅ Step 2: Create a simple plot
  
  ggplot(avg_delay_by_hour, aes(x = hour, y = avg_dep_delay)) +
    geom_line(color = "steelblue", linewidth = 1.2) +
    geom_point(color = "red", size = 2) +
    labs(
      title = "Average Departure Delay by Hour of the Day",
      x = "Hour of Day (24-hour clock)",
      y = "Average Departure Delay (minutes)"
    ) +
    theme_minimal()
  
# ✅ Final Answer
  
  flights |>
    group_by(hour) |>
    summarise(
      avg_dep_delay = mean(dep_delay, na.rm = TRUE)
    )|>
    filter(!is.nan(avg_dep_delay), !is.na(avg_dep_delay)) |>
    ggplot(aes(x = hour, y = avg_dep_delay)) +
    geom_line(color = "steelblue", linewidth = 1.2) +
    geom_point(color = "red", size = 2) +
    labs(
      title = "Average Departure Delay by Hour of the Day",
      x = "Hour of Day (24-hour clock)",
      y = "Average Departure Delay (minutes)"
    ) +
    theme_minimal()

