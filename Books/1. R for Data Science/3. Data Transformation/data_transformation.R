# In this chapter, we’ll focus on the dplyr package, another core member of the tidyverse. We’ll illustrate the key ideas using data from the nycflights13 package and use ggplot2 to help us understand the data.
library(nycflights13)
library(tidyverse)


# 3.1.2 nycflights13

# To explore the basic dplyr verbs, we will use nycflights13::flights. This dataset contains all 336,776 flights that departed from New York City in 2013. The data comes from the US Bureau of Transportation Statistics and is documented in ?flights.

?flights

# There are a few options to see everything. If you’re using RStudio, the most convenient is probably View(flights), which opens an interactive, scrollable, and filterable view. Otherwise you can use print(flights, width = Inf) to show all columns, or use glimpse():

view(flights)
print(flights, width = Inf)
glimpse(flights)


# 3.1.3 dplyr basics

# Because each verb does one thing well, solving complex problems will usually require combining multiple verbs, and we’ll do so with the pipe, |>. We’ll discuss the pipe more in Section 3.4, but in brief, the pipe takes the thing on its left and passes it along to the function on its right so that x |> f(y) is equivalent to f(x, y), and x |> f(y) |> g(z) is equivalent to g(f(x, y), z). The easiest way to pronounce the pipe is “then”. That makes it possible to get a sense of the following code even though you haven’t yet learned the details:

flights |>
  filter(dest == "IAH") |>
  group_by(year, month, day) |>
  summarize(
    arr_delay = mean(arr_delay, na.rm = TRUE)
    ) |>
  view()
  
# 3.2 Rows

# The most important verbs that operate on rows of a dataset are filter(), which changes which rows are present without changing their order, and arrange(), which changes the order of the rows without changing which are present. Both functions only affect the rows, and the columns are left unchanged. We’ll also discuss distinct() which finds rows with unique values. Unlike arrange() and filter() it can also optionally modify the columns.


# 3.2.1 filter() 

# filter() allows you to keep rows based on the values of the columns1. The first argument is the data frame. The second and subsequent arguments are the conditions that must be true to keep the row. For example, we could find all flights that departed more than 120 minutes (two hours) late:

flights |>
  filter(dep_delay > 120) |>
  view()

flights |>
  filter(dep_delay > 800) |>
  ggplot(aes(x = dep_delay)) +
  geom_histogram(binwidth = 100 )


flights |>
  filter(dep_delay > 800) |>
  ggplot(aes(x = dep_delay, fill = carrier)) +
  geom_density(alpha = 10 )


# As well as > (greater than), you can use >= (greater than or equal to), < (less than), <= (less than or equal to), == (equal to), and != (not equal to). You can also combine conditions with & or , to indicate “and” (check for both conditions) or with | to indicate “or” (check for either condition):

# Flights that departed on January 1
flights |>
  filter( month == 1 & day == 1 ) |>
  view()

# Flights that departed on January 1 and year 2013
flights |>
  filter( month == 1 & day == 1 & year == 2013) |>
  view()


# Flights that departed in January or February
flights |>
  filter(month == 1 | month == 2) |>
  view()

# There’s a useful shortcut when you’re combining | and ==: %in%. It keeps rows where the variable equals one of the values on the right:  

# A shorter way to select flights that departed in January or February
flights |>
  filter(month %in% c(3,4)) |>
  view()
  
# When you run filter() dplyr executes the filtering operation, creating a new data frame, and then prints it. It doesn’t modify the existing flights dataset because dplyr functions never modify their inputs. To save the result, you need to use the assignment operator, <-:

jan1 <- flights |>
  filter(month == 1 & day == 1) |>
  view()


# 3.2.2 Common mistakes
# When you’re starting out with R, the easiest mistake to make is to use = instead of == when testing for equality. filter() will let you know when this happens:

flights |>
  filter(month = 1)

# Correct one
flights |>
  filter(month == 1)

# Another mistakes is you write “or” statements like you would in English:

flights |>
  filter(month == 1 | 2) |>
  view()

# Correct one 

flights |>
  filter(month == 1 | month ==  2) |>
  view()
  

# 3.2.3 arrange()

# arrange() changes the order of the rows based on the value of the columns. It takes a data frame and a set of column names (or more complicated expressions) to order by. If you provide more than one column name, each additional column will be used to break ties in the values of the preceding columns. For example, the following code sorts by the departure time, which is spread over four columns. We get the earliest years first, then within a year, the earliest months, etc.

flights |>
  arrange(year, month, day, dep_time) |>
  view()
# 
# You can use desc() on a column inside of arrange() to re-order the data frame based on that column in descending (big-to-small) order. For example, this code orders flights from most to least delayed:

flights |>
  arrange(desc(dep_time)) |>
  view()

# 3.2.4 distinct()
# distinct() finds all the unique rows in a dataset, so technically, it primarily operates on the rows. Most of the time, however, you’ll want the distinct combination of some variables, so you can also optionally supply column names:

# Remove duplicate rows, if any
flights |>
  distinct() |>
  view()


# Find all unique origin and destination pairs
flights |>
  distinct(origin, dest) |>
  view()

flights |>
  distinct(dest) |>
  view()

flights |>
  distinct(year) |>
  view()


# Alternatively, if you want to keep the other columns when filtering for unique rows, you can use the .keep_all = TRUE option.

flights |>
  distinct(origin, dest, .keep_all = TRUE) |>
  view()


# If you want to find the number of occurrences instead, you’re better off swapping distinct() for count(). With the sort = TRUE argument, you can arrange them in descending order of the number of occurrences. You’ll learn more about count in

flights |>
  count(origin, dest, sort = TRUE)

# 3.2.5 Exercises
  
