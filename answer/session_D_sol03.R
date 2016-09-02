######################
##   D-03 exercise  ##
######################
## svm
### leave-one-out cross validation
### write function for doing leave-one-out cv
svm.cv <- function(i, d1) {
  testing <- d1[i, ]
  training <- d1[-i, ]
  fit <- svm(form, data=training)
  p <- predict(fit, testing)
  print(i)
  flush.console()
  c(testing[, yn], p)
}
p <- as.data.frame(t(sapply(1:nrow(d1), function(i, d1) svm.cv(i, d1), d1)))
colnames(p) <- c("y", "yp")
y <- p$y
yp <- p$yp
rsq <- 1 - sum((y-yp)^2) / sum((y-mean(y))^2)
rsq <- round(rsq, 3)
cor <- round(cor(y, yp), 3)
plot(y, yp, main=sprintf("SVM Leave-1-Out (Cor = %s, R^2 = %s)", cor, rsq), xlab=sprintf("y (%s)", yn))
abline(0, 1, col="red", lty=2, lwd=3)
