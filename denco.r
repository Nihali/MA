#Denco Case----

denco = read.csv('denco.csv')
denco2=read.csv(file.choose())
denco
denco2

denco == denco2

summary(denco)
str(denco)
unique(denco$custname)

sname=c('Anish','Sagar','Nihali','Bhavya','Amber','Anali')
course=c('BCB','CSE','ECE','IT','MECH','PHARMA')
gender=c('M','M','F','F','M','F')
grades=c('B','S','A','C','D','E')
marks=floor(runif(6,50,100))
df1= data.frame(sname,course,gender,grades,marks)
df1
str(df1)

df1$sname = as.character(df1$sname)
str(df1)

df1$course=factor(df1$course)
str(df1)

df1$grades=factor(df1$grades,ordered=T,levels=c('S','A','B','C','D','E'))
df1$grades
str(df1)
df1
str(df1)

#using gsheet----
library(gsheet)

url = 'https://docs.google.com/spreadsheets/d/1PWWoMqE5o3ChwJbpexeeYkW6p4BHL9hubVb1fkKSBgA/edit#gid=216113907'
denco2 = as.data.frame(gsheet2tbl(url))
str(denco2)

head(denco) #shows only first few rows
names(denco) #shows the names of the columns

summary(denco)
dim(denco) #rows and columns
unique(denco$custname) #Print the unique cutomers( name and no) in the data
length(unique(denco$custname)) #no of unique customer
length(unique(denco$region)) #no of unique region

aggregate(denco$revenue , by=list(denco$custname), FUN=max)#maximum revenue denco gets from the customers
aggregate(denco$revenue , by=list(denco$custname), FUN=sum) #total amount a customer brought from denco

df2=aggregate(denco$revenue, by=list(denco$custname), FUN=sum) #saving the above output in dataframe
df2
str(df2)
head(df2)

df2=df2[order(df2$x, decreasing = TRUE),] #decreasing order
head(df2,5) #first 5 top customers
head(df2[order(df2$x, decreasing = TRUE),], 5) #combining above 2 rows in single line

#Aggregate Formula----

(df3=aggregate(revenue ~ custname + region, data= denco, FUN=sum))
head(df3[order(df3$revenue,decreasing=T),],10) #decreasing order of custname and region

#List----
list1=tapply(denco$revenue, denco$custname, FUN=sum) #tapply- function in R that is substitute of looping 
head(list1)
list1
head(sort(list1, decreasing=T))
summary(df3)
str(df3)

#dplyr----
names(denco)

library(dplyr)

denco %>% dplyr::filter(margin > 1000000) #printing data that has margin greater than 1000000

names(denco)
denco %>% group_by(custname) %>% summarize(Revenue = sum(revenue)) %>% arrange(desc(Revenue))

library(dplyr)

denco %>% dplyr::count(custname, sort= TRUE)

denco %>% dplyr::group_by(custname) %>% dplyr::summarise(n=n()) %>% dplyr::arrange(desc(n)) #Most loyal customers

denco %>% dplyr::group_by(custname) %>% dplyr::summarise(n=n()) %>% dplyr::arrange(desc(n))

denco %>% group_by(custname) %>% summarize(Revenue = sum(revenue)) %>% summarize(Region = sum(region))%>% arrange(desc(Revenue))
names(denco)

denco %>% select(custname, region) %>% group_by(custname, region) %>% count(custname) %>% arrange(desc(n)) #same s below
denco %>% group_by(custname) %>% count(region) %>%  arrange(desc(n)) #no of times a customers bought from a particular region


