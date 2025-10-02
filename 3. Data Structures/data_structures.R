# Assigning values
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

mean <- function(){
  print("I 'accidentally' replaced the default mean function!")
}

mean()
## [1] "I 'accidentally' replaced the default mean function!"

mean(v)
## Error in mean(v) : unused argument (v)

rm(mean) # remove incorrect function
mean(v)
## [1] 2
