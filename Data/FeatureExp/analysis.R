library(plyr)
f <- read.csv("long.csv")
top_n <- 10
tally <- data.frame(categoryID=NULL, animal=NULL, adjective=NULL, freq=NULL)
for (a in levels(f$animal)) {
  f.animal <- subset(f, animal==a)
  f.count <- count(f.animal, vars="adjective")
  f.count <- f.count[with(f.count, order(-freq)),]
  f.top <- head(f.count, n=top_n)
  f.top$animal <- a
  f.top$categoryID <- f.animal$categoryID[1]
  tally <- rbind(tally, f.top)
}

write.csv(tally, "top10.csv", row.names=FALSE)