# 5.1 Working directory

#Checking your working directory**
# You can check your current working directory using:

getwd()

## Changing your working directory
setwd('/Users/josephmuganga/Documents/Code/r_for_health_data_science/5. Getting data in and out of R')



#### 5.2 Base R solutions to importing data

# The `read.csv()` function

x <- read.csv("./data/pharma_companies.csv")
x

# Exercise
chd <- read.csv("./data/chd.csv")

head(chd)     # Shows the first few rows
summary(chd)  # Gives summary statistics of each column

#### Exporting data

write.csv(chd,"chd2.csv")

write.csv(chd,"./data/chd3.csv")


