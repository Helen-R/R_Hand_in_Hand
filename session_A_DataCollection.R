# Demo code in slides
library(xml2)
library(xmlview)


##############
##   A-01   ##
##############
## save the page----
url <- "http://www.appledaily.com.tw/appledaily/article/headline/20160704/37293645"
download.file(url, "data/test.html")

## parse information----
### set your target url
url   <- "http://search.appledaily.com.tw/charity/projlist/Page"
doc   <- read_html(url)
### Set the xpath of info needed
xpath <- "//*[@id='inquiry3']/table//tr[4]/td[1]"
xml_text(xml_find_all(doc, xpath))



######################
##   A-01 exercise  ##
######################
## parse information
### complete the exercise!
file.edit("session_A_ex01.R")



##############
## optional ##
##############
## try auxiliary tool xmlview
### open the document to test your xpath (optional)----
# xml_view(doc, add_filter = T)



##############
##   A-02   ##
##############
## transform web content to data frame----
### 1 combine vectors to data frame
df <- data.frame(aid=a1.1, url=unlist(a1.3))
View(df)
### 2 extract long vectors and put it into a matrix
xpath <- "//*[@id='inquiry3']/table/tr/td"
x3 <- xml_text(xml_find_all(doc, xpath))
View(matrix(x3, ncol=6, byrow=T))



######################
##   A-02 exercise  ##
######################
## transform web content to data frame
### complete the exercise!
file.edit("session_A_ex02.R")



######################
##   A-03 exercise  ##
######################
## plan and collect actual data!!
### complete the exercise!
file.edit("session_A_ex03.R")
