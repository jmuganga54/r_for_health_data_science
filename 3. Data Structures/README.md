## Topic
In this session, we will discuss:  

* [3.1 Assigning values to a variable](#31-assigning-values-to-a-variable)
* [3.2 Simply summary functions](#32-simply-summary-functions)
* [3.3 Vectors and Subsetting](#33-vectors-and-subsetting)
* [3.4 Data Frames](#34-data-frames)
* [3.5 Data available in R](#35-data-available-in-r)
* [3.6 Further Reading](#36-further-reading)

## keywords & Notes

### 3.1 Assigning values to a variable

In R, we create variables using the assignment arrow `<-`, which is the preferred way, while `=` can also assign values but is usually used inside functions. 

Variable names must start with a `letter, contain no spaces, and avoid reserved function names (like c or mean)`. You can also use `assign()` to dynamically create variable names. Variables can store numbers, text, or results of calculations. Equality between objects can be checked with `==` or `identical()`. 

R also uses vectors `(c())` to store sequences of values, but all `components in a vector must be of the same type (mixing text and numbers will convert everything to characters)`. Careless naming can overwrite built-in functions, so avoid assigning values to function names.

```
# Assigning values
a <- 4
3 * a
## [1] 12

b <- a^5
c <- b + a

x <- 2         # numeric value
y = 15         # works, but not preferred
assign("d", 7) # assign using function
colour <- "green"  # character value

```

```
# Checking equality
a <- 2^3
b <- 2 * 2 * 2
d <- 2 * 3

a == b
## [1] TRUE
identical(a, b)
## [1] TRUE

a == d
## [1] FALSE

```

```
# Creating vectors
c(2, 3, 4)
## [1] 2 3 4

c(d, colour, "Flowers")
## [1] "6"       "green"   "Flowers"

c(8, 1, 3)
## [1] 8 1 3

```
```
# Avoid overwriting functions
v <- c(1, 2, 3)
mean(v)
## [1] 2

mean <- function(){
  print("I 'accidentally' replaced the default mean function!")
}
mean()
## [1] "I 'accidentally' replaced the default mean function!"

mean(v)
## Error in mean(v): unused argument (v)

rm(mean)   # remove incorrect function
mean(v)
## [1] 2

```

### 3.2 Simply summary functions
### 3.3 Vectors and Subsetting
### 3.4 Data Frames
### 3.5 Data available in R
### 3.6 Further Reading