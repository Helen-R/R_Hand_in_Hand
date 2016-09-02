len = length
options(stringsAsFactors = F)

library(data.table)
library(dplyr)
source("answer/session_A_sol03.R", encoding="utf-8")


##############
##   B-01   ##
##############
## data manipulation----
## session A outcome
### 1 df_article_raw.csv
### 2 data/db_articles_txt/[aid].txt
### 3 data/db_detail_txt/[aid].txt

### df_article_raw.csv -> df_article.csv
### meta information
### 1 journalist
### 2 number of images
### 3 number of words
meta.info <- read.csv("data/meta.info.csv", fileEncoding = "utf-8")
head(meta.info)
d.raw <- left_join(article.list, meta.info, by="aid")

### read in donation details
aid <- "A0002"  # or try aid <- article.list$aid[1]
file.path <- sprintf("data/db_detail_txt/%s.txt", aid)
df1 <- read.table(file.path, header = F, sep = ",", fileEncoding = 'utf-8')
df1$aid <- aid

aid <- "A0004"
file.path <- sprintf("data/db_detail_txt/%s.txt", aid)
df2 <- read.table(file.path, header = F, sep = ",", fileEncoding = 'utf-8')
df2$aid <- aid

df <- rbind(df1, df2)
df <- df[, c("aid", "V2", "V3", "V4")]
colnames(df) <- c("aid", "date.donate", "donation", "donor")

df$date.donate <- as.Date(df$date.donate, "%Y/%m/%d")

dt <- data.table(df)
dt[, .(donor=.N, date.funded=max(date.donate)),by=aid]




######################
##   B-01 exercise  ##
######################
## data manipulation
### Goal: transform each article's donation into a big table
###       and extract how many donors for each case
### complete the exercise!
file.edit("session_B_ex01.R")



## output
### df_article.csv
### df_donation.csv




##############
##   B-02   ##
##############
## eda (exploratory data analysis)----
### read in article list (more than 3000 articles)
d <- read.csv('data/df_article.csv', fileEncoding = 'utf-8')

dim(d)

### assign useless columns to another variable
i <- which(names(d) %in% c('url.article', 'url.detail'))  # "A %in% B" is to check which in A is in B
d.url <- d[, i]  # to save url to another variable
rownames(d.url) <- d$aid
if(len(i)) d <- d[, -i] # if(len(i)) is a mechanic to prevent accidentally remove d 

### check data frame format and change format ###
typeof(d$date.published) # view one column per execution

### A quick method, view all
sapply(d, typeof)

# change the format, 3 columns for example
d$date.published <- as.Date(d$date.published)  # change to Date type
d$date.funded <- as.Date(d$date.funded)  # change to Date type
d$title <- as.character(d$title)  # change to character type

### take a look of data frame
dim(d)
names(d)
str(d)
head(d)
tail(d)
summary(d)

### remove which donor is NA
i <- which(is.na(d$donor))
if (len(i)) d <- d[-i, ]

### remove on-going cases
i <- which(d$case.closed == '未結案')  
if (len(i)) d <- d[-i, ]

### check the extreme value
d[which.max(d$donation),]
d.url[which.max(d$donation),]


## how much donation does a family get?
### donation distribution----
hist(d$donation)
hist(d$donation, breaks = 100)


## how many people made contribution the a family?
### donor distribution----
hist(d$donor, breaks = 100)


## is the number of donors and the amount of donation related?
### donation vs. donor----
plot(d$donor, d$donation, pch = '.', cex = 2)  # pch can change the character used to plot
title('Donor Vs. Donation', xlab="Number of donors", "Donation amount")
abline(lm(donation ~ donor, d), col = 'red', lwd = 1.5)

cor.test(d$donation, d$donor)  # to check correlation



## is the donation amount different with each journalist?
### par(family = 'STHeiti') # for Mac user
n.jour = len(unique(d$journalist)) 
b <- boxplot(d$donation ~ d$journalist, col = heat.colors(n.jour),
             outline = F, las = 3, ylim = c(0, 1.2e6))  # outline is to remove outlier, ylim is to adjust y limitation
abline(h = mean(d$donation), lty = 2, lwd = 1.5)
title(main = 'Jounalist Performance', ylab = 'Donation')
text(1:len(b$n), (b$stats[3,]+b$stats[4,]) / 2, b$n, cex = 0.8, col = 'blue')




######################
##   B-02 exercise  ##
######################
## eda (exploratory data analysis)
### Goal : 1 NA handling
###        2 make some more plots to explore
### complete the exercise!
file.edit("session_B_ex02.R")




##############
##   B-02   ##
##############
## eda (cont'd)
## why some journalists outweight others?
## could be effected by time also
### plot articles published date of each journalist
# par(family = 'STHeiti')
par(mfrow=c(1, 2))
par(mar = c(6, 4, 2, 1))
n.jour = len(unique(d$journalist)) 
b <- boxplot(d$donation ~ d$journalist, col = heat.colors(n.jour),
             outline = F, las = 3, ylim = c(0, 1.2e6))  # outline is to remove outlier, ylim is to adjust y limitation
abline(h = mean(d$donation), lty = 2, lwd = 1.5)
title(main = 'Jounalist Performance', ylab = 'Donation')
text(1:len(b$n), (b$stats[3,]+b$stats[4,]) / 2, b$n, cex = 0.8, col = 'blue')

### plot articles published date of each journalist
par(mar = c(6, 4, 2, 1) + 0.1)
plot(as.factor(d$journalist), d$date.published, 
     axes = F, xlab = '', ylab = '', pch = 16, cex = 0.5)
box()
title(main = 'Articles Published Along Time', ylab = 'Publish date')
axis.Date(2, as.Date(d$date.published), las = 1)   # to plot date!!
axis(1, 1:len(unique(d$journalist)) ,labels = levels(as.factor(d$journalist)), las = 3)




##############
##   B-03   ##
##############
## detrending----
### see the donation amount varies along with date
par(mfrow=c(1, 1))  # set the plotting layout
plot(d$date.published, d$donation, cex = 2, pch = '.')
lines(lowess(d$donation ~ d$date.published), col = "red")
abline(lm(d$donation ~ d$date.published), col = "blue")

### detrend
l <- lowess(d$donation ~ d$date.published)  # to fit a lowess regression
d$donation.de <- d$donation - l$y + mean(l$y)  # to detrend donation, and take donation back to normal amount
plot(d$date.published, d$donation.de, cex = 2, pch = '.')

### revisit the journalist performance with detrended data
# par(family = 'STHeiti')
par(mar = c(5, 5, 2, 1))
b <- boxplot(d$donation.de ~ d$journalist, col = heat.colors(n.jour),
             outline = F, las = 3, ylim = c(0, 1e6))
abline(h = mean(d$donation), lty = 2, cex = 2, col = 'grey50')
title(main = 'journalist vs. donation.de', ylab = 'donation.de')
text(1:len(b$n), 0, b$n, cex = 0.8, col = 'blue')




##############
##   B-04   ##
##############
## create more features!

## create from title
### take a look into titles
head(d$title, 50)
# number of title words
if(class(d$title) !="character") d$title <- as.character(d$title)
d$ttl.n.words <- nchar(d$title)

### extract info from titles
i <- grep('夫|父|男|翁|公|爸|漢', d$title)
d$ttl.male <- 0
d[i, ]$ttl.male <- 1

i <- grep('妻|母|女|婆|嬤|媽|婦', d$title)
d$ttl.female <- 0
d[i, ]$ttl.female <- 1

i <- grep('憂', d$title)
d$ttl.anxiety <- 0
d[i, ]$ttl.anxiety <- 1

i <- grep('瞎|盲|失明', d$title)
d$ttl.eye <- 0
d[i, ]$ttl.eye <- 1


### plot different conditions
par(mfcol = c(1,2))
with(d, boxplot(donation.de ~ ttl.eye, 
                outline = F, las = 1, col = terrain.colors(2)))
title('Donation To Title Words (Blindness)')

with(d, boxplot(donation.de ~ ttl.female, 
                outline = F, las = 1, col = terrain.colors(2)))
title('Donation To itle Words (Female)')

par(mfcol = c(1,1))
## OPTIONAL ##
with(d, boxplot(donation.de ~ ttl.eye + ttl.female,
               outline = F, las = 1, col = terrain.colors(4)))
title('Donation in Dual Condition (Blindness + Female)')




######################
##   B-03 exercise  ##
######################
## detrending and find more variables
### Goal : 1 detrend number of donors with linear model (lm) method
###        2 create more features 
###        3 visualization
### complete the exercise!
file.edit("session_B_ex03.R")



### save processed file
save <- F
if (save) {
    write.csv(d, "data/df_article_after_eda.csv", row.names=F)
}
