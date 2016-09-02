##############
##   D-02   ##
##############
## linear model----
### select our year span and columns
s.date <- '2'
i <- which(as.Date(as.character(d0$date.published)) > as.Date(s.date))
d0 <- d0[i, -ch]

### remove outliers, keep donation.de between 5% - 95%
tmp <- quantile(d0$donation.de, c(0.05, 0.95))
i <- which(d0$donation.de >= tmp[1] & d0$donation.de <= tmp[2])
d0 <- d0[i, ]


### set your response variable (y)
yn <- ""

### remove outlier, keep 95% of donor.de data
ran <- quantile(d0[, yn], seq(0, 1, 0.025))[c("2.5%", "97.5%")]
l <- nrow(d0)
i <- which(d0[, yn] < ran[1] | d0[, yn] > ran[2])
d0 <- d0[-i, ]

print(sprintf("exclude %s percents of data", 100 * round(length(i) / l, 3)))
print(sprintf("%s_to_now", s.date))
d0 <- d0[, c(yns, ttl, fb, time, kg)]

### check covariance ##
if(sum(colSums(d0)==0) > 0) {
  d0 <- d0[, -which(colSums(d0)==0)]
}

### prune by correlation values
cor.mat <- cor(d0, use="complete")
# View(cor.mat)
condi <- abs(cor.mat[, yns]) > ""	# set your threshold
condi[!complete.cases(condi), ] <- 0
idx <- rowSums(condi) > 0
d1 <- d0[, c(yn, colnames(cor.mat)[idx])]
d1 <- d1[, colnames(d1) %in% c(yn, ttl, fb, time, kg)]

### VIF
x.ttl <- vif(d1[, names(d1) %in% ttl])
x.g <- vif()
x.t <- vif()
x.fb <- vif()
d1 <- d1[, colnames(d1) %in% c(yn, x.ttl, x.fb, x.g, x.t)]

### regression & examinee ##
form <- formula()
lm.fit <- lm(form, data=d1)
lm.select <- step(lm.fit)

summary(lm.fit)    # see adjusted R2
summary(lm.select) # see adjusted R2
rmse <- function(error) {
	# write down your code here

} 
m1RMSE <- rmse(lm.fit$residuals)
m2RMSE <- rmse(lm.select$residuals)
c(m1RMSE, m2RMSE)

### model comparison
anova(lm.fit, lm.select)
