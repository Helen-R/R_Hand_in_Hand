######################
##   D-01 exercise  ##
######################
# build model by text
# set a ratio to divide the dataset into training set and testing set
sRate <- ""
sample_index <- sample()

d4_trn <- ""
d4_tst <- ""

# Please fit the correct data into rpart
form <- ""
dt.fit <- rpart(form, data= " ")
printcp(dt.fit)
plot(dt.fit, uniform=T)
text(dt.fit, use.n=T, cex=0.75)
summary(dt.fit)
# plotcp(dt.fit)

# Please make a prediction and compute its accuaracy
dt.predict <- predict()

# transform table to confusion matrix
out <- local({
	# write your code here to generate the confusion matrix

})

View(out)

# write your code here to calculate the accuracy
acc <- ""

