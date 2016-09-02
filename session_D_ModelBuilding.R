library(data.table)
library(plyr)
library(dplyr)
library(e1071)
library(rpart)
library(randomForest)
library(fmsb)
source("func/vif.R")
#require(lm.beta)
options(stringsAsFactors=F)


##############
##   D-01   ##
##############
## build model by text----
### get article word list

# load("data/list_article_words.RData")
load("data/list_article_words(jieba).RData")
### get word vector (GolVe)
w <- fread("data/w2glv_100.csv", encoding="UTF-8")
dim(w)
colnames(w)[1] <- 'term'

### caculate aritcle vector
#####################################################
## NO RUN !!, unless your computer is good enough !!#
#####################################################
'
v <- lapply(article_words, function(f){
  colSums(w[w$V1 %in% f, -which(colnames(w)=="V1"), with=F])
})
v <- lapply(article_words, function(f){
  colSums(w[w$V1 %in% f, -which(colnames(w)=="V1"), with=F])
})
v <- ldply(v, rbind)
rownames(v) <- names(article_words)
n <- ncol(w)-1
colnames(v) <- c("terms", sprintf("vg%s_%02d", n, 1:n))

write.csv(v, "data/a2glv_100.csv", fileEncoding = "UTF-8")
'

## journalist analysis 
### data preparation
load('data/w2v_name_clustering(k=200).Rdata')

### Prevent comtamination "d"
d0 <- d
### subset the column by names
ch <- which(sapply(d0, is.factor))     # mark character columns 
ttl<- names(d0)[grep("^ttl", colnames(d0))]
fb <- names(d0)[grep("fb", colnames(d0))]
kg <- names(d0)[grep('^k', names(d0))]
time <- names(d0)[grep('day|month', names(d0))]
yns <- names(d0)[grep('^don', names(d0))]
rest <- names(d0)[!names(d0)%in%c(ttl, fb, kg, yns, time, names(ch))]
stopifnot(sum(sapply(list(ch, ttl, fb, kg, time, yns, rest), length))==ncol(d0))


### set your target variable
yn <- "journalist"
form <- formula(sprintf("%s ~ .", yn))
### subset the data
d4 <- d[, c("aid", yn, ttl, fb, time, kg)]

d4 <- d4[d4$journalist %in% names(table(d4$journalist)[table(d4$journalist)>200]), ]

a <- fread("data/a2v_100.csv", encoding="UTF-8")
d4 <- left_join(d4, a, by="aid", type="inner")
d4 <- d4[, -which(colnames(d4)=="aid")]


d4$journalist <- as.factor(as.character(d4$journalist))

### decision tree
set.seed(904)
sample_index <- sample(1:nrow(d4), nrow(d4) * 0.95)
d4_trn <- d4[sample_index, ]
d4_tst <- d4[-sample_index, ]

dt.fit <- rpart(form, data=d4_trn)
printcp(dt.fit)
plot(dt.fit, uniform=T)
text(dt.fit, use.n=T, cex=0.75)
summary(dt.fit)
# plotcp(dt.fit)
dt.predict <- predict(dt.fit, d4_tst, type = 'class')

out <- table(dt.predict, d4_tst$journalist)
out <- as.data.frame.matrix(out) # transform table to confusion matrix 
View(out)
acc <- sum(diag(as.matrix(out))) / sum(out)
acc




######################
##   D-01 exercise  ##
######################
## build model by text
### complete the exercise!
file.edit("session_D_ex01.R")




##############
##   D-02   ##
##############
## linear model----
### select our year span and columns
s.date <- '2015-01-01'
i <- which(as.Date(as.character(d0$date.published)) > as.Date(s.date))
d0 <- d0[i, -ch]

### remove outliers, keep donation.de between 5% - 95%
tmp <- quantile(d0$donation.de, c(0.05, 0.95))
i <- which(d0$donation.de >= tmp[1] & d0$donation.de <= tmp[2])
d0 <- d0[i, ]


### set your response variable (y)
yn <- "donor.de"

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
condi <- abs(cor.mat[, yns]) > 0.08
condi[!complete.cases(condi), ] <- 0
idx <- rowSums(condi) > 0
d1 <- d0[, c(yn, colnames(cor.mat)[idx])]
d1 <- d1[, colnames(d1) %in% c(yn, ttl, fb, time, kg)]

### VIF
x.ttl <- vif(d1[, names(d1) %in% ttl])
x.g <- vif(d1[, names(d1) %in% kg])
x.t <- vif(d1[, names(d1) %in% time])
x.fb <- vif(d1[, names(d1) %in% fb])
d1 <- d1[, colnames(d1) %in% c(yn, x.ttl, x.fb, x.g, x.t)]

### regression & examinee ##
form <- formula(sprintf("%s ~ .", yn))
lm.fit <- lm(form, data=d1)
lm.select <- step(lm.fit)

summary(lm.fit)    # see adjusted R2
summary(lm.select) # see adjusted R2
rmse <- function(error) {
	sqrt(mean(error^2))
} 
m1RMSE <- rmse(lm.fit$residuals)
m2RMSE <- rmse(lm.select$residuals)
c(m1RMSE, m2RMSE)

### model comparison
anova(lm.fit, lm.select)

### Optional, need load lm.beta package
# lm.beta(lm.fit) # Standardize coef




######################
##   D-02 exercise  ##
######################
## linear model
### complete the exercise!
file.edit("session_D_ex02.R")




##############
##   D-03   ##
##############
## svm----
svm.fit <- svm(form, data=d1)
yp <- predict(svm.fit)
y <- d1[, yn]
cor <- cor(y, yp)
rsq <- 1 - sum((y-yp)^2) / sum((y-mean(y))^2)
plot(y, yp, main=sprintf("SVM Prediction ( y = %s)", yn))
abline(0, 1, col="red", lty=2, lwd=3)

i <- 1
testing <- d1[i, ]
training <- d1[-i, ]
svm.fit <- svm(form, data = training)
p <- predict(fit, testing)
c(testing[, yn], p)




######################
##   D-03 exercise  ##
######################
## svm
### complete the exercise!
file.edit("session_D_ex03.R")




##############
##   D-04   ##
##############
## classification----
### cut data in half (50-50)
d2 <- d1
med <- median(d2[, yn])
d2[, yn] <- ifelse(d2[, yn] > med, "high", "low")
d2[, yn] <- as.factor(d2[, yn])

svm.cv <- function(i, d1) {
  testing <- d1[i, ]
  training <- d1[-i, ]
  tmp <- training[, colnames(training)!=yn]
  if(sum(colSums(tmp)==0) != 0) {
    d1 <- d1[, -which(colnames(training)==names(tmp)[colSums(tmp[, colnames(tmp)!=yn])==0])]
  }
  
  fit <- svm(form, data=training, type="C")
  p <- predict(fit, testing)
  print(i)
  flush.console()
  c(testing[, yn], p)
}
p <- as.data.frame(t(sapply(1:nrow(d2), function(i, d2) svm.cv(i, d2), d2)))
colnames(p) = c("y", "yp")
tb <- table(p)
TP <- tb[2, 2]
FP <- tb[2, 1]
FN <- tb[1, 2]
### accuracy
acc <- mean(p$y==p$yp)
### f1-score
fsc <- 2 * TP / (2 * TP + FP + FN)




######################
##   D-04 exercise  ##
######################
## classification
### complete the exercise!
file.edit("session_D_ex04.R")
