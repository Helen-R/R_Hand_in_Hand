######################
##   B-02 exercise  ##
######################
## eda (exploratory data analysis)
### Goal : 1 NA handling
###        2 make some more plots to explore

# 1 NA handling
i <- which(is.na(d$n.word))
d[i, ]$n.word <- mean(d$n.word, na.rm = T) # replace with mean value
i <- which(is.na(d$n.image))
d[i, ]$n.image <- median(d$n.image, na.rm = T) # replace with median



# 2 make some more plots to explore

## is number of donors and donation amount varies along with time?

### donation vs. pushlish date
### make a scatter plot
with(d, plot(date.published, donation, pch ='.', ylim = c(0, 2e6), cex = 2,
             xlab="Publish date", ylab="Donation amount"))
abline(lm(donation ~ date.published, data = d), col = 'red')
title(main = 'Donation Amount per Article Along Time')

### plot donor vs. pushlish date
### make a scatter plot
with(d, plot(date.published, donor, pch = ".", cex=2,
             xlab="Publish date", ylab="Number of donors"))
abline(lm(donor ~ date.published, data = d), col = 'red')
title('Number of Donors per Article Along Time')




### set plot parameters
# par(family = 'STHeiti')
par(mfrow=c(2, 1))
par(mar = c(6, 4, 2, 1))

### check average donation per donor per article along time
### make a box plot
with(d, boxplot( (donation/donor) ~ format(date.published, "%Y"), 
                 pch = ".", cex = 2, las = 2, outline = F))
title(main = "Average Donation By Year", 
      ylab="Average donation per donor per article")

### check different donation amount per donor per article vs. journalist
### make a box plot
with(d, boxplot( (donation/donor) ~ journalist, outline = F, las = 2))
title(main = 'Average Donation Vs. Journalists', 
      ylab="Average donation per donor per article")


### done
### reset par
par(mfrow = c(1,1))
