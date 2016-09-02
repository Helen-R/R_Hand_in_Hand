######################
##   D-04 exercise  ##
######################
## classification
### D-04 split top 25% and last 25% ##
# set the range of quantile 25% and 75%
ran <- quantile()

### subset the data to get top 25% and last 25%
d2 <- d1[which(), ]
### set the condition to name the quantil "high" and "low"
condi <- ""
d2[, yn] <- ifelse(d2[, yn] > condi, "high", "low")
d2[, yn] <- as.factor(d2[, yn])

### use function svm.cv to get the model prediction
p <- as.data.frame(t(sapply(1:nrow(d2), function(i, d2) svm.cv(i, d2), d2)))
colnames(p) = c("y", "yp")
tb <- table(p)

### calculate the number of true positive
TP <- ""
### calculate the number of true negative
TN <- ""
### calculate the accuracy
acc <- ""
# calculate the f1-score
fsc <- ""
