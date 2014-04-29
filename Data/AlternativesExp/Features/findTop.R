library(plyr)
f <- read.csv("long-50.csv")
top_n <- 10
tally <- data.frame(categoryID=NULL, origAnimal=NULL, feature=NULL, featureNum=NULL, altAnimal=NULL, freq=NULL)
for (a in levels(f$feature)) {
  f.feature <- subset(f, feature==a)
  f.count <- count(f.feature, vars="altAnimal")
  f.count <- f.count[with(f.count, order(-freq)),]
  f.top <- head(f.count, n=top_n)
  f.top$feature <- a
  f.top$categoryID <- f.feature$categoryID[1]
  f.top$origAnimal <- f.feature$origAnimal[1]
  f.top$featureNum <- f.feature$featureNum[1]
  tally <- rbind(tally, f.top)
}

tally <- tally[with(tally, order(categoryID, featureNum)), ]
write.csv(tally, "top10.csv", row.names=FALSE)