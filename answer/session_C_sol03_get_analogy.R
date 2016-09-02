source("answer/session_C_sol02_create_glove.R")

#######################
##   C-03  solution  ##
#######################
## word vector application


# calculate the unit vector
word.vec.norm = sqrt(rowSums(word.vec ^ 2))


get_analogy = function(king, man, woman) {
  # establish an analogy logic, vec(queen) = vec(king) - vec(man) + vec(woman)
  # HINT: "word.vec" is the variable of word vectors from session_C_02_create_glove.R
  
  queen = word.vec[king, , drop=F] - word.vec[man, ,drop=F] + word.vec[woman, , drop=F] # please complete this!

  # calculte the cosine-similarity among vec(queen) and other word vectors
  # HINT: use text2vec:::cosine function to achieve

  cos.dist = text2vec:::cosine(queen,word.vec,word.vec.norm) # please complete this!

  # Show the top-10 words for this analogy task
  head(sort(cos.dist[1,], decreasing = T), 10)
}

# try the following analogy task
get_analogy("女兒","爸爸","媽媽")
get_analogy("房子","孝順","不孝")
get_analogy("肝癌","爸爸","媽媽")
