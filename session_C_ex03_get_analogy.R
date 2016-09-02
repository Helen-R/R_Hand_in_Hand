#######################
##   C-03  exercise  ##
#######################
# if C-02 exercise is skipped, please execute the following line.
source("answer/session_C_02_create_glove.R")

get_analogy = function(king, man, woman) {
  # establish an analogy logic, vec(queen) = vec(king) - vec(man) + vec(woman)
  # HINT: "word.vec" is the variable of word vectors from session_C_02_create_glove.R
  
  queen = # please complete this!

  # calculte the cosine-similarity among vec(queen) and other word vectors
  # HINT: use text2vec:::cosine function to achieve

  cos.dist = # please complete this!

  # Show the top-10 words for this analogy task
  head(sort(cos.dist[1,], decreasing = T), 10)
}

# try the following analogy task
get_analogy("女兒","爸爸","媽媽")
get_analogy("房子","孝順","不孝")
get_analogy("肝癌","爸爸","媽媽")
