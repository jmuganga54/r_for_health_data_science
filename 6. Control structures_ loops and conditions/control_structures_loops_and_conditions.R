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


