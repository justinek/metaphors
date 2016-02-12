source("summarySE.R")
d <- read.csv("data49-long.csv")
d$qud <- ifelse(d$condition==1 | d$condition==2, 0, 1)
d$metaphor <- ifelse(d$condition==1 | d$condition==3, 0, 1)
##########################
# turn into long form with feature nums
##########################
d.f1.summary <- summarySE(d, measurevar="f1prob", groupvars=c("categoryID", "animal", "qud", "metaphor"))
d.f2.summary <- summarySE(d, measurevar="f2prob", groupvars=c("categoryID", "animal", "qud", "metaphor"))
d.f3.summary <- summarySE(d, measurevar="f3prob", groupvars=c("categoryID", "animal", "qud", "metaphor"))
colnames(d.f1.summary)[6] <- "featureProb"
colnames(d.f2.summary)[6] <- "featureProb"
colnames(d.f3.summary)[6] <- "featureProb"
d.f1.summary$featureNum <- 1
d.f2.summary$featureNum <- 2
d.f3.summary$featureNum <- 3
d.summary <- rbind(d.f1.summary, d.f2.summary, d.f3.summary)
d.summary$featureNum <- factor(d.summary$featureNum)
d.summary$metaphor <- factor(d.summary$metaphor)
d.summary$qud <- factor(d.summary$qud)

######################
# Metaphor only
#####################
d.met.summary <- subset(d.summary, metaphor=="1")
d.met.summary$featureNum <- factor(d.met.summary$featureNum)
d.met.summary$qud <- factor(d.met.summary$qud)

############################
# Fit model
############################
# Get all the names of the model files to fit
filenames <- read.csv("../../Model/Alternatives/combinedOutputFilenames.txt", header=FALSE)
#filenames <- read.csv("../../Model/CogSciModel/testOutputFilenames.txt", header=FALSE)
max.cor <- 0
max.name <- ""
for (n in filenames$V1) {
  if (grepl("g", n)) {
    name.qud <- n
    name.noQud <- paste("noQud-a", as.list(strsplit(n, "a"))[[1]][2], sep="")
    m.qud <- read.csv(paste("../../Model/Alternatives/CombinedOutput/", name.qud, sep=""), header=FALSE)
    m.noQud <- read.csv(paste("../../Model/Alternatives/CombinedOutput/",name.noQud, sep=""), header=FALSE)
    m.qud$qud <- "1"
    m.noQud$qud <- "0"
    m <- rbind(m.qud, m.noQud)
    colnames(m) <- c("category", "f1", "f2", "f3", "modelProb", "categoryID", "qud")
    # compute marginals
    m.f1 <- aggregate(data=subset(m, f1==1), modelProb ~ categoryID + qud, FUN=sum)
    m.f1$featureNum <- "1"
    m.f2 <- aggregate(data=subset(m, f2==1), modelProb ~ categoryID + qud, FUN=sum)
    m.f2$featureNum <- "2"
    m.f3 <- aggregate(data=subset(m, f3==1), modelProb ~ categoryID + qud, FUN=sum)
    m.f3$featureNum <- "3"
    m.marginals <- rbind(m.f1, m.f2, m.f3)
    compare <- join(d.met.summary, m.marginals, by=c("categoryID", "featureNum", "qud"))
    cor <- with(compare, cor(featureProb, modelProb))
    if (cor > max.cor) {
      max.cor <- cor
      max.name <- name.qud
      best <- compare
      best.model <- m
    }
  }
}
with(best, cor.test(featureProb, modelProb))
with(subset(best, featureNum=="1"), cor.test(featureProb, modelProb))
with(subset(best, featureNum=="2"), cor.test(featureProb, modelProb))
with(subset(best, featureNum=="3"), cor.test(featureProb, modelProb))

my.colors <- c("#990033", "#CC9999", "#FFFFFF")
ggplot(best, aes(x=modelProb, y=featureProb, shape=qud, fill=featureNum)) +
  geom_point(size=4) +
  #geom_text(aes(label=animal)) +
  #geom_errorbar(aes(ymin=featureProb-se, ymax=featureProb+se), width=0.01, color="grey") +
  scale_shape_manual(values=c(21, 24), name="Goal", labels=c("Vague", "Specific")) +
  theme_bw() +
  scale_fill_manual(values=my.colors, name="Feature", labels=c("f1", "f2", "f3"), 
                    guide=guide_legend(override.aes=aes(shape=21))) +
  xlab("Model") +
  ylab("Human")

###########################
# Test individual parameters
###########################

m.qud <- read.csv("../../Model/Alternatives/CombinedOutput/g0.6-a3.0.csv", header=FALSE)
m.noQud <- read.csv("../../Model/Alternatives/CombinedOutput/g0.6-a3.0.csv", header=FALSE)
m.qud$qud <- "1"
m.noQud$qud <- "0"
m <- rbind(m.qud, m.noQud)
colnames(m) <- c("category", "f1", "f2", "f3", "modelProb", "categoryID", "qud")
# compute marginals
m.f1 <- aggregate(data=subset(m, f1==1), modelProb ~ categoryID + qud, FUN=sum)
m.f1$featureNum <- "1"
m.f2 <- aggregate(data=subset(m, f2==1), modelProb ~ categoryID + qud, FUN=sum)
m.f2$featureNum <- "2"
m.f3 <- aggregate(data=subset(m, f3==1), modelProb ~ categoryID + qud, FUN=sum)
m.f3$featureNum <- "3"
m.marginals <- rbind(m.f1, m.f2, m.f3)
compare <- join(d.met.summary, m.marginals, by=c("categoryID", "featureNum", "qud"))
cor <- with(compare, cor(featureProb, modelProb))

ggplot(compare, aes(x=modelProb, y=featureProb, shape=qud, fill=featureNum)) +
  geom_point(size=3) +
  geom_text(aes(label=animal)) +
  #geom_errorbar(aes(ymin=featureProb-se, ymax=featureProb+se), width=0.01, color="grey") +
  scale_shape_manual(values=c(21, 24), name="Goal", labels=c("Vague", "Specific")) +
  theme_bw() +
  scale_fill_manual(values=my.colors, name="Feature", labels=c("f1", "f2", "f3"), 
                    guide=guide_legend(override.aes=aes(shape=21))) +
  xlab("Model") +
  ylab("Human")
