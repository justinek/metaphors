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

d.prior <- read.csv("../Model/Output/animal-test-prior.csv", header=FALSE)
colnames(d.prior) <- c("category", "feature1", "feature2", "feature3", "prob")
d.prior$feature1 <- factor(d.prior$feature1, labels=c("small", "big"))
d.prior$feature2 <- factor(d.prior$feature2, labels=c("weak", "strong"))
d.prior$feature3 <- factor(d.prior$feature3, labels=c("tame", "wild"))
d.prior$features <- paste(d.prior$feature1, d.prior$feature2, d.prior$feature3, sep="\n")

d.prior.person <- subset(d.prior, category=="person")
d.prior.animal <- subset(d.prior, category=="animal")

ggplot(d.prior.person, aes(x=features, y=prob, fill=feature1)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  theme_bw() +
  scale_fill_brewer(palette="Accent") +
  xlab("")

d4 <- read.csv("../Model/Output/animal-test.csv", header=FALSE)
colnames(d4) <- c("category", "feature1", "feature2", "feature3", "prob")
d4$feature1 <- factor(d4$feature1, labels=c("small", "big"))
d4$feature2 <- factor(d4$feature2, labels=c("weak", "strong"))
d4$feature3 <- factor(d4$feature3, labels=c("tame", "wild"))
d4$features <- paste(d4$feature1, d4$feature2, d4$feature3, sep="\n")

d4.person <- subset(d4, category=="person")
d4.animal <- subset(d4, category=="animal")

ggplot(d4.person, aes(x=features, y=prob, fill=feature1)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  theme_bw() +
  scale_fill_brewer(palette="Accent") +
  xlab("")

d5 <- read.csv("../Model/Output/animal-test-qud.csv", header=FALSE)
colnames(d5) <- c("category", "feature1", "feature2", "feature3", "prob")
d5$feature1 <- factor(d5$feature1, labels=c("small", "big"))
d5$feature2 <- factor(d5$feature2, labels=c("weak", "strong"))
d5$feature3 <- factor(d5$feature3, labels=c("tame", "wild"))
d5$features <- paste(d4$feature1, d5$feature2, d5$feature3, sep="\n")

d5.person <- subset(d5, category=="person")
d5.animal <- subset(d5, category=="animal")

ggplot(d5.person, aes(x=features, y=prob, fill=feature1)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  theme_bw() +
  scale_fill_brewer(palette="Accent") +
  xlab("")

## combine prior, metaphor, and qud+metaphor

d.prior.person$type <- "prior"
d4.person$type <- "'What is he like?'\n'He is a buffalo.'"
d5.person$type <- "'Is he big?'\n'He is a buffalo.'"


d.prior.animal$type <- "prior"
d4.animal$type <- "'What is he like?'\n'He is a buffalo.'"
d5.animal$type <- "'Is he big?'\n'He is a buffalo.'"

d.comp.person <- rbind(d.prior.person, d4.person, d5.person)
d.comp.person$type <- factor(d.comp.person$type, levels=c("prior", "'What is he like?'\n'He is a buffalo.'", "'Is he big?'\n'He is a buffalo.'"))

ggplot(d.comp.person, aes(x=features, y=prob, fill=feature1)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  theme_bw() +
  facet_grid(.~type) +
  scale_fill_brewer(palette="Accent") +
  xlab("")

d.comp.animal <- rbind(d.prior.animal, d4.animal, d5.animal)
d.comp.animal$type <- factor(d.comp.animal$type, levels=c("prior", "'What is he like?'\n'He is a buffalo.'", "'Is he big?'\n'He is a buffalo.'"))

ggplot(d.comp.animal, aes(x=features, y=prob, fill=feature1)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  theme_bw() +
  facet_grid(.~type) +
  scale_fill_brewer(palette="Accent") +
  xlab("")