#Missing Values----

v1=c(1,2,NA,NA,5)
is.na(v1) #checking where are the missing values
mean(v1, na.rm = T) #remove missing values = true, only then can the mean be calculated
na.omit(v1) #omitting the missing values and then printing it
anyNA(v1) #is there atleast one NA then it prints 'TRUE'

#all

v1[is.na(v1)]
v1[is.na(v1)] = mean(v1, na.rm = T)
v1

#VIM----
#VIM Packages handles missing values
#sleep preinstalled data frame to practice in missing values handling

library(VIM)
data(sleep,package='VIM')
head(sleep)
dim(sleep)
complete.cases(sleep) #puts true for rows with no incomplete values
sleep[complete.cases(sleep),] #display complete rows 
sleep[!complete.cases(sleep),] #display incomplete rows
sum(is.na(sleep$dream))
mean(is.na(sleep$dream)) #No. of rows with missing values/ total no. of rows
12/62 #No of missing values/ total no. of rows

dim(sleep)

sum(!complete.cases(sleep)) #Total no of incomplete rows
sum(!complete.cases(sleep)) #Total no of incomplete rows / Total no of rows
20/62
sum(is.na(sleep))
colSums(is.na(sleep)) #Total no of missing values in each column

rowSums(is.na(sleep)) #Total no of missing values in each row


