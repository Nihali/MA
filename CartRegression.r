# CART Models - HH Case Study

library(rpart)
library(rpart.plot)
library(forecast)
#install.packages("https://cran.r-project.org/bin/windows/contrib/3.3/RGtk2_2.20.31.zip", repos=NULL)
library(RGtk2)
#install.packages("rattle")
library(rattle)

library(gsheet)
url= 'https://docs.google.com/spreadsheets/d/1PWWoMqE5o3ChwJbpexeeYkW6p4BHL9hubVb1fkKSBgA/edit#gid=1941519952'
Mer_Sales= as.data.frame(gsheet2tbl(url))
str(Mer_Sales)# Set the working directory to folder where you have placed the Input Data
summary(Mer_Sales)
#Mer_Sales = read.csv(file = "./data/Predict Merchant_Sales v01.csv", header = T)

# Summarize the dataset
summary(object = Mer_Sales)
names(Mer_Sales)
# Look at the average Annual_Sales()
for(i in 2:ncol(Mer_Sales))
{
  if(length(unique(Mer_Sales[,i])) <= 5)
  {
    Annual_Sales=aggregate(x=Mer_Sales$Annual_Sales,by=list(Mer_Sales[,i]),FUN=mean)
    print(colnames(Mer_Sales)[i])
    print(Annual_Sales)
    print("****************************************")
  }
}
dim(Mer_Sales)

# Make a copy of the Original Dataset
Mer_SalesUncapped = Mer_Sales

# Random Sampling
set.seed(777) # To ensure reproducibility
#splitting them into training and test set. 70% in training in this case
Index = sample(x = 1:nrow(Mer_SalesUncapped), size = 0.7*nrow(Mer_SalesUncapped)) #70% of total rows

Index

# Create Train dataset
Mer_SalesTrainUncapped = Mer_SalesUncapped[Index, ] #, is given because we need all columns
nrow(Mer_SalesTrainUncapped)
summary(object = Mer_SalesTrainUncapped)

# Create Test dataset
Mer_SalesTestUncapped = Mer_SalesUncapped[-Index, ] #-Index to know about the remaining 30%
nrow(Mer_SalesTestUncapped)
summary(object = Mer_SalesTestUncapped)


########################### Modeling #################################
library(rpart)
head(Mer_SalesTrainUncapped)
# Build a full model with default settings
set.seed(123) # To ensure reproducibility of xerrors (cross validated errors while estimating complexity paramter for tree pruning)
CartFullModel = rpart(formula = Annual_Sales ~ . , data = Mer_SalesTrainUncapped[,-1], method = "anova") #-1 is taken because Merchant_Id is not considered as amodel so it is excluded. Anova is used to predict one particular value
CartFullModel
summary(object = CartFullModel)
summary(Mer_SalesTestUncapped[,'Annual_Sales'])
names(Mer_SalesTrainUncapped)
# Plot the Regression Tree
library(rpart.plot)
rpart.plot(x = CartFullModel, type = 4,fallen.leaves = T, cex = 0.6) #cex is the magnification factor
title("CartFullModel") # Enlarge the plot by clicking on Zoom button in Plots Tab on R Studio

# fancyRpartPlot() function to plot the same model
# Expand the plot window in R Studio to see a presentable output
library(rattle)
fancyRpartPlot(model = CartFullModel, main = "CartFullModel", cex = 0.6) 

# The following code also produces the same output, but in a windowed form
windows()
fancyRpartPlot(model = CartFullModel, main = "CartFullModel", cex = 0.6)


# The CP table also shows us valueable information in terms of pruning the tree (which is explained later in the code)
# => The complexity parameter "CP" specifies how the cost of a tree C(T) is penalized by the number of terminal nodes |T|.
# Hence, Small "CP" results in larger trees and potential overfitting, large CP" in small trees and potential underfitting.
# => The "rel error" is 1- RSquare, similar to linear regression. This is the error on the observations used to estimate the model. The last node value of rel error suggests the R-Square of the model, if this happens to be the model
# => The "xerror" is is the error on the observations from cross validation data, which happens to be a 10-Fold Cross Validation. Particpants need to note that, in order to reproduce the "xerror" values, they must use the same set.seed() number each time
# => Root Node Error is given by sum((Dependent - Mean(Dependent))^2), i.e.
# sum((InsDataTrainUncapped$Losses-mean(InsDataTrainUncapped$Losses))^2

#How to prune your regression tree. with least errors
printcp(x = CartFullModel) #cp means complexity parameter which is mathematical value defining how big a tree should be defined. As cp is low tree is big
plotcp(CartFullModel)

# This produces a plot which may help particpants to look for a model depending on R-Square values produced at various splits
rsq.rpart(x = CartFullModel)

#### Using CP to expand / Prune the tree ####################
# Lets change rpart.control() to specify certain attributes for tree building
RpartControl = rpart.control(cp = 0.027) #with this cp value i want my tree
set.seed(123)
CartModel_1 = rpart(formula = Annual_Sales ~ . , 
                    data = Mer_SalesTrainUncapped[,-1], 
                    method = "anova", control = RpartControl)

CartModel_1
summary(CartModel_1)
rpart.plot(x = CartModel_1, type = 4,fallen.leaves = T, cex = 0.6)
printcp(x = CartModel_1)
plotcp(CartModel_1)
rsq.rpart(x = CartModel_1)




####### Some Extra pointers in R #####################


# Model Evaluation Measures on test dataset using the finalized (pruned model)
# Use predict() the get the predicted values for the testset using the finalized model

# Intermediate Model: Finalize CartFullModel (Based on Tree size i.e. Depth, Variables included as well as the R-Square produced)
# Predict on testset
CartFullModelPredictTest = predict(object = CartFullModel, newdata = Mer_SalesTestUncapped, type = "vector")
CartFullModelPredictTest
# Calculate RMSE and MAPE manually
# Participants can calculate RMSE and MAPE using various available functions in R, but that may not
# communicate effectively the mathematical aspect behind the calculations

# RMSE
Act_vs_Pred = CartFullModelPredictTest - Mer_SalesTestUncapped$Annual_Sales # Differnce
Act_vs_Pred_Square = Act_vs_Pred^2 # Square
Act_vs_Pred_Square_Mean = mean(Act_vs_Pred_Square) # Mean
Act_vs_Pred_Square_Mean_SqRoot = sqrt(Act_vs_Pred_Square_Mean) # Square Root
Act_vs_Pred_Square_Mean_SqRoot

# MAPE
Act_vs_Pred_Abs = abs(CartFullModelPredictTest - Mer_SalesTestUncapped$Annual_Sales) # Absolute Differnce
Act_vs_Pred_Abs_Percent = Act_vs_Pred_Abs/Mer_SalesTestUncapped$Annual_Sales # Percent Error
Act_vs_Pred_Abs_Percent_Mean = mean(Act_vs_Pred_Abs_Percent)*100 # Mean
Act_vs_Pred_Abs_Percent_Mean

# Validate RMSE and MAPE calculation with a function in R
library(forecast)
UncappedModelAccuarcy = accuracy(f = CartFullModelPredictTest, x = Mer_SalesTestUncapped$Annual_Sales)
UncappedModelAccuarcy #part of forecast library. 


AIC(CartModel_1) 
windows()
fancyRpartPlot(model = CartModel_1, main = "Final CART Regression Tree", cex = 0.6, sub = "Model 12")