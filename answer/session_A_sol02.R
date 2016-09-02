######################
##   A-02 exercise  ##
######################
library(xml2)
source("answer/session_A_sol01.R")

# set target url and read html
web.url <- "http://search.appledaily.com.tw"
base.url <- paste0(web.url, "/charity/projlist/Page/")
doc <- read_html(base.url)

# from A-01 exercise bonus, we get the number of total pages, n.page
n.page <- as.integer(n.page)

# NOT run for all pages, takes too much time
page <- sample(1:n.page, 1)

# set the url (for later sapply use)
# "http://search.appledaily.com.tw/charity/projlist/Page/"
url <- paste0(base.url, page)
doc <- read_html(url)

# get all links of both articles and donation records
t1 <- xml_attr(xml_find_all(doc, "//*[@id='inquiry3']//a"), "href")
t1 <- data.frame(matrix(t1, ncol=2, byrow=T), stringsAsFactors = F)
colnames(t1) <- c("url.article", "url.detail")
t1$url.detail <- paste0(web.url, t1$url.detail)

# get all info from the table
t2 <- xml_text(xml_find_all(doc, "//*[@id='inquiry3']/table/tr/td"))
t2 <- data.frame(matrix(t2, ncol=6, byrow=T), stringsAsFactors = F)
colnames(t2) <- c("aid", "title", "date.published", "case.closed", "donation", "details")
t2 <- t2[, -which(colnames(t2)=="details")]
stopifnot(ncol(t2)==5, nrow(t2)==20)

# bind table and url info
article.list <- cbind(t2, t1)

### (optional)
### article.list$case.closed <- ifelse(article.list$case.closed=="未結案", 0, 1)
View(article.list)

# write your table to file
save <- F
if (save) {
    write.csv(article.list, "data/df_article_raw.csv", row.names=F)
}