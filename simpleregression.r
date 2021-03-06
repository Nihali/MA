#Regression

# Regression : Areas vs Sales
#X -is area in sqft, Y- sales in 1000s units; Find relationship betn X & Y
X = c(1.7,1.6,2.8,5.6,1.3,2.2, 1.3,1.1,3.2,1.5,5.2,4.6,5.8,3 )
Y = c(3.7,3.9,6.7,9.5,3.4,5.6,3.7,2.7,5.5,2.9,10.7,7.6,11.8,4.1 )


# Use Vector Data for this example
mean(X); mean(Y)
sum(X); sum(Y)
cov(X,Y); cov(Y,X)
cor(X,Y) ; cor(Y,X)
cor.test(X,Y)
plot(X,Y,xlab='Area in sqft', ylab='Sales Amount', type='p', main='Plot of Area Vs Sales') #Plot in'p' ie points
abline(lm(Y ~ X)) #abline is prediction line when y depends on x. the line should pass from middle of points
abline(v=c(3,5),h=5.9742, col='red') #Vertical lines at 3 and 5
df1 = data.frame(X,Y)
head(df1)
#Model
fit1 = lm(Y ~ X, data=df1) #lm is linear modelling command where y depends on x
fit1 #creating model in R language
range(X) #min and max value of X
summary(fit1) #Residuals is the difference between predicted and actual value of Y

#Coefficients
#It value of probability is less than 0.05 then X is significant and Y is strongly related to X. 
names(fit1)

coef(fit1)[2]
# Predictions
(Y = 0.9645 + 1.6699 * 4)  # for X=4
(Y=coef(fit1)[1]+coef(fit1)[2]*4)
fitted(fit1) #Prediction of Y values using X=4
cbind(df1, fitted(fit1)) #column binds X, Y and fitted(fit1) 

range(X)
new1 = data.frame(X=c(1,2,3,4,5))
predict(fit1, newdata= new1) #Predict values of Y on random values of X

#df1$predict = predict(fit1, newdata= new2)
df1$predict = fitted(fit1)
head(df1)

#Variation
(SSE = sum((df1$Y - df1$predict)^2))
(SSR = sum((df1$predict - mean(df1$Y))^2))
#11.2 + 105.74
(SST = sum((df1$Y - mean(df1$Y))^2))

anova(fit1)
(r2 = SSR/SST)
summary(fit1)$r.squared


summary(fit1)$sigma
summary(fit1)
anova(fit1)
qt(0.95+.025, 14-2)


#Assumption : Graphical Analysis
plot(x=X, y=residuals(fit1)) # Linearity
plot(residuals(fit1))
car::durbinWatsonTest(fit1) #To check independence of errors

#Normality
hist(residuals(fit1), freq=F)
lines(density(residuals(fit1)))

(h=hist(residuals(fit1)))
names(h)
cbind(h$breaks, h$counts)

qqnorm(residuals(fit1))
qqline(residuals(fit1))  #plots the graph and makes a line when we dont standardize the errors. 


residuals(fit1)
rstandard(fit1)
sales.stdres = rstandard(fit1)
qqnorm(sales.stdres, ylab="Standardized Residuals", xlab="Normal Scores", main="Checking normality of Residuals") 
qqline(sales.stdres)
stem(residuals(fit1))

#Equal Variance
plot(y=residuals(fit1), x=X) #If the model is linear, there is no pattern of residuals with X


#Outlier Analysis
df1
df1[14,]
df1$Y
residuals(fit1)
boxplot( df1$Y, df1$predict, residuals(fit1), names=c('Y','predictY', 'Residuals'))
abline(h=c(4.1, 5.97, -1.87))
boxplot(residuals(fit1), names=c('Residuals'))
identify(rep(1, length(residuals(fit1))), residuals(fit1), labels = seq_along(residuals(fit1)))

car::outlierTest(fit1)
df1[14,]

car::outlierTest(lm(Y ~ X, data=df1[-14,])