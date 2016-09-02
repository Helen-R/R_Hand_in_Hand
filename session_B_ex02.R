######################
##   B-02 exercise  ##
######################
## eda (exploratory data analysis)
### Goal : 1 NA handling
###        2 make some more plots to explore

# 1 NA handling
# replace NA of n.word with mean value


# replace NA of n.image with median




# 2 make some more plots to explore
## is number of donors and donation amount varies along with time?
### donation vs. pushlish date
### make a scatter plot
x <- ""
y <- ""
plot(x, y, pch ='.', ylim = c(0, 2e6), cex = 2,
	xlab="Publish date", ylab="Donation amount")

### plot donor vs. pushlish date
### make a scatter plot
plot()



### check average donation per donor per article along time
### make a box plot
x <- ""
y <- ""
y <- format(y, "%Y")
boxplot( y ~ x, pch = ".", cex = 2, las = 2, outline = F)


### check different donation amount per donor per article vs. journalist
### make a box plot
boxplot()





### done
### reset par
par(mfrow = c(1,1))
