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

## 1 list all files & do a simple check
### YOUR path to the folder for articles
fls <- list.files("data/db_detail_txt", pattern=".txt", full.names = T)
### check the file size
fls <- fls[file.info(fls)$size!=0]

## 2 read them all (into list form)
dta <- ldply(lapply(fls, function (file.path) {
    df <- read.table(file.path, header = F, sep = ",", fileEncoding = 'utf-8')
    # add aid to a new column
    df$aid <- gsub(".txt", "", basename(file.path)) # Remove ".txt", make it an aid!
    return(df[, c("aid", "V2", "V3", "V4")])
}))

### set column names
colnames(dta) <- c("aid", "date.donate", "donation", "donor")


### use head() and typeof() to take a look of the data
head(dta)
### check and change data type
sapply(dta, typeof)
dta$donation <- as.numeric(dta$donation)

### write data frame to file names "df_donation.csv"
save <- F
if (save) {
    write.csv(dta, file = "data/df_donation.csv", fileEncoding = "utf-8", row.names=F)
}


## 3 Count how many donors for each case
### transform to data table
dta <- data.table(dta)
df_aid <- dta[, .(count = .N), by = aid]
### try more
df_aid <- dta[, .(donation = sum(donation, na.rm = T),
                  donation.mean = mean(donation, na.rm = T),
                  donation.med = median(donation, na.rm = T)), by = aid]

### Done ###
print("DONE!!!")

