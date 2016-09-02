######################
##   B-03 exercise  ##
######################
## detrending and find more variables
### Goal : 1 detrend number of donors with linear model (lm) method
###        2 create more features
###        3 visualization


### Detrend donars with time ###
l <- lm(d$donor ~ d$date.published)  # to fit a lowess regression
y <- predict.lm(l, d$date.published)
d$donor.de <- d$donor - y + mean(y)  # to detrend donation, and take donation back to normal amount

### Visualization ###
with(d, plot(date.published, donor.de, pch = ".", cex = 2, col = 'blue', las = 1,
             xlab="", ylab=""))
with(d, points(date.published, donor, pch = ".", col = "red", cex = 2,
               xlab="", ylab=""))
title("Number of Donors for Each Article, Detrend Vs. Original", 
      xlab="Publish time", ylab="Number of donors")
legend('topleft', c('detrend', 'original'), pch = c(".", "."),
       pt.cex = c(4, 4), col = c('black', 'red'))

### Create other variables from title  ###
### get titles metioned "cancer"
i <- grep('癌', d$title)
d$ttl.cancer <- 0
d[i,]$ttl.cancer <- 1

### get titles metioned "rare"
i <- grep('罕', d$title)
d$ttl.rare <- 0
d[i,]$ttl.rare <- 1

### Create other variables from time
# For example, not used
# Case open duration
d$case.duration <- d$date.funded - d$date.published
d$case.Pub.weekdays <- weekdays(d$date.published)

### Visualization ###
# Plot dual condition
with(d, boxplot(donation.de ~ ttl.cancer + ttl.rare,
                outline = F, las = 1, col = heat.colors(4)))
title('Donation in Dual Condition (Cancer + Rare)')

### Example code
with(d, boxplot(donation.de ~ case.Pub.weekdays, 
                outline = F, las = 1, col = heat.colors(7)))
title('Total Donation Amount Vs. Article Published on Which Day of Week')
# Done



########
# Skip #
########
### Create Variables inside with raw donation data
# Read data
'
library(data.table)
df_donation <- read.csv("data/df_donation.csv", header = T)
df_donation <- data.table(df_donation)
# Change data type
df_donation$donate.date <- as.Date(df_donation$donate.date)
df_donation$aid <- as.character(df_donation$aid)
df_donation$donation <- as.integer(df_donation$donation)
# do simple summary on donation by each case (aid)
df_donation_aid <- df_donation[, .(donate.avg = mean(donation, na.rm = T),
                                   donate.sd = sd(donation, na.rm = T),
                                   donate.tdfiff = max(donate.date)-min(donate.date)
                                   ), by = aid]


# change data type
d$aid <- as.character(d$aid)
d$donate.tdiff <- as.numeric(d$donate.tdfiff)
# join tables
d <- left_join(d, df_donation_aid, by = "aid")

with(d, plot(donor, donate.avg, pch = ".", cex = 3), xlab = ""n.donars"") 
title("Numbers of donar vs. average donation")
summary(d[, c("donate.avg", "donate.tdiff")])
'