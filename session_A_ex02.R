######################
##   A-02 exercise  ##
######################
library(xml2)
source("solution/session_A_sol01.R")

# set target url and read html
web.url <- "http://search.appledaily.com.tw"
base.url <- paste0(web.url, "/charity/projlist/Page/")
doc <- read_html(base.url)

# from A-01 exercise bonus, we get the number of total pages, n.page
n.page <- as.integer(n.page)

# just run one page
page <- sample(1:n.page, 1)

# set the url (for later sapply use)
# "http://search.appledaily.com.twhttp://search.appledaily.com.tw/charity/projlist/Page/"
url <- ""
doc <- read_html(url)

# get all info from the table
# columns:
# 1 aid
# 2 title
# 3 date.published
# 4 case.closed
# 5 donation
# 6 details (no use)
# 7 url.article
# 8 url.detail

article.list <- local({
    # write down your code for parsing the web pages
    # using xpath and xml2 package metioned in class
    
})


### (optional)
### article.list$case.closed <- ifelse(article.list$case.closed=="未結案", 0, 1)
View(article.list)

# write your table to file
save <- F
if (save) {
    write.csv(article.list, "data/df_article_raw.csv", row.names=F)
}
