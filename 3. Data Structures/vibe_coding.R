rm(list = ls())

b <- c(8, 1,3) # numberic vector
b*3
b[1]


#bind by columns
id <- c("N198", "N805")
gender <- c(1,0)
age <- c(20,60)
blood <- c(0.4, 0.2)

health_data <- cbind(id,gender,age,blood)
health_data

#bind in row

health_data_rbind <- rbind(id,gender,age,blood)
health_data_rbind


# DATA FRAME IN R
my_data <- data.frame(ID = id, Sex = gender, Age = age, Blood = blood)
my_data

#usefull function is dataframe
summary(my_data)
class(my_data)
class(my_data$Sex)
head(my_data)
tail(my_data)
colnames(my_data)
nrow(my_data)
ncol(my_data)
dim(my_data)
