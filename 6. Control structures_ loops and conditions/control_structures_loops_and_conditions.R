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

##### 13.4 while Loops

count <- 0

while(count <= 10){
  print(count)
  count <- count + 1
}

# Example 2: A random walk (with multiple conditions)
# rm(list = ls())

z <- 5
set.seed(1)  # Ensures the same random results every time

while(z>= 3 && z<=10){ # Keep looping while z is between 3 and 10
  coin <- rbinom(1, 1, 0.5) # Flip a coin: 0 = tails, 1 = heads
  
  if(coin == 1){
    z = z + 1 # Move one step up if heads
  }else{
    z = z - 1 # Move one step down if tails
  }
}

print(z)


##### 13.5 repeat Loops

count <- 0

repeat{
  print(count)
  count <- count + 1
  
  if(count > 5){
    print(count)
    break
  }
}

# Example 2: Searching for a “close enough” answer

x0 <- 1
tol <- 1e-8

repeat{
  x1 <- computeEstimate()
  
  if(abs(x1 - x0) < 0){
    break
  }else{
    x0 <- x1
  }
}

# It’s safer to set a maximum number of iterations using a `for` loop or by adding a limit:

x <- 1
tol <- 1e-8
max_iter <- 1000

iter <- 0

repeat{
  x1 <- x / 2 # example calculation
  iter <- iter + 1
  
  if(abs(x1 - x) || iter >= max_iter){
    break # stop if close enough or max reached
  }
  x <- x1
}

print("Loop ended safely")

##### 13.6 next, break

for(i in 1:10){
  
  if(i <= 3){
    next
  }
  print(i)
}


# The break Statement — Stop the Loop Completely

for (i in 1:10) {
  print(i)
  
  if (i >= 5) {
    break  # Stop the loop once i reaches 5
  }
}

### 6.1 if, else and for

list_numbers <- 1:100
list_numbers

for(number in list_numbers){
  if((number %% 3 == 0) && (number %% 5 == 0)){
    print("fizz buzz")
  }else if(number %% 3 == 0){
    print("fizz")
  }else if(number %% 5 == 0){
    print("buzz")
  }else{
    print(number)
  }
}

### 6.2 Vectorised code

numbers <- 1:10
numbers 

for(number in numbers){
  print(number * 2)
}


# ⚡ Using Vectorised Code (all at once)
numbers * 2 



  