library(plyr)
f <- read.csv("long-full-120.csv")
top_n <- 10
tally <- data.frame(feature=NULL, altAnimal=NULL, freq=NULL)
for (a in levels(f$feature)) {
  f.feature <- subset(f, feature==a)
  f.count <- count(f.feature, vars="altAnimal")
  f.count <- f.count[with(f.count, order(-freq)),]
  f.top <- head(f.count, n=top_n)
  f.top$feature <- a
  tally <- rbind(tally, f.top)
}

tally <- tally[with(tally, order(feature)), ]
write.csv(tally, "top10-full.csv", row.names=FALSE)