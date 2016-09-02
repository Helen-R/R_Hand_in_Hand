source("answer/session_C_sol01_separate_words.R")

#######################
##   C-02  solution  ##
#######################
## vectorization of words
cat("\n Contruct term co-occurrence matrix (tcm) ...\n")

# create an iterator first
a.token <- itoken(a)

# create the vectorizer and set the size of skip_grams_window 

a.vectorizer <- vocab_vectorizer(a.vocab,grow_dtm=FALSE,skip_grams_window=5)# Please complete this!

# construct term co-occurrence matrix according to a.token and a.vectorizer

a.tcm <- create_tcm(a.token,a.vectorizer)# Please complete this!


cat("\n Fit a glove model ...\n")
# set up parameters for glove fitting model
# word_vectors_size equal to d in our notation
# x_max equal to xmax
# learning_rate: parameters of AdaGrad, the training method used by glove
# num_iters: number of iterations to fit the glove model

fit <- glove(a.tcm, word_vectors_size = 100, x_max = 10, learning_rate = 0.2, num_iters = 15)# Please complete this!

cat("\n Obtain the word vectors! \n")
# add word vector and context vector

word.vec <- fit$word_vectors$w_i + fit$word_vectors$w_j # Please complete this!

rownames(word.vec) = rownames(a.tcm)
Encoding(rownames(word.vec)) = 'UTF-8'
