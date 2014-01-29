source("summarySE.R")
d <- read.csv("data49-long.csv")
d$qud <- ifelse(d$condition==1 | d$condition==2, 0, 1)
d$metaphor <- ifelse(d$condition==1 | d$condition==3, 0, 1)

###############################
## Human split-half analysis
################################
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


# visualize properties of the ratings
# d.summary.summary <- summarySE(d.summary, measurevar="featureProb", 
#                                groupvars=c("qud", "metaphor", "featureNum"))
# 
# d.summary.summary$featureLabel <- factor(d.summary.summary$featureNum, labels=c("f1", "f2", "f3"))
# d.summary.summary$qudLabel <- factor(d.summary.summary$qud, labels=c("Vague QUD", "Specific QUD"))
# d.summary.summary$metaphorLabel <- factor(d.summary.summary$metaphor, labels=c("Literal utterance", "Metaphorical utterance"))
# my.colors <- c("#990033", "#CC9999", "#FFFFFF")
# ggplot(d.summary.summary, aes(x=qudLabel, y=featureProb, fill=featureLabel)) +
#   geom_bar(stat="identity", color="black", position=position_dodge()) +
#   geom_errorbar(aes(ymin=featureProb-se, ymax=featureProb+se), width=0.2, position=position_dodge(0.9)) +
#   facet_grid(.~metaphorLabel) +
#   theme_bw() +
#   xlab("") +
#   ylab("Probability of feature given utterance") +
#   #scale_fill_brewer(palette="RdGy", name="Feature")
#   scale_fill_manual(values=my.colors, name="Feature")

## Metaphor only
d.met.summary <- subset(d.summary, metaphor=="1")

#### Model

m.met.summary <- data.frame(dummy=NULL, featureProb=NULL, featureNum=NULL, categoryID=NULL, qud=NULL)

for (i in 1:32) {
  filename.noqud <- paste("../../Model/AnimalModelsOutput/noQud_", i, "-set-a2.csv", sep="")
  m.noqud <- read.csv(filename.noqud, header=FALSE)
  colnames(m.noqud) <- c("category", "feature1", "feature2", "feature3", "prob")
  m.noqud$featureProb <- m.noqud$prob
  m.noqud.f1 <- aggregate(data=subset(m.noqud, feature1==1), 
                                featureProb ~ feature1, FUN=sum)
  colnames(m.noqud.f1)[1] <- "dummy"
  m.noqud.f1$featureNum <- 1
  m.noqud.f2 <- aggregate(data=subset(m.noqud, feature2==1), 
                                featureProb ~ feature2, FUN=sum)
  colnames(m.noqud.f2)[1] <- "dummy"
  m.noqud.f2$featureNum <- 2
  m.noqud.f3 <- aggregate(data=subset(m.noqud, feature3==1), 
                                featureProb ~ feature3, FUN=sum)
  colnames(m.noqud.f3)[1] <- "dummy"
  m.noqud.f3$featureNum <- 3
  
  m.noqud.combine <- rbind(m.noqud.f1, m.noqud.f2, m.noqud.f3)
  m.noqud.combine$categoryID = i
  m.noqud.combine$qud = 0
  
  # with qud
  filename.qud <- paste("../../Model/AnimalModelsOutput/qud_", i, "-set-a2.csv", sep="")
  m.qud <- read.csv(filename.qud, header=FALSE)
  colnames(m.qud) <- c("category", "feature1", "feature2", "feature3", "prob")
  m.qud$featureProb <- m.qud$prob 
  m.qud.f1 <- aggregate(data=subset(m.qud, feature1==1), 
                              featureProb ~ feature1, FUN=sum)
  colnames(m.qud.f1)[1] <- "dummy"
  m.qud.f1$featureNum <- 1
  m.qud.f2 <- aggregate(data=subset(m.qud, feature2==1), 
                              featureProb ~ feature2, FUN=sum)
  colnames(m.qud.f2)[1] <- "dummy"
  m.qud.f2$featureNum <- 2
  m.qud.f3 <- aggregate(data=subset(m.qud, feature3==1), 
                              featureProb ~ feature3, FUN=sum)
  colnames(m.qud.f3)[1] <- "dummy"
  m.qud.f3$featureNum <- 3
  m.qud.combine <- rbind(m.qud.f1, m.qud.f2, m.qud.f3)
  m.qud.combine$categoryID = i
  m.qud.combine$qud <- 1
  
  # combine qud + noqud
  m.combine <- rbind(m.noqud.combine, m.qud.combine)
  m.met.summary <- rbind(m.met.summary, m.combine)
}

colnames(m.met.summary)[2] <- "modelProb"
m.met.summary$modelZ <- (m.met.summary$modelProb - mean(m.met.summary$modelProb)) / sd(m.met.summary$modelProb)

######## Get an example for the model ######## ######## ######## 
# m.example.id <- 30
# m.example.noqud <- read.csv("../../Model/AnimalModelsOutput/test.csv", header=FALSE)
# #m.example.noqud <- read.csv(paste("../../Model/AnimalModelsOutput/qud_", m.example.id, "-set-transformed-d2.csv", sep=""), header=FALSE)
# colnames(m.example.noqud) <- c("category", "feature1", "feature2", "feature3", "prob")
# m.example.noqud$featureProb <- m.example.noqud$prob
# m.example.noqud$featureSetVals <- paste(m.example.noqud$feature1, m.example.noqud$feature2,
#                                         m.example.noqud$feature3, sep=",")
# m.example.noqud$feature1 <- factor(m.example.noqud$feature1)
# ##### Plot example, joint
# ggplot(m.example.noqud, aes(x=featureSetVals, y=featureProb, fill=feature1)) +
#   geom_bar(stat="identity", color="black") +
#   theme_bw()
# 
# m.example.noqud.f1 <- aggregate(data=subset(m.example.noqud, feature1==1), 
#                         featureProb ~ feature1, FUN=sum)
# colnames(m.example.noqud.f1)[1] <- "dummy"
# m.example.noqud.f1$featureNum <- 1
# m.example.noqud.f2 <- aggregate(data=subset(m.example.noqud, feature2==1), 
#                         featureProb ~ feature2, FUN=sum)
# colnames(m.example.noqud.f2)[1] <- "dummy"
# m.example.noqud.f2$featureNum <- 2
# m.example.noqud.f3 <- aggregate(data=subset(m.example.noqud, feature3==1), 
#                         featureProb ~ feature3, FUN=sum)
# colnames(m.example.noqud.f3)[1] <- "dummy"
# m.example.noqud.f3$featureNum <- 3
# 
# m.example.noqud.combine <- rbind(m.example.noqud.f1, m.example.noqud.f2, m.example.noqud.f3)
# m.example.noqud.combine$categoryID = i
# m.example.noqud.combine$qud = 0
# 
# # with qud
# m.example.qud <- read.csv(paste("../../Model/AnimalModelsOutput/qud_", 
#                                   m.example.id, "-set.csv", sep=""), header=FALSE)
# colnames(m.example.qud) <- c("category", "feature1", "feature2", "feature3", "prob")
# m.example.qud$featureProb <- m.example.qud$prob 
# m.example.qud.f1 <- aggregate(data=subset(m.example.qud, feature1==1), 
#                       featureProb ~ feature1, FUN=sum)
# colnames(m.example.qud.f1)[1] <- "dummy"
# m.example.qud.f1$featureNum <- 1
# m.example.qud.f2 <- aggregate(data=subset(m.example.qud, feature2==1), 
#                       featureProb ~ feature2, FUN=sum)
# colnames(m.example.qud.f2)[1] <- "dummy"
# m.example.qud.f2$featureNum <- 2
# m.example.qud.f3 <- aggregate(data=subset(m.example.qud, feature3==1), 
#                       featureProb ~ feature3, FUN=sum)
# colnames(m.example.qud.f3)[1] <- "dummy"
# m.example.qud.f3$featureNum <- 3
# m.example.qud.combine <- rbind(m.example.qud.f1, m.example.qud.f2, m.example.qud.f3)
# m.example.qud.combine$categoryID = i
# m.example.qud.combine$qud <- 1
# 
# # combine qud + noqud
# m.example.combine <- rbind(m.example.noqud.combine, m.example.qud.combine)
# m.example.met.summary <- rbind(m.met.summary, m.combine)
# colnames(m.met.summary)[2] <- "modelProb"
# 
# m.met.example <- subset(m.met.summary, categoryID=="1")
# m.met.example$qud <- factor(m.met.example$qud)
# ggplot(m.met.example, aes(x=featureNum, y=modelProb, fill=qud)) +
#   geom_bar(stat="identity", color="black", position=position_dodge()) +
#   theme_bw()
# ######## ######## ######## ######## ######## 


# summary statistics
m.met.summary.summary <- summarySE(m.met.summary, measurevar="modelProb", groupvars=c("featureNum", "qud"))
m.met.summary.summary$featureLabel <- factor(m.met.summary.summary$featureNum, labels=c("f1", "f2", "f3"))
m.met.summary.summary$qudLabel <- factor(m.met.summary.summary$qud, labels=c("Vague QUD", "Specific QUD"))
ggplot(m.met.summary.summary, aes(x=qudLabel, y=modelProb, fill=featureLabel)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=modelProb-se, ymax=modelProb+se), width=0.2, position=position_dodge(0.9)) +
  theme_bw() +
  #scale_fill_brewer(palette="Accent", name="Feature") +
  scale_fill_manual(values=my.colors, name="Feature") +
  xlab("") +
  ylab("Probability of feature given utterance")

#### this part needs analysis-featurePrior.R
# # predictions for the literal utterances equivalent to marginal of priors given f1 is true
# m.lit.qud <- data.frame(categoryID=fp.set.long.summary.f2f3givenf1$categoryID, 
#                     featureNum=fp.set.long.summary.f2f3givenf1$feature,
#                     modelProb=fp.set.long.summary.f2f3givenf1$probGivenf1,
#                     modelZ=fp.set.long.summary.f2f3givenf1$probGivenf1)
# m.lit.noqud <- m.lit.qud
# 
# m.lit.f1 <- data.frame(categoryID=fp.set.long.summary.f2f3givenf1$categoryID)
# m.lit.f1$featureNum <- "1"
# m.lit.f1$modelProb <- 1
# m.lit.f1$modelZ <- 1
# 
# m.lit.qud <- rbind(m.lit.qud, m.lit.f1)
# m.lit.qud$qud <- "1"
# m.lit.noqud <- rbind(m.lit.noqud, m.lit.f1)
# m.lit.noqud$qud <- "0"
# 
# m.lit <- rbind(m.lit.qud, m.lit.noqud)
# m.lit$dummy <- "1"
# m.lit$metaphor <- "0"
# m.met.summary$metaphor <- "1"
# 
# m.met.lit <- rbind(m.met.summary, m.lit)
# m.met.lit.summary <- summarySE(m.met.lit, measurevar="modelProb", 
#                                groupvars=c("featureNum", "metaphor", "qud"))
# 
# m.met.lit.summary$metaphor <- factor(m.met.lit.summary$metaphor, 
#                                      labels=c("Literal utterance", "Metaphorical utterance"))
# ggplot(m.met.lit.summary, aes(x=qud, y=modelProb, fill=featureNum)) +
#   geom_bar(stat="identity", color="black", position=position_dodge()) +
#   geom_errorbar(aes(ymin=modelProb-se, ymax=modelProb+se), width=0.2, position=position_dodge(0.9)) +
#   theme_bw() +
#   facet_grid(.~metaphor) +
#   #scale_fill_brewer(palette="Accent", name="Feature") +
#   scale_fill_manual(values=my.colors, name="Feature", labels=c("f1", "f2", "f3")) +
#   xlab("") +
#   scale_x_discrete(labels=c("Vague QUD", "Specific QUD")) +
#   ylab("Probability of feature given utterance")
# 
# 
# d.m.met.lit.compare <- join(d.summary, m.met.lit, by=c("categoryID", "featureNum", "qud", "metaphor"))
# with(d.m.met.lit.compare, cor.test(modelProb, featureProb))
# ggplot(d.m.met.lit.compare, aes(x=modelProb, y=featureProb, color=metaphor)) +
#   geom_point() +
#   theme_bw()

#######################
# Combine model and human
######################

d.m.met.compare <- join(d.met.summary, m.met.summary, by=c("categoryID", "featureNum", "qud"))
# add feature labels
features <- read.csv("../FeaturePriorExp/features-only.csv")
d.m.met.compare <- join(d.m.met.compare, features, by=c("animal", "featureNum"))
d.m.met.compare$featureNum <- factor(d.m.met.compare$featureNum)
d.m.met.compare$qud <- factor(d.m.met.compare$qud)
d.m.met.compare$featureProbConverted <- pnorm(d.m.met.compare$featureProb)
with(d.m.met.compare, cor.test(featureProb, modelProb))
#with(d.m.met.compare, cor.test(featureProbConverted, modelProb))
#with(d.m.met.compare, cor.test(featureProb, modelZ))

d.m.met.compare$featureLabel <- paste(d.m.met.compare$animal, d.m.met.compare$feature, sep="-")
d.m.met.compare.f1 <- subset(d.m.met.compare,featureNum=="1")
with(d.m.met.compare.f1, cor.test(featureProb, modelProb))

d.m.met.compare.f2 <- subset(d.m.met.compare,featureNum=="2")
with(d.m.met.compare.f2, cor.test(featureProb, modelProb))

d.m.met.compare.f3 <- subset(d.m.met.compare,featureNum=="3")
with(d.m.met.compare.f3, cor.test(featureProb, modelProb))

ggplot(d.m.met.compare, aes(x=modelProb, y=featureProb, shape=qud, fill=featureNum)) +
  geom_point(size=3) +
  #geom_errorbar(aes(ymin=featureProb-se, ymax=featureProb+se), width=0.01, color="grey") +
  #geom_text(aes(label=featureLabel, color=qud)) +
  scale_shape_manual(values=c(21, 24), name="QUD", labels=c("Vague", "Specific")) +
  theme_bw() +
  scale_fill_manual(values=my.colors, name="Feature", labels=c("f1", "f2", "f3")) +
  xlab("Model") +
  ylab("Human")

#### Correlate with feature priors

priors <- read.csv("../FeaturePriorExp/featurePriors-set-marginal.csv")
priors.animal <- subset(priors, category=="animal")
priors.person <- subset(priors, category=="person")

colnames(priors.animal)[4] <- "animalPrior"
colnames(priors.person)[4] <- "personPrior"
d.m.met.compare <- join(d.m.met.compare, priors.animal, by=c("categoryID", "featureNum"))
d.m.met.compare <- join(d.m.met.compare, priors.person, by=c("categoryID", "featureNum"))

d.m.met.compare$labels <- paste(d.m.met.compare$animal, d.m.met.compare$feature, sep=";")
d.m.met.compare.f1 <- subset(d.m.met.compare, featureNum=="1")
d.m.met.compare.f2 <- subset(d.m.met.compare, featureNum=="2")
d.m.met.compare.f3 <- subset(d.m.met.compare, featureNum=="3")

d.m.met.compare.f1.noQud <- subset(d.m.met.compare.f1, qud=="0")
with(d.m.met.compare.f1.noQud, cor.test(personPrior, featureProb))
with(d.m.met.compare.f1.noQud, cor.test(animalPrior, featureProb))
with(d.m.met.compare.f1.noQud, cor.test(modelProb, featureProb))

d.m.met.compare.f1.qud <- subset(d.m.met.compare.f1, qud=="1")
with(d.m.met.compare.f1.qud, cor.test(personPrior, featureProb))
with(d.m.met.compare.f1.qud, cor.test(animalPrior, featureProb))
with(d.m.met.compare.f1.qud, cor.test(modelProb, featureProb))

ggplot(d.m.met.compare.f1, aes(x=animalPrior, y=featureProb, color=qud)) +
  geom_point(size=2) +
  #geom_text(aes(label=labels)) +
  scale_shape_manual(values=c(0, 19)) +
  theme_bw()


# Correlate with just feature priors
with(d.m.met.compare.f1, cor.test(featureProb, animalPrior))
with(d.m.met.compare.f1, cor.test(featureProb, personPrior))
d.m.met.compare$averagePrior <- (d.m.met.compare$animalPrior + d.m.met.compare$personPrior) / 2
with(d.m.met.compare, cor.test(featureProb, averagePrior))
with(d.m.met.compare, cor.test(featureProb, modelProb))
summary(lm(data=d.m.met.compare, featureProb ~ modelProb))
summary(lm(data=d.m.met.compare, featureProb ~ averagePrior))
summary(lm(data=d.m.met.compare, featureProb ~ animalPrior * personPrior))

d.m.met.f1.compare <- subset(d.m.met.compare, featureNum=="1")
# correlate with model
with(d.m.met.f1.compare, cor.test(featureProb, modelProb))
# correlate with just animal
with(d.m.met.f1.compare, cor.test(featureProb, animalPrior))
# correlate with just person
with(d.m.met.f1.compare, cor.test(featureProb, personPrior))
with(d.m.met.f1.compare, cor.test(featureProb, averagePrior))

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


#### Examples

# human
this.categoryID <- "1"
d.example <- subset(d.summary, categoryID==this.categoryID)
ggplot(d.example, aes(x=qud, y=featureProb, fill=featureNum)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=featureProb-se, ymax=featureProb+se), width=0.2, position=position_dodge(0.9)) +
  facet_grid(.~metaphor) +
  theme_bw() +
  xlab("") +
  scale_fill_brewer(palette="Accent", name="Feature")

# model #### TODOOOOOOOO
m.example <- read.csv("../../Model/AnimalModelsOutput/test.csv")
colnames(m.example) <- c("category", "feature1", "feature2", "feature3", "featureProb")
m.example.f1 <- aggregate(data=subset(m.example, feature1==1), 
                        featureProb ~ feature1, FUN=sum)
colnames(m.example.f1)[1] <- "dummy"
m.example.f1$featureNum <- 1
m.example.f2 <- aggregate(data=subset(m.example, feature2==1), 
                        featureProb ~ feature2, FUN=sum)
colnames(m.example.f2)[1] <- "dummy"
m.example.f2$featureNum <- 2
m.example.f3 <- aggregate(data=subset(m.example, feature3==1), 
                        featureProb ~ feature3, FUN=sum)
colnames(m.example.f3)[1] <- "dummy"
m.example.f3$featureNum <- 3

m.example.combine <- rbind(m.example.f1, m.example.f2, m.example.f3)
m.example.combine$featureNum <- factor(m.example.combine$featureNum)

ggplot(m.example.combine, aes(x=featureNum, y=featureProb, fill=featureNum)) +
  geom_bar(stat="identity", color="black", position=position_dodge())