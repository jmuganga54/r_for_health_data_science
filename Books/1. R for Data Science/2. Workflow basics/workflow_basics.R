# 2.1 Coding basics

# Let’s review some basics we’ve omitted so far in the interest of getting you plotting as quickly as possible. You can use R to do basic math calculations:

1 / 200 * 30
# [1] 0.15

(59 + 73 + 2) / 3
# [1] 44.66667

(59 + 73 + 2) / 3
# [1] 44.66667

sin(pi / 2)
# [1] 1


# You can create new objects with the assignment operator <-:
x <- 3 * 4
x
# [1] 12

# Note that the value of x is not printed, it’s just stored. If you want to view the value, type x in the console.
# 
# You can combine multiple elements into a vector with c():

primes <- c(1, 2, 3, 4, 5, 6, 7)
primes
# [1] 1 2 3 4 5 6 7

# All R statements where you create objects, assignment statements, have the same form:

# object_name <- value


# When reading that code, say “object name gets value” in your head.
# 
# You will make lots of assignments, and <- is a pain to type. You can save time with RStudio’s keyboard shortcut: Alt + - (the minus sign). Notice that RStudio automatically surrounds <- with spaces, which is a good code formatting practice. Code can be miserable to read on a good day, so giveyoureyesabreak and use spaces.

name <- "Joseph Muganga"
name


# 2.2 Comments  

# R will ignore any text after # for that line. This allows you to write comments, text that is ignored by R but read by other humans. We’ll sometimes include comments in examples explaining what’s happening with the code.
# 
# Comments can be helpful for briefly describing what the following code does.

# create a vector of primes
primes <- c(2, 3, 5, 7, 11, 13)

# multiply primes by 2 
multiply_primes <- primes * 2
multiply_primes

# Use comments to explain the why of your code, not the how or the what.

this_is_really_long_name <- 2.5
this_is_really_long_name

r_rocks <- 2^3
r_rocks


# 2.4 Calling functions
seq(from = 1, to = 10)

# We often omit the names of the first several arguments in function calls, so we can rewrite this as follows:

seq(1,10)

x <- "Hello world!!"
x


# 2.5 Exercises

# 1. Why does this code not work?

my_variable <- 10
my_varıable
#> Error:
#> ! object 'my_varıable' not found

# Look carefully! (This may seem like an exercise in pointlessness, but training your brain to notice even the tiniest difference will pay off when programming.)


# 2. Tweak each of the following R commands so that they run correctly:

library(tidyverse)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() +
  geom_smooth(method = "lm")

# 3. Press Option + Shift + K / Alt + Shift + K. What happens? How can you get to the same place using the menus?

# 4. Let’s revisit an exercise from the Section 1.6. Run the following lines of code. Which of the two plots is saved as mpg-plot.png? Why?

my_bar_plot <- ggplot(mpg, aes(x = class)) +
  geom_bar()
my_scatter_plot <- ggplot(mpg, aes(x = cty, y = hwy)) +
  geom_point()
ggsave(filename = "mpg-plot.png", plot = my_bar_plot)


 

