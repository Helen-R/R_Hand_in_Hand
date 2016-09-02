#############
##   C-01  ##
#############
# seperate words----
# find the articles in our db
files <- list.files('data/db_articles_txt/', pattern = '.txt', full.names = T)
file.name <- gsub('.txt', '' ,basename(files))

# read the first 100 articles
if(!exists("file.len")) file.len = 100
article_txt = list()
for(i in 1:file.len){
  a <- readLines(files[i], encoding = 'UTF-8')
  article_txt[[file.name[[i]]]] = paste0(a, collapse = '')
}
fivenum(nchar(article_txt))
# show length of list
length(article_txt)

library(jiebaR)
# initiate segmentation engine, called cutter
cutter <- worker(bylines = T)
# normal way
article_words <- sapply(article_txt,function(x) segment(x,cutter))
# cooler way
article_words <- sapply(article_txt, function(x) cutter <= x)
# show one
article_words[[1]]

library(text2vec)
# construct a vocabulary according to the above article words
a = article_words
# create an iterator for accessing tokens in each article
a.token <- itoken(a)
# create vocabulary according to the tokens of all article
a.vocab <- create_vocabulary(a.token, ngram=c(1, 1))
# enforce the encoding of terms to be 'UTF-8'
Encoding(a.vocab$vocab$terms) = 'UTF-8'
cat("\n",paste0("The vocabulary size, |V| = ",length(a.vocab$vocab$terms)),"\n") # show message
# show
head(a.vocab$vocab[order(-a.vocab$vocab$terms_counts)][120:150],10)
nrow(a.vocab$vocab)




######################
##   C-01 exercise  ##
######################
## seperate words
### complete the exercise!
file.edit("session_C_ex01_separate_words.R")




#############
##   C-02  ##
#############
## vectorization of words----
### create an iterator first
a.token <- itoken(a)
# create the vectorizer and set the size of skip_grams_window 
a.vectorizer <- vocab_vectorizer(a.vocab, grow_dtm = FALSE, skip_grams_window = 5)
# construct term co-occurrence matrix according to a.token and a.vectorizer
a.tcm <- create_tcm(a.token, a.vectorizer)
# show dimenstion of tcm
a.tcm@Dim[1]
a.tcm@Dim[2]

# set up parameters for glove fitting model
# word_vectors_size equal to d in our notation
# x_max equal to xmax
# learning_rate: parameters of AdaGrad, the training method used by glove
# num_iters: number of iterations to fit the glove model
fit <- glove(a.tcm, word_vectors_size = 100, x_max = 30, learning_rate = 0.2, num_iters = 15)

# add word vector and context vector
word.vec <- fit$word_vectors$w_i + fit$word_vectors$w_j
rownames(word.vec) = rownames(a.tcm)
Encoding(rownames(word.vec)) = 'UTF-8'





######################
##   C-02 exercise  ##
######################
## vectorization of words
### complete the exercise!
file.edit("session_C_ex02_create_glove.R")




#############
##   C-03  ##
#############
## word vector application
### calculate the unit vector
word.vec.norm <- sqrt(rowSums(word.vec ^ 2))

### write word analogy funciton
get_analogy = function(king, man, woman) {
  # HINT: establish an analogy logic, vec(queen) = vec(king) - vec(man) + woman
  queen = word.vec[king, , drop = F] - word.vec[man, , drop = F] + word.vec[woman, , drop = F]
  # HINT: calculte the cosine-similarity among vec(queen) and other word vectors
  cos.dist = text2vec:::cosine(queen,
                               word.vec,
                               word.vec.norm)
  # please show the top-10 words for this analogy task
  head(sort(cos.dist[1,], decreasing = T), 10)
}

### try the following analogy task
get_analogy("女兒","爸爸","媽媽")
get_analogy("房子","孝順","不孝")
get_analogy("肝癌","爸爸","媽媽")




######################
##   C-03 exercise  ##
######################
## word vector application
### complete the exercise!
file.edit("session_C_ex03_get_analogy.R")
