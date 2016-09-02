#######################
##   C-02  exercise  ##
#######################
## vectorization of words
### if C-01 exercise is skipped, please execute the following line.
source("answer/session_C_sol01_separate_words.R")

## vectorization of words
cat("\n Construct term co-occurrence matrix (tcm) ...\n")
# create an iterator first
a.token <- itoken(a)

# create the vectorizer and set the size of skip_grams_window 

a.vectorizer <- # Please complete this!

# construct term co-occurrence matrix according to a.token and a.vectorizer

a.tcm <- # Please complete this!


cat("\n Fit a glove model ...\n")
# set up parameters for glove fitting model
# word_vectors_size equal to d in our notation
# x_max equal to xmax
# learning_rate: parameters of AdaGrad, the training method used by glove
# num_iters: number of iterations to fit the glove model

fit <- # Please complete this!

cat("\n Obtain the word vectors! \n")
# add word vector and context vector

word.vec <- # Please complete this!

rownames(word.vec) = rownames(a.tcm)
Encoding(rownames(word.vec)) = 'UTF-8'
