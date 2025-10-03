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


  
    
