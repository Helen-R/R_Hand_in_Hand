###############################
##   A-01 exercise solution  ##
###############################
library(xml2)
### set your target url
url   <- "http://search.appledaily.com.tw/charity/projlist/Page"
doc   <- read_html(url)

### 1-1 article codes
# complete xpath1 to extract article codes
xpath1 <- "//*[@id='inquiry3']/table//tr/td[1]"
a1.1 <- xml_text(xml_find_all(doc, xpath1))
a1.1

### 1-2 column names
# complete xpath2 to extract column names
xpath2 <- "//*[@id='inquiry3']//tr[2]/th"
a1.2 <- xml_text(xml_find_all(doc, xpath2))
a1.2

### 1-3 article links
# complete (1) xpath3 and (2) attr3 to extract article link
xpath3 <- "//*[@id='inquiry3']//tr/td[6]/a"
attr3 <- "href"
a1.3 <- xml_attr(xml_find_all(doc, xpath3), attr3)
a1.3

### bonus: total pages
# complete xpath.bonus to get the node containing the number of total pages 
xpath.bonus <- "//*[@id='charity_day']"
totalpage <- xml_text(xml_find_all(doc, xpath.bonus))
# need some string processing to get the number of total page
n.page <- unlist(strsplit(totalpage, " "))[4]
