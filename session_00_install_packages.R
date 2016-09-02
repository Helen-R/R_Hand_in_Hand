# packages for lecture hand-in-hand R
pkgs <- c("devtools", "xml2", "plyr", "dplyr", "data.table", "text2vec", 
          "jiebaR", "fmsb", "e1071", "rpart","randomForest")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
if(length(pkgs)) install.packages(pkgs)

devtools::install_github("hrbrmstr/xmlview", force = T)
library(xmlview)
