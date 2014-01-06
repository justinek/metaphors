source("summarySE.R")
d <- read.csv("data39-long.csv")

# examples
this.animal <- "owl"
d.example <- subset(d, animal==this.animal)

this.f1 <- as.vector(d.example$f1)[1]
this.f2 <- as.vector(d.example$f2)[1]
this.f3 <- as.vector(d.example$f3)[1]

d.example$qud <- ifelse(d.example$condition==1 | d.example$condition==2, 0, 1)
d.example$metaphor <- ifelse(d.example$condition==1 | d.example$condition==3, 0, 1)
d.example$condition <- factor(d.example$condition, labels=c(paste("'What is he like?'\n'He is", this.f1,".'"),
                                            paste("'What is he like?'\n'He is a", this.animal, ".'"),
                                            paste("'Is he", this.f1, "?'\n'Yes.'"),
                                            paste("'Is he", this.f1, "?'\n'He is a", this.animal, ".'")))


d.example.f1 <- summarySE(d.example, measurevar="f1prob", groupvars=c("condition", "f1", "f2", "f3", "qud", "metaphor"))
colnames(d.example.f1)[8] <- "featureProb"
d.example.f1$feature <- this.f1
d.example.f2 <- summarySE(d.example, measurevar="f2prob", groupvars=c("condition", "f1", "f2", "f3", "qud", "metaphor"))
colnames(d.example.f2)[8] <- "featureProb"
d.example.f2$feature <- this.f2
d.example.f3 <- summarySE(d.example, measurevar="f3prob", groupvars=c("condition", "f1", "f2", "f3", "qud", "metaphor"))
colnames(d.example.f3)[8] <- "featureProb"
d.example.f3$feature <- this.f3

d.example.combine <- rbind(d.example.f1, d.example.f2, d.example.f3)
d.example.combine$feature <- factor(d.example.combine$feature, levels=c(this.f1, this.f2, this.f3))
ggplot(d.example.combine, aes(x=feature, y=featureProb, fill=feature)) +
  geom_bar(stat="identity", color="black") +
  geom_errorbar(aes(ymin=featureProb-se, ymax=featureProb+se), width=0.2) +
  facet_grid(.~condition) +
  theme_bw() +
  scale_fill_brewer(palette="Accent", guide=FALSE) +
  ylim(c(0,1))

# only plot metaphor conditions
d.example.metaphor <- subset(d.example.combine, metaphor==1)

ggplot(d.example.metaphor, aes(x=feature, y=featureProb, fill=feature)) +
  geom_bar(stat="identity", color="black") +
  geom_errorbar(aes(ymin=featureProb-se, ymax=featureProb+se), width=0.2) +
  facet_grid(.~condition) +
  theme_bw() +
  scale_fill_brewer(palette="Accent", guide=FALSE) +
  ylim(c(0,1))

## model
# no qud
filename.noqud <- paste("../../Model/Output/", this.animal, ".csv", sep="")
m.noqud <- read.csv(filename.noqud)
colnames(m.noqud) <- c("category", "feature1", "feature2", "feature3", "prob")
m.noqud.human <- subset(m.noqud, category=="person")
m.noqud.human$featureProb <- m.noqud.human$prob / sum(m.noqud.human$prob)
m.noqud.human.f1 <- aggregate(data=subset(m.noqud.human, feature1==1), 
                              featureProb ~ category, FUN=sum)
m.noqud.human.f1$feature <- this.f1
m.noqud.human.f2 <- aggregate(data=subset(m.noqud.human, feature2==1), 
                              featureProb ~ category, FUN=sum)
m.noqud.human.f2$feature <- this.f2
m.noqud.human.f3 <- aggregate(data=subset(m.noqud.human, feature3==1), 
                              featureProb ~ category, FUN=sum)
m.noqud.human.f3$feature <- this.f3
m.noqud.combine <- rbind(m.noqud.human.f1, m.noqud.human.f2, m.noqud.human.f3)
m.noqud.combine$condition <- paste("'What is he like?'\n'He is a", this.animal, ".'")

# with qud
filename.qud <- paste("../../Model/Output/", this.animal, "-qud.csv", sep="")
m.qud <- read.csv(filename.qud)
colnames(m.qud) <- c("category", "feature1", "feature2", "feature3", "prob")
m.qud.human <- subset(m.qud, category=="person")
m.qud.human$featureProb <- m.qud.human$prob / sum(m.qud.human$prob)
m.qud.human.f1 <- aggregate(data=subset(m.qud.human, feature1==1), 
                              featureProb ~ category, FUN=sum)
m.qud.human.f1$feature <- this.f1
m.qud.human.f2 <- aggregate(data=subset(m.qud.human, feature2==1), 
                              featureProb ~ category, FUN=sum)
m.qud.human.f2$feature <- this.f2
m.qud.human.f3 <- aggregate(data=subset(m.qud.human, feature3==1), 
                              featureProb ~ category, FUN=sum)
m.qud.human.f3$feature <- this.f3
m.qud.combine <- rbind(m.qud.human.f1, m.qud.human.f2, m.qud.human.f3)
m.qud.combine$condition <- paste("'Is he", this.f1, "?'\n'He is a", this.animal, ".'")

# combine qud + noqud
m.combine <- rbind(m.noqud.combine, m.qud.combine)
m.combine$feature <- factor(m.combine$feature, levels=c(this.f1, this.f2, this.f3))
m.combine$condition <- factor(m.combine$condition, levels=c(paste("'What is he like?'\n'He is a", this.animal, ".'"),
                                                            paste("'Is he", this.f1, "?'\n'He is a", this.animal, ".'")))
ggplot(m.combine, aes(x=feature, y=featureProb, fill=feature)) +
  geom_bar(stat="identity", color="black") +
  #geom_errorbar(aes(ymin=featureProb-se, ymax=featureProb+se), width=0.2) +
  facet_grid(.~condition) +
  theme_bw() +
  scale_fill_brewer(palette="Accent", guide=FALSE) +
  ylim(c(0,1))




