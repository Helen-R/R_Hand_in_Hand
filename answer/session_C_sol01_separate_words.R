#######################
##   C-01  solution  ##
#######################
# seperate words
cat("Reading files in data/db_articles_txt/") # show message
# find the articles in our db
files <- list.files('../data/db_articles_txt/', pattern = '.txt', full.names = T)
# clean the filename without its extension
file.name <- gsub('.txt', '' ,basename(files))
# read the first 1000 articles
file.len <- 1000
article_txt = list()
for(i in 1:file.len){
  # read files by lines
  a <- readLines(files[i], encoding = 'UTF-8')
  # append each line and save into variable aritcle_txt
  article_txt[[file.name[[i]]]] = paste0(a, collapse = '')
  cat(file.name[[i]]," ")
}
# to check if all are correctly loaded in
fivenum(nchar(article_txt))

cat(paste0("\n Using jiebaR to segment each article ...\n")) # show message
library(jiebaR)
# initiate segmentation engine, called cutter

cutter <- worker(bylines=T) # please complete this!

# segment each article
article_words <- sapply(article_txt,function(x) {
						 cutter <= x # please complete this!
						})

cat(paste0("\nUsing text2vec to create vocabulary ...\n")) # show message
# construct a vocabulary according to the above article words
library(text2vec)
a = article_words
# create an iterator for accessing tokens in each article
a.token <- itoken(a)

# create vocabulary according to the tokens of all article

a.vocab <- create_vocabulary(a.token,ngram=c(1,1)) # please complete this!

# enforce the encoding of terms to be 'UTF-8'
Encoding(a.vocab$vocab$terms) = 'UTF-8'
cat("\n",paste0("The vocabulary size, |V| = ",length(a.vocab$vocab$terms)),"\n") # show message
