######################
##   D-03 exercise  ##
######################
## svm
### leave-one-out cross validation
### write function for doing leave-one-out cv
svm.cv <- function(i, d1) {
	# write your code here

}
p <- as.data.frame(t(sapply(1:nrow(d1), function(i, d1) svm.cv(i, d1), d1)))
colnames(p) <- c("y", "yp")
y <- p$y
yp <- p$yp
rsq <- ""
rsq <- round(rsq, 3)
cor <- ""
plot(y, yp, main=sprintf("SVM Leave-1-Out (Cor = %s, R^2 = %s)", cor, rsq), xlab=sprintf("y (%s)", yn))
abline(0, 1, col="red", lty=2, lwd=3)
