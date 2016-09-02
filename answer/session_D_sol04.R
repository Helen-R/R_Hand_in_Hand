######################
##   D-04 exercise  ##
######################
## classification
### D-04 split top 25% and last 25% ##
ran <- quantile(d1[, yn], c(0.25, 0.75))[c("25%", "75%")]
d2 <- d1[which(d1[, yn] > ran["75%"] | d1[, yn] < ran["25%"]), ]
d2[, yn] <- ifelse(d2[, yn]>ran["75%"], "high", "low")
d2[, yn] <- as.factor(d2[, yn])

p <- as.data.frame(t(sapply(1:nrow(d2), function(i, d2) svm.cv(i, d2), d2)))
colnames(p) = c("y", "yp")
tb <- table(p)
TP <- tb[1, 1]
TN <- tb[2, 2]
# accuracy
acc <- mean(p$y==p$yp)
# f1-score
fsc <- 2 * TP / (TP + (nrow(p) - TN))
