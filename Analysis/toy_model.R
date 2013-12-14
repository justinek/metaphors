d1 <- read.csv("../Model/Output/lion-1feature.csv", header=FALSE)
colnames(d1) <- c("category", "feature1", "prob")

ggplot(d1, aes(x=category, y=prob, fill=feature1)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  theme_bw() +
  scale_fill_brewer(palette="Accent")

d2 <- read.csv("../Model/Output/lion-2feature.csv", header=FALSE)
colnames(d2) <- c("category", "feature1", "feature2", "prob")

feature2 <- aggregate(data=d2, prob ~ category + feature2, FUN=sum)

ggplot(d2, aes(x=category, y=prob, fill=feature2)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  theme_bw() +
  facet_grid(.~feature1) +
  scale_fill_manual(values=c("gray", "white"))

d3 <- read.csv("../Model/Output/lion-2feature.csv", header=FALSE)
colnames(d3) <- c("category", "feature1", "feature2", "prob")
d3$features <- paste(d3$feature1, d3$feature2)

ggplot(d3, aes(x=category, y=prob, fill=features)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  theme_bw() +
  scale_fill_brewer(palette="Accent")
