######################
##   D-03 exercise  ##
######################
## bonus
### try change different kernel and check the difference
svm.cv <- function(i, d1, kern) {
    testing <- d1[i, ]
    training <- d1[-i, ]
    fit <- svm(form, data=training, kern=kern)
    p <- predict(fit, testing)
    print(i)
    flush.console()
    c(testing[, yn], p)
}
p.ls <- list()
kerns <- c("linear", "polynomial", "radial", "sigmoid")
for (k in 1:length(kerns)) {
    kern <- kerns[k]
    p <- as.data.frame(t(sapply(1:nrow(d1), function(i, d1, kern) svm.cv(i, d1, kern), d1, kern)))
    colnames(p) <- c("y", "yp")
    y <- p$y
    yp <- p$yp
    rsq <- 1 - sum((y-yp)^2) / sum((y-mean(y))^2)
    rsq <- round(rsq, 3)
    cor <- round(cor(y, yp), 3)
    plot(y, yp, main=sprintf("SVM Leave-1-Out (Cor = %s, R^2 = %s)", cor, rsq), xlab=sprintf("y (%s)", yn))
    abline(0, 1, col="red", lty=2, lwd=3)
    p.ls[[k]] <- p
}
