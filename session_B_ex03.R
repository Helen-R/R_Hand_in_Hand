######################
##   B-03 exercise  ##
######################
## detrending and find more variables
### Goal : 1 detrend number of donors with linear model (lm) method
###        2 create more features
###        3 visualization


### Detrend donars with time ###
x1 <- ""
y1 <- ""
l <- lm(y1 ~ x1)  # to fit a lowess regression
y <- predict.lm(l, y1)
d$donor.de <- d$donor - y + mean(y)  # to detrend donation, and take donation back to normal amount

### Visualization ###
x2.1 <- ""
y2.1 <- ""
y2.2 <- ""
plot(x2.1, y2.1, pch = ".", cex = 2, col = 'blue', las = 1, xlab="", ylab=""))
points(x2.1, y2.2, pch = ".", col = "red", cex = 2, xlab="", ylab=""))
title("Number of Donors for Each Article, Detrend Vs. Original", 
      xlab="Publish time", ylab="Number of donors")
legend('topleft', c('detrend', 'original'), pch = c(".", "."),
       pt.cex = c(4, 4), col = c('black', 'red'))

### Create other variables from title  ###
### get titles metioned "cancer"
pattern1 <- '癌'
i <- grep(pattern1, d$title)
d$ttl.cancer <- 0
d[i,]$ttl.cancer <- 1

### get titles metioned "rare"
pattern2 <- ""
i <- ""
d$ttl.rare <- 0
d[i, ]$ttl.rare <- 1

### Create other variables from time
### for example:
###	    case open duration = date.funded - date.published



### Visualization ###
# Plot dual condition
y3.1 <- ""
x3.1 <- ""
x3.2 <- ""
with(d, boxplot(y3.1 ~ x3.1 + x3.2,
                outline = F, las = 1, col = heat.colors(4)))
title('Donation in Dual Condition (Cancer + Rare)')






# Done
