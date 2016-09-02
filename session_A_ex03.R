######################
##   A-03 exercise  ##
######################
library(xml2)

## 1 read article list
source("solution/session_A_sol02.R",encoding="UTF-8")
# choose the target case in our article list
i <- ""

## 2 crawl donation record
# get aid from article list
aid <- article.list$aid[i]
# get the url of the donation detail of that case
url.detail <- article.list$url.detail[i]
doc <- read_html(url.detail)
# get all info from the table
# columns:
# 1 aid
# 2 donor.name
# 3 donation
# 4 date.donate
donate <- local({
    # write down your code for parsing the web pages
    # using xpath and xml2 package metioned in class
    
    # according to your observation, complete an Xpath to get the donation list
    xpath <- ""
    
    # use xml_find_one or xml_find_all to get the target nodes
    
    
    # use xml_text or xml_attrs to get the content for your data frame
    
    
    # transform your data into a data frame
    donate <- data.frame()
    
    # assign the specific colnames
    colnames(donate) <- c("aid", "donor.name", "donation", "date.donate")
    
    return(donate)
})

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
# get all info from articles
# 1 title
# 2 article content
# 3 meta info
article <- local({
    # write down your code for parsing the web pages
    # using xpath and xml2 package metioned in class
    
    # according to your observation, complete an Xpath to get the article title and content
    xpath.title <- ""
    xpath.content <- ""
    
    # use xml_find_one or xml_find_all to get the target nodes
    # use xml_text to get the content
    
    return(article)
})


# create a directory to store the data
out.dir <- "data/db_articles_txt"
if(!dir.exists(out.dir)) dir.create(out.dir)
# output file name
out.fnm <- sprintf("%s/%s.txt", out.dir, aid)
# save articles to txt file
writeLines(article, out.fnm)

# get other meta info
# 1 n.word: number of words
# 2 n.image: number of images
# 3 jounalist

# try nchar() for counting the words in the article
n.word <- "" 

# set the xpath for getting the photoes in the article
xpath.image <- ""
# use xml_find_one or xml_find_all to get the target nodes
image <- xml_find_all(doc, xpath.image)
# get how many images that are contained in the article
n.image <- length(image)

journalist <- local({
    # set the xpath for getting the paragraph containing the journalist
    xpath.jrnl <- ""
    # use xml_find_one or xml_find_all to get the target nodes
    
    
    # use xml_text to get the content 
    
    
    # and do some string manipulation to get the journalist name

    
    
})
meta.info <- data.frame(aid=aid, n.word=n.word, n.image=n.image, journalist=journalist)
