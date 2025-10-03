# ASSIGNING VALUES TO A VARIABLE
a <- 4
a
## [1] 4
3 * a

b <- a^5
b
##[1] 1024
c <- b+a
c
## [1] 16

x <- 2 # numeric value
x
## [1] 2
y = 5 # works, but not preferred
assign("d", 7) # assign using function
d
## [1] 7
colour <- "green" # character value



# Checking equality
a <- 2^3
a 
##[1] 8
b <- 2 * 2 * 2
b 
## [1] 8
d <- 2 * 3
d 
##[1] 6

a == b
identical(a,b) 
##[1] TRUE

a == d 
##[1] FALSE

# Creating vectors
c(2,3,4) 
## [1] 2 3 4

c(d, colour, "Flowers") 
## [1] "6" "green"   "Flowers"

c(8, 1, 3) #[1] 8 1 3

# Avoid overwriting functions
v <- c(1, 2, 3)
mean(v)
##[1] 2

# mean <- function(){
#   print("I 'accidentally' replaced the default mean function!")
# }

# mean()
## [1] "I 'accidentally' replaced the default mean function!"

# mean(v)
## Error in mean(v) : unused argument (v)

# rm(mean) # remove incorrect function
# mean(v)
## [1] 2


# SIMPLY SUMMARY FUNCTION
f <- b
vector <- c(x, y, d, f, b, 50.3, 7^2)

length(vector) # number of elements  
## [1] 7

sum(vector) # total  
## [1] 128.3

max(vector) # largest value  
## [1] 50.3

min(vector) # smallest value  
## [1] 2

median(vector) # middle value  
## [1] 8

summary(vector) # full summary (min, 1st Qu., median, mean, 3rd Qu., max) 
## Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
## 2.00    5.50    8.00   18.33   28.50   50.30 

# VECTOR AND SUBSETTING
b <- c(8, 1, 3) # numeric vector
b * 3 # multiplies each element by 3
## [1] 24  3  9


#You can extract elements with square brackets [ ]:
b[2] # second element
## [1] 1
b[c(2,3)] # second and third elements
## [1] 1 3

b[2,3] #gives an error because vectors are one-dimensional;
## Error in b[2, 3] : incorrect number of dimensions

# Combined into matrices using cbind() (bind as columns) or rbind()
id <- c("N198", "N805", "N333", "N117", "N195", "N298")
gender <- c(1, 0, 1, 1, 0, 1)
age <- c(30, 60, 26, 75, 19, 60)
blood <- c(0.4, 0.2, 0.6, 0.2, 0.8, 0.1)

health_data <- cbind(id, gender, age, blood)
health_data
##      id     gender age  blood
## [1,] "N198" "1"    "30" "0.4"
## [2,] "N805" "0"    "60" "0.2"

health_data_rbind <- rbind (id, gender,age, blood) # row bind health_data_rbind
health_data_rbind
#        [,1]   [,2]   [,3]   [,4]   [,5]   [,6]  
# id     "N198" "N805" "N333" "N117" "N195" "N298"
# gender "1"    "0"    "1"    "1"    "0"    "1"   
# age    "30"   "60"   "26"   "75"   "19"   "60" 

class(health_data)
## [1] "matrix" "array" 


## DATA FRAMES
my_data <- data.frame(ID=id, Sex = gender, Age = age, Blood = blood)
my_data
#      ID Sex Age Blood
# 1 N198   1  30   0.4
# 2 N805   0  60   0.2


# Useful functions to explore data frames include:
summary(my_data) #statistics for each column
class(my_data) # check object type
head(my_data, 2)  # first 2 rows
tail(my_data, 2) # last 2 rows
nrow(my_data) # number of rows
ncol(my_data) # number of columns

# Accessing elements works with [rows, columns]:
my_data[2,3] # value in row 2, col 3 -> 60
my_data[2,] # all columns in row 2
my_data[,3] # all rows in column 3 (Age)
my_data$Age # Age column (preferred way)
my_data[,"Age"] # same result using column name
my_data[,c("Age","ID")] # select multiple columns
my_data[2:3, 2:3] # rows 2–3, columns 2–3

#The $ operator in R
#Create a simple data frame
my_data <-data.frame(
  ID= c("N198", "N805", "N333"),
  Age = c(30, 60, 26),
  Blood = c(0.4, 0.2, 0.6)
)

#Use $ to access the "Age" column
my_data
my_data$Age

# When to use $
# Extraction one column to analyze
mean(my_data$Age) # Average age
# [1] 38.66667

# Quick plotting
plot(my_data$Age, my_data$Blood, main = "Age vs Blood")

# Creating or modifying a column
my_data$Age_in_Years <- my_data$Age + 1
my_data
