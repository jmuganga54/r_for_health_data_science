# Basic if statement
# If `x` was less than or equal to 3, nothing would happen.

x <- 5

if(x>3){
  print("x is greater than 3")
}

#`if` with `else`

x <- 2

if(x > 3){
  print("x is greater than 3")
}else{
  print("x is less than 3")
}

# Multiple Conditions (`else if`)
# You can check more than one condition using `else if`:

x <- 5

if(x > 8){
  print("x is bigger")
}else if(x > 3){
  print("x is medium")
}else{
  print("x is smaller")
}

# Example: Using random numbers

x <- runif(1, 0, 10)

if(x > 3){
  y <- 10
}else{
  y <- 0
}

print(c(x,y))

# You can also write this in a shorter form:

y <- if(x > 3) 10 else 0

print(c(x,y))


##### 13.2 for Loops

for(i in 1:10){
  print(i)
}

# Example: Looping through a character vector

x <- c("a","b","c","d")

for(i in 1:4){
  print(x[i])
}

# Using `seq_along()` (a safer method)

for(i in seq_along(x)){
  print(x[i])
}

# Looping directly over elements


for(element in x){
  print(element)
}


# One-line loops

for(element in x) print(element)

# 13.3 Nested for loops
# Let’s start with a simple matrix — a grid of numbers with rows and columns.

x <- matrix(1:6, 2, 3)
x

nrow(x)
ncol(x)

seq_len(nrow(x))

for( i in seq_len(nrow(x))){ #loops through row
  for(j in seq_len(ncol(x))){ # loops through column
    print(x[i,j])
    
  } 
}



