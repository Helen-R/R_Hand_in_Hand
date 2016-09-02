######################
##   A-03 exercise  ##
######################
library(xml2)

## 1 read article list
source("answer/session_A_sol02.R",encoding="UTF-8")
# get the indices of cases which were closed from article list
detail.list.index <- which(article.list$case.closed=="已結案")
# choose the target case in our article list
i <- detail.list.index[1]
i


## 2 crawl donation record
# get aid from article list
aid <- article.list$aid[i]
# get the url of the donation detail of that case
url.detail <- article.list$url.detail[i]
doc <- read_html(url.detail)
# according to your observation, complete an Xpath to get the donation list
donate <- trimws(xml_text(xml_find_all(doc, "//*[@id='inquiry3']//*[@id='wordcenter']")))
# convert vector to data.frame
donate <- data.frame(matrix(donate, ncol=4, byrow=T),stringsAsFactors = F)
n <- nrow(donate)
# remove the header and footer of the donation table
donate <- donate[c(-1, -n),]
# assign the specific colnames
colnames(donate) <- c("aid", "donor.name", "donation", "date.donate")
donate$aid <- article.list$aid[i]
View(donate)

# create a directory to store the data
out.dir <- "data/db_detail_txt"
if(!dir.exists(out.dir)) dir.create(out.dir)
# write the organized donation list into a csv file
out.fnm <- sprintf("%s/%s.txt", out.dir, aid)
write.csv(donate, out.fnm, row.names=F,fileEncoding = "UTF-8")


## 3 crawl article----
# (also from article.list)
# get the url of the article
url.article <- article.list$url.article[i]
doc <- read_html(url.article)
# get the title
title <- xml_text(xml_find_all(doc, "//article//hgroup/h1"))
# get the context of the article
article <- xml_text(xml_find_all(doc, "//*[@class='articulum trans']/p | //*[@class='articulum trans']/h2 | //*[@class='articulum trans']/introid"))
# concate title and article into one vector
article <- c(title, article)

# create a directory to store the data
out.dir <- "data/db_articles_txt"
if(!dir.exists(out.dir)) dir.create(out.dir)
# output file name
out.fnm <- sprintf("%s/%s.txt", out.dir, aid)
# save articles to txt file
writeLines(article, out.fnm)

# get other meta info
meta.info <- NULL
n.word <- sum(nchar(article))
n.image <- length(xml_find_all(doc, "//*[@class='articulum trans']/figure"))
journalist <- local({
    a <- xml_text(xml_find_all(doc, "//*[@class='articulum trans']//*[@id='introid']"))
    # [1] content of intro paragraph
    #*[2] journalist name
    unlist(strsplit(a, "攝影╱"))[2]
})
meta.info <- data.frame(aid=aid, n.word=n.word, n.image=n.image, journalist=journalist)
