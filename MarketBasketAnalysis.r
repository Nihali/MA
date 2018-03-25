# Groceries Example 2 ####

library(arules)  #install first
library(arulesViz) #install first
library(datasets)  # no need to install, just load it
data('Groceries')
str(Groceries)
Groceries
inspect(Groceries[1:5])  #view
LIST(Groceries[1:5])  #another view
#Lets Apply Apriori Algorithm
frequentItems <- eclat (Groceries, parameter = list(supp = 0.005, minlen= 1, maxlen = 15)) 
frequentItems
inspect(frequentItems[1:5])

?eclat
itemFrequencyPlot (Groceries,topN = 15,type="absolute") #Identifying the top 15 items
itemFrequencyPlot(Groceries, topN = 10)
abline(h=0.2) #horizontal line at 0.2

#Creating association rules
#everything is out of 10000 times transactions
#support tells how much time they were bought together
#conf is the confidence figure
#lift increases the sale by that %
#confidence is the chances that rhs items was bought with lhs items 
#count tells how many times they were bought together
rules <- arules::apriori(Groceries, parameter = list(supp = 0.005, conf = 0.5)) #atleast 10 transactions (0.001X10000) items should be there
rules
inspect(rules[1:15])
quality(rules) 
head(quality(rules))
options (digits=2)
inspect (rules[1:5])

rulesc <- sort (rules, by="confidence", decreasing=TRUE) #rules sorted by confidence
inspect(rulesc[1:10])
rulesl <- sort (rules, by="lift", decreasing=TRUE) #rules sorted by lift
inspect (rulesl[1:5])

#How To Control The Number Of Rules in Output ?
rules <- apriori (Groceries, parameter = list (supp = 0.001, conf = 0.5, maxlen=3)) # maxlen = 3 limits the elements in a rule to 3

#How To Remove Redundant Rules ?
sum(is.redundant(rules))
(redundant = which(is.redundant(rules))) #duplicate rules are removed
#colSums(is.subset(rules, rules))
rulesNR <- rules[-redundant] 
is.redundant(rulesNR)
sum(is.redundant(rulesNR))  #ok now

#Another method
#redundant <- which (colSums (is.subset (rules, rules)) > 1) 
#redundant


#Find what factors influenced an event ‘X’
rules <- apriori (data=Groceries, parameter=list (supp=0.001,conf = 0.08), appearance = list (default="lhs",rhs="whole milk"), control = list (verbose=F))
inspect(rules[1:15])
#appearance by list default is lhs and i want only milk on rhs
#verbose tells us how many secs it takes. so we keep it false to keep precise data
#output shows what is triggering the rhs items


#Find out what events were influenced by a given event

rules <- apriori (data=Groceries, parameter=list (supp=0.001,conf = 0.15,minlen=2), appearance = list (default="rhs",lhs="whole milk"), control = list (verbose=F)) 
inspect(rules[1:5])
#Visualizing The Rules -----


plot (rules[1:5], measure=c("support", "lift"), shading="confidence")

plot(rules[1:5],method="graph",engine='interactive', shading="confidence") 
