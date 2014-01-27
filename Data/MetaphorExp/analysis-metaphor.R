source("summarySE.R")
d <- read.csv("data49-long.csv")

#### examples
this.categoryID = 4
d.example <- subset(d, categoryID==this.categoryID)

this.animal <- as.vector(d.example$animal)[1]
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
#ggplot(d.example.combine, aes(x=feature, y=featureProb, fill=feature)) +
#  geom_bar(stat="identity", color="black") +
#  geom_errorbar(aes(ymin=featureProb-se, ymax=featureProb+se), width=0.2) +
#  facet_grid(.~condition) +
#  theme_bw() +
#  scale_fill_brewer(palette="Accent", guide=FALSE) +
#  ylim(c(0,1))

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
filename.noqud <- paste("../../Model/AnimalModelsOutput/noQud_", this.categoryID, ".csv", sep="")
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
filename.qud <- paste("../../Model/AnimalModelsOutput/qud_", this.categoryID, ".csv", sep="")
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


#####
# Aggregate analysis
#####

#### Human
d$qud <- ifelse(d$condition==1 | d$condition==2, 0, 1)
d$metaphor <- ifelse(d$condition==1 | d$condition==3, 0, 1)

## Human split-half analysis
ii <- seq_len(nrow(d)) 
ind1 <- sample(ii, nrow(d) / 2) 
ind2 <- ii[!ii %in% ind1] 
h1 <- d[ind1, ] 
h2 <- d[ind2, ]

h1.f1.summary <- summarySE(h1, measurevar="f1prob", groupvars=c("categoryID", "animal", "qud", "metaphor"))
h1.f2.summary <- summarySE(h1, measurevar="f2prob", groupvars=c("categoryID", "animal", "qud", "metaphor"))
h1.f3.summary <- summarySE(h1, measurevar="f3prob", groupvars=c("categoryID", "animal", "qud", "metaphor"))

colnames(h1.f1.summary)[6] <- "featureProb"
colnames(h1.f2.summary)[6] <- "featureProb"
colnames(h1.f3.summary)[6] <- "featureProb"
h1.f1.summary$featureNum <- 1
h1.f2.summary$featureNum <- 2
h1.f3.summary$featureNum <- 3

h1.summary <- rbind(h1.f1.summary, h1.f2.summary, h1.f3.summary)
colnames(h1.summary)[6] <- "h1prob"

h2.f1.summary <- summarySE(h2, measurevar="f1prob", groupvars=c("categoryID", "animal", "qud", "metaphor"))
h2.f2.summary <- summarySE(h2, measurevar="f2prob", groupvars=c("categoryID", "animal", "qud", "metaphor"))
h2.f3.summary <- summarySE(h2, measurevar="f3prob", groupvars=c("categoryID", "animal", "qud", "metaphor"))

colnames(h2.f1.summary)[6] <- "featureProb"
colnames(h2.f2.summary)[6] <- "featureProb"
colnames(h2.f3.summary)[6] <- "featureProb"
h2.f1.summary$featureNum <- 1
h2.f2.summary$featureNum <- 2
h2.f3.summary$featureNum <- 3

h2.summary <- rbind(h2.f1.summary, h2.f2.summary, h2.f3.summary)
colnames(h2.summary)[6] <- "h2prob"

splithalf.comp <- join(h1.summary, h2.summary, by=c("categoryID", "animal", "qud", "metaphor", "featureNum"))
with(splithalf.comp, cor.test(h1prob, h2prob))
splithalf.met.comp <- subset(splithalf.comp, metaphor=="1")
with(splithalf.met.comp, cor.test(h1prob, h2prob))
with(subset(splithalf.met.comp, featureNum==1), cor.test(h1prob, h2prob))
with(subset(splithalf.met.comp, featureNum==2), cor.test(h1prob, h2prob))
with(subset(splithalf.met.comp, featureNum==3), cor.test(h1prob, h2prob))

# turn into long form with feature nums

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

# visualize properties of the ratings
d.summary.summary <- summarySE(d.summary, measurevar="featureProb", 
                               groupvars=c("qud", "metaphor", "featureNum"))

d.summary.summary$featureLabel <- factor(d.summary.summary$featureNum, labels=c("f1", "f2", "f3"))
ggplot(d.summary.summary, aes(x=metaphor, y=featureProb, fill=qud)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=featureProb-se, ymax=featureProb+se), width=0.2, position=position_dodge(0.9)) +
  facet_grid(.~featureLabel) +
  theme_bw() +
  scale_fill_brewer(palette="Accent") +
  ylim(c(0,1))

## Metaphor only
d.met.summary <- subset(d.summary, metaphor=="1")

#### Model

m.met.summary <- data.frame(category=NULL, featureProb=NULL, featureNum=NULL, categoryID=NULL, qud=NULL)

for (i in 1:32) {
  filename.noqud <- paste("../../Model/AnimalModelsOutput/noQud_", i, ".csv", sep="")
  m.noqud <- read.csv(filename.noqud)
  colnames(m.noqud) <- c("category", "feature1", "feature2", "feature3", "prob")
  m.noqud.human <- subset(m.noqud, category=="person")
  m.noqud.human$featureProb <- m.noqud.human$prob / sum(m.noqud.human$prob)
  m.noqud.human.f1 <- aggregate(data=subset(m.noqud.human, feature1==1), 
                                featureProb ~ category, FUN=sum)
  m.noqud.human.f1$featureNum <- 1
  m.noqud.human.f2 <- aggregate(data=subset(m.noqud.human, feature2==1), 
                                featureProb ~ category, FUN=sum)
  m.noqud.human.f2$featureNum <- 2
  m.noqud.human.f3 <- aggregate(data=subset(m.noqud.human, feature3==1), 
                                featureProb ~ category, FUN=sum)
  m.noqud.human.f3$featureNum <- 3
  m.noqud.combine <- rbind(m.noqud.human.f1, m.noqud.human.f2, m.noqud.human.f3)
  m.noqud.combine$categoryID = i
  m.noqud.combine$qud = 0
  
  # with qud
  filename.qud <- paste("../../Model/AnimalModelsOutput/qud_", i, ".csv", sep="")
  m.qud <- read.csv(filename.qud)
  colnames(m.qud) <- c("category", "feature1", "feature2", "feature3", "prob")
  m.qud.human <- subset(m.qud, category=="person")
  m.qud.human$featureProb <- m.qud.human$prob / sum(m.qud.human$prob)
  m.qud.human.f1 <- aggregate(data=subset(m.qud.human, feature1==1), 
                              featureProb ~ category, FUN=sum)
  m.qud.human.f1$featureNum <- 1
  m.qud.human.f2 <- aggregate(data=subset(m.qud.human, feature2==1), 
                              featureProb ~ category, FUN=sum)
  m.qud.human.f2$featureNum <- 2
  m.qud.human.f3 <- aggregate(data=subset(m.qud.human, feature3==1), 
                              featureProb ~ category, FUN=sum)
  m.qud.human.f3$featureNum <- 3
  m.qud.combine <- rbind(m.qud.human.f1, m.qud.human.f2, m.qud.human.f3)
  m.qud.combine$categoryID = i
  m.qud.combine$qud <- 1
  
  # combine qud + noqud
  m.combine <- rbind(m.noqud.combine, m.qud.combine)
  m.met.summary <- rbind(m.met.summary, m.combine)
}

colnames(m.met.summary)[2] <- "modelProb"

d.m.met.compare <- join(d.met.summary, m.met.summary, by=c("categoryID", "featureNum", "qud"))
d.m.met.compare$featureNum <- factor(d.m.met.compare$featureNum)
d.m.met.compare$qud <- factor(d.m.met.compare$qud)
with(d.m.met.compare, cor.test(featureProb, modelProb))

ggplot(d.m.met.compare, aes(x=modelProb, y=featureProb, shape=qud, color=featureNum)) +
  geom_point(size=2) +
  geom_text(aes(label=animal)) +
  scale_shape_manual(values=c(0, 19)) +
  theme_bw()

#### Correlate with feature priors

priors <- read.csv("../FeaturePriorExp/featurePriors.csv")
priors.animal <- subset(priors, category=="animal")
priors.person <- subset(priors, category=="person")

colnames(priors.animal)[7] <- "animalPrior"
colnames(priors.person)[7] <- "personPrior"
d.m.met.compare <- join(d.m.met.compare, priors.animal, by=c("categoryID", "animal", "featureNum"))
d.m.met.compare <- join(d.m.met.compare, priors.person, by=c("categoryID", "animal", "featureNum"))

d.m.met.compare$labels <- paste(d.m.met.compare$animal, d.m.met.compare$feature, sep=";")
ggplot(d.m.met.compare, aes(x=modelProb, y=featureProb, shape=qud, color=featureNum)) +
  geom_point(size=2) +
  geom_text(aes(label=labels)) +
  scale_shape_manual(values=c(0, 19)) +
  theme_bw()


# Correlate with just feature priors
with(d.m.met.compare, cor.test(featureProb, animalPrior))
with(d.m.met.compare, cor.test(featureProb, personPrior))

d.m.met.f1.compare <- subset(d.m.met.compare, featureNum=="1")
# correlate with model
with(d.m.met.f1.compare, cor.test(featureProb, modelProb))
# correlate with just animal
with(d.m.met.f1.compare, cor.test(featureProb, animalPrior))
# correlate with just person
with(d.m.met.f1.compare, cor.test(featureProb, personPrior))

ggplot(d.m.met.f1.compare, aes(x=modelProb, y=featureProb, color=qud)) +
  geom_point() +
  theme_bw()

ggplot(d.m.met.f1.compare, aes(x=animalPrior, y=featureProb, color=qud)) +
  geom_point() +
  theme_bw()

ggplot(d.m.met.f1.compare, aes(x=personPrior, y=featureProb, color=qud)) +
  geom_point() +
  theme_bw()

d.m.met.f2.compare <- subset(d.m.met.compare, featureNum=="2")
# correlate with model
with(d.m.met.f2.compare, cor.test(featureProb, modelProb))
# correlate with just animal
with(d.m.met.f2.compare, cor.test(featureProb, animalPrior))
# correlate with just person
with(d.m.met.f2.compare, cor.test(featureProb, personPrior))

ggplot(d.m.met.f2.compare, aes(x=modelProb, y=featureProb, color=qud)) +
  geom_point() +
  theme_bw()

d.m.met.f3.compare <- subset(d.m.met.compare, featureNum=="3")
# correlate with model
with(d.m.met.f3.compare, cor.test(featureProb, modelProb))
# correlate with just animal
with(d.m.met.f3.compare, cor.test(featureProb, animalPrior))
# correlate with just person
with(d.m.met.f3.compare, cor.test(featureProb, personPrior))

ggplot(d.m.met.f3.compare, aes(x=modelProb, y=featureProb, color=qud)) +
  geom_point() +
  theme_bw()

d.m.met.noQud.compare <- subset(d.m.met.compare, qud=="0")
# correlate with model
with(d.m.met.noQud.compare, cor.test(featureProb, modelProb))
# correlate with just animal
with(d.m.met.noQud.compare, cor.test(featureProb, animalPrior))
# correlate with just person
with(d.m.met.noQud.compare, cor.test(featureProb, personPrior))

ggplot(d.m.met.noQud.compare, aes(x=modelProb, y=featureProb, color=featureNum)) +
  geom_point() +
  theme_bw()

d.m.met.qud.compare <- subset(d.m.met.compare, qud=="1")
# correlate with model
with(d.m.met.qud.compare, cor.test(featureProb, modelProb))
# correlate wtih just animal
with(d.m.met.qud.compare, cor.test(featureProb, animalPrior))
# correlate with just person
with(d.m.met.qud.compare, cor.test(featureProb, personPrior))

ggplot(d.m.met.qud.compare, aes(x=modelProb, y=featureProb, color=featureNum)) +
  geom_point() +
  theme_bw()


