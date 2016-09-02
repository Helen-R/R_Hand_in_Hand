######################
##   B-01 exercise  ##
######################
## data manipulation
### Goal: transform each article's donation into a big table
###       and extract how many donors for each case

### load library
library(plyr)
library(dplyr)
library(data.table)

### 1 list all files & do a simple check
### YOUR path to the folder for donation details
dir.path <- ""
fls <- list.files(dir.path, pattern=".txt", full.names = T)
### check the file size 
fls <- fls[file.info(fls)$size!=0]

### 2 read them all (into list form)
i <- 1
file.path <- fls[i]
dta <- read.table(file.path, header = F, sep = ",", fileEncoding = 'utf-8')
### get aid of this article
file.name <- basename(file.path)
### extract aid from file name "[aid].txt"
### for example: filename = "A0001.txt"
###              aid = "A0001"
pattern <- ""
replacement <- ""
aid <- gsub(pattern, replacement, file.name)
# add aid to a new column
dta$aid <- aid
dta <- dta[, c("aid", "V2", "V3", "V4")]
### set column names
colnames(dta) <- c("aid", "date.donate", "donation", "donor")


### use head() and typeof() to take a look of the data



### write data frame to file names "df_donation.csv"



## 3 count how many donors for each case



### Done ###
print("DONE!!!")

