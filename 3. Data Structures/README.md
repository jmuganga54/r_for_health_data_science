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

R has built-in functions to quickly calculate basic statistics from a vector, such as its length, sum, mean, maximum, minimum, median, and a full summary.

```
vector <- c(x, y, d, f, b, 50.3, 7^2)  

length(vector)   # number of elements  
sum(vector)      # total  
mean(vector)     # average  
max(vector)      # largest value  
min(vector)      # smallest value  
median(vector)   # middle value  
summary(vector)  # full summary (min, 1st Qu., median, mean, 3rd Qu., max)  


```
### 3.3 Vectors and Subsetting

A `vector` in R is like a row of data containing values of the same type. You create one using `c()`:

```
b <- c(8, 1, 3)   # numeric vector
b * 3             # multiplies each element by 3
## [1] 24  3  9

```

You can extract elements with square brackets [ ]:

```
b[2]         # second element
## [1] 1

b[c(2, 3)]   # second and third elements
## [1] 1 3

```

>[!CAUTION]
>b[2, 3] gives an error because vectors are one-dimensional; the comma implies rows and columns, which apply to matrices.

Vectors can be combined into matrices using cbind() (bind as columns) or rbind() (bind as rows). Example with health data:

```
id     <- c("N198","N805","N333","N117","N195","N298")
gender <- c(1, 0, 1, 1, 0, 1) 
age    <- c(30, 60, 26, 75, 19, 60)
blood  <- c(0.4, 0.2, 0.6, 0.2, 0.8, 0.1)

health_data <- cbind(id, gender, age, blood)   # column bind
health_data
##      id     gender age  blood
## [1,] "N198" "1"    "30" "0.4"
...

```
```
health_data_rbind <- rbind(id, gender, age, blood)   # row bind
health_data_rbind
##        [,1]   [,2]   [,3]   [,4]   [,5]   [,6]  
## id     "N198" "N805" "N333" "N117" "N195" "N298"
## gender "1"    "0"    "1"    "1"    "0"    "1"
...

```
>[!IMPORTANT]
> When vectors are combined into a matrix, all entries must be the same type. If mixed, numbers are converted to text (shown in quotes). You can check the type using:

```
class(health_data)
## [1] "matrix"

```

>[!TIP]
> Vectors are one-dimensional sequences of the same type. Use [ ] to access elements, and cbind()/rbind() to combine vectors into a matrix, which also requires all elements to be the same type.

In R, indexing starts at 1, not 0.

Example:
```
b <- c(8, 1, 3)

b[1]   # first element
## [1] 8

b[2]   # second element
## [1] 1

b[3]   # third element
## [1] 3

```

>[!CAUTION]
> ⚠️ If you try b[0], R will not return the first element (like in Python). Instead, it returns:

```
b[0]
## numeric(0)   # means "empty"

```

### 3.4 Data Frames

In R, a data frame is the most common way to store data. It is like a table where each column is a variable (which can be of different types, e.g. numeric, character) and each row is an observation. You can create one with data.frame():

```
my_data <- data.frame(ID = id, Sex = gender, Age = age, Blood = blood)
my_data
##     ID Sex Age Blood
## 1 N198   1  30   0.4
## 2 N805   0  60   0.2
...

```

Unlike a matrix, where all entries must be the same type, data frames allow mixed column types (numbers, text, etc.). Conversion between the two is possible using as.matrix() or as.data.frame().

Useful functions to explore data frames include:

```
summary(my_data)   # statistics for each column
class(my_data)     # check object type
head(my_data, 2)   # first 2 rows
tail(my_data, 2)   # last 2 rows
colnames(my_data)  # column names
nrow(my_data)      # number of rows
ncol(my_data)      # number of columns

```

Accessing elements works with [rows, columns]:

```
my_data[2, 3]       # value in row 2, col 3 -> 60
my_data[2, ]        # all columns in row 2
my_data[, 3]        # all rows in column 3 (Age)
my_data$Age         # Age column (preferred way)
my_data[, "Age"]    # same result using column name
my_data[, c("Age", "ID")]   # select multiple columns
my_data[2:3, 2:3]   # rows 2–3, columns 2–3

```
>[!CAUTION]
> R is case-sensitive, so "Age" is different from "age".

>[!NOTE]
> The summary output includes 1st Qu., Median, 3rd Qu., which are the 25th, 50th, and 75th percentiles.
Data frames are flexible and preferred for most data analysis.

>[!TIP]
> Data frames are like tables that allow mixed column types, unlike matrices. You can explore them with summary(), head(), and select rows/columns with [ ] or $.

The `$ operator` in R is mainly used to access a specific `column in a data frame` by `name`. It’s handy when you’re working with one variable at a time.

Examples

```
# Create a simple data frame
my_data <- data.frame(
  ID = c("N198", "N805", "N333"),
  Age = c(30, 60, 26),
  Blood = c(0.4, 0.2, 0.6)
)

# Use $ to access the "Age" column
my_data$Age
## [1] 30 60 26

```

> When to use $

* 1. Extracting one column to analyze

```
mean(my_data$Age)   # Average age
## [1] 38.67

```
* 2. Quick plotting

```
plot(my_data$Age, my_data$Blood, main = "Age vs Blood")

```

* 3.Creating or modifying a column

```
my_data$Age_in_Years <- my_data$Age + 1
my_data
##     ID Age Blood Age_in_Years
## 1 N198  30  0.4            31
## 2 N805  60  0.2            61
## 3 N333  26  0.6            27

```
>[!WARNING]
> `$` only works for one column at a time and needs the exact column name. For multiple columns, use [ , ].

>[!TIP]
> use `$` when you want to directly call, analyze, or modify a single column in a data frame.

### 3.5 Data available in R
### 3.6 Further Reading