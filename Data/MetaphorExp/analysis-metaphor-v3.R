library(ggplot2)
library(reshape2)
library(plyr)
library(lme4)
source("~/Dropbox/Work/Grad_school/Research/Utilities/summarySE.R")
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
###################
# Visualize properties of the ratings
###################
d.summary.summary <- summarySE(d.summary, measurevar="featureProb", 
                               groupvars=c("qud", "metaphor", "featureNum"))
d.summary.summary$featureLabel <- factor(d.summary.summary$featureNum, labels=c("f1", "f2", "f3"))
d.summary.summary$qudLabel <- factor(d.summary.summary$qud, labels=c("Vague goal", "Specific goal"))
d.summary.summary$metaphorLabel <- factor(d.summary.summary$metaphor, labels=c("Literal utterance", "Metaphorical utterance"))
my.colors <- c("#990033", "#CC9999", "#FFFFFF")
ggplot(d.summary.summary, aes(x=qudLabel, y=featureProb, fill=featureLabel)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=featureProb-se, ymax=featureProb+se), width=0.2, position=position_dodge(0.9)) +
  facet_grid(.~metaphorLabel) +
  ylim(c(0, 1)) +
  theme_bw() +
  xlab("") +
  ylab("Probability of feature given utterance") +
  #scale_fill_brewer(palette="RdGy", name="Feature")
  scale_fill_manual(values=my.colors, name="Feature") +
  theme(legend.position=c(0.9,0.8))
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
filenames <- read.csv("../../Model/CogSciModel/combinedOutputFilenames.txt", header=FALSE)
#filenames <- read.csv("../../Model/CogSciModel/testOutputFilenames.txt", header=FALSE)
max.cor <- 0
max.name <- ""
for (n in filenames$V1) {
  if (grepl("g", n)) {
    name.qud <- n
    name.noQud <- paste("noQud-a", as.list(strsplit(n, "a"))[[1]][2], sep="")
    m.qud <- read.csv(paste("../../Model/CogSciModel/CombinedOutput/", name.qud, sep=""), header=FALSE)
    m.noQud <- read.csv(paste("../../Model/CogSciModel/CombinedOutput/",name.noQud, sep=""), header=FALSE)
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

#######################
# Lion example
#######################
name.qud <- max.name
name.noQud <- paste("noQud-a", as.list(strsplit(n, "a"))[[1]][2], sep="")
m.qud <- read.csv(paste("../../Model/CogSciModel/CombinedOutput/", name.qud, sep=""), header=FALSE)
m.noQud <- read.csv(paste("../../Model/CogSciModel/CombinedOutput/",name.noQud, sep=""), header=FALSE)
m.qud$qud <- "1"
m.noQud$qud <- "0"
m <- rbind(m.qud, m.noQud)
colnames(m) <- c("category", "f1", "f2", "f3", "modelProb", "categoryID", "qud")

lion <- subset(m, categoryID==20)
lion$features <- paste(lion$f1, lion$f2, lion$f3, sep=",")
lion.noqud <- subset(lion, qud=="0")
lion.qud <- subset(lion, qud=="1")
# show metaphor effect for no qud only
lion.metaphor <- aggregate(data=lion.noqud, modelProb ~ category, FUN=sum)
ggplot(lion.metaphor, aes(x=category, y=modelProb)) +
  geom_bar(stat="identity", color="black", position=position_dodge(), fill="#99CCFF") +
  theme_bw() +
  xlab("Category") +
  ylab("Probability") +
  scale_x_discrete(labels=c("Lion", "Person")) +
  theme(axis.title.x = element_text(size=16),
        axis.text.x  = element_text(size=14),
        axis.title.y = element_text(size=16),
        axis.text.y = element_text(size=14))

# show marginal feature interpretation for no qud only
getMarginalFeatures <- function(modelResult) {
  f1 <- aggregate(data=subset(modelResult, f1==1), modelProb ~ qud, FUN=sum)
  f1$featureNum <- 1
  f2 <- aggregate(data=subset(modelResult, f2==1), modelProb ~ qud, FUN=sum)
  f2$featureNum <- 2
  f3 <- aggregate(data=subset(modelResult, f3==1), modelProb ~ qud, FUN=sum)
  f3$featureNum <- 3
  marginal <- rbind(f1, f2, f3)
  return (marginal)
}

lion.marginal.noqud <- getMarginalFeatures(lion.noqud)
lion.marginal.noqud$featureNum <- factor(lion.marginal.noqud$featureNum)
ggplot(lion.marginal.noqud, aes(x=featureNum, y=modelProb, fill=featureNum)) +
  geom_bar(stat="identity", color="black") +
  theme_bw() +
  xlab("Feature") +
  ylab("Probability") +
  scale_x_discrete(labels=c("ferocious", "scary", "strong")) +
  theme(axis.title.x = element_text(size=16),
        axis.text.x  = element_text(size=14),
        axis.title.y = element_text(size=16),
        axis.text.y = element_text(size=14)) +
  scale_fill_manual(values=c("#003366", "#006699", "#99ccff"), guide="none")
  #scale_fill_brewer(palette="Blues")

lion.marginal.qud <- getMarginalFeatures(lion.qud)
lion.marginal.qud$featureNum <- factor(lion.marginal.qud$featureNum)
ggplot(lion.marginal.qud, aes(x=featureNum, y=modelProb, fill=featureNum)) +
  geom_bar(stat="identity", color="black") +
  theme_bw() +
  xlab("Feature") +
  ylab("Probability") +
  scale_x_discrete(labels=c("ferocious", "scary", "strong")) +
  theme(axis.title.x = element_text(size=16),
        axis.text.x  = element_text(size=14),
        axis.title.y = element_text(size=16),
        axis.text.y = element_text(size=14)) +
  scale_fill_manual(values=c("#003366", "#006699", "#99ccff"), guide="none")

# Show cluster of features for qud
lion.noqud$featureSetNum <- c(1, 2, 3, 4, 5, 6, 7, 8)
lion.noqud$featureSetNum <- factor(lion.noqud$featureSetNum,
                                 labels=c("1,1,1","1,1,0","1,0,1","1,0,0",
                                         "0,1,1","0,1,0","0,0,1","0,0,0"))
ggplot(lion.noqud, aes(x=featureSetNum, y=modelProb, fill=featureSetNum)) +
  geom_bar(stat="identity", color="black") +
  theme_bw() +
  xlab("Feature vector") +
  ylab("Probability") +
  ylim(0,0.3) +
  theme(axis.title.x = element_text(size=16),
        axis.text.x  = element_text(size=14),
        axis.title.y = element_text(size=16),
        axis.text.y = element_text(size=14)) +
  scale_fill_manual(values=c("#0570b0","#6baed6","#bdd7e7","#eff3ff",
                             "#f7f7f7","#cccccc","#969696","#525252"), 
                    guide="none")

priors.joint <- read.csv("../FeaturePriorExp/featurePriors-set.csv")
personPriors.joint.lion <- subset(priors.joint, categoryID==20 & type=="person")
personPriors.joint.lion.f1present <- subset(personPriors.joint.lion, featureSetNum <=4)
normalizer <- sum(personPriors.joint.lion.f1present$normalizedProb)
personPriors.joint.lion.f1present$probGivenF1 <- 
  personPriors.joint.lion.f1present$normalizedProb / normalizer

personPriors.joint.lion.f1notpresent <- data.frame(categoryID=c(20,20,20,20),
                                                   type=c("person","person","person","person"),
                                                   featureSetNum=c(5,6,7,8),
                                                   animal=c("lion","lion","lion","lion"),
                                                   N=c(35,35,35,35),
                                                   normalizedProb=c(0,0,0,0),
                                                   sd=c(0,0,0,0),
                                                   se=c(0,0,0,0),
                                                   ci=c(0,0,0,0),
                                                   probGivenF1=c(0,0,0,0))
personPriors.joint.lion.all <- rbind(personPriors.joint.lion.f1present,
                                     personPriors.joint.lion.f1notpresent)
personPriors.joint.lion.all$featureSetNum <- 
  factor(personPriors.joint.lion.all$featureSetNum,
                                 labels=c("1,1,1","1,1,0","1,0,1","1,0,0",
                                          "0,1,1","0,1,0","0,0,1","0,0,0"))
ggplot(personPriors.joint.lion.all, aes(x=featureSetNum, y=probGivenF1, fill=featureSetNum)) +
  geom_bar(stat="identity", color="black") +
  theme_bw() +
  xlab("Feature vector") +
  ylab("Probability") +
  theme(axis.title.x = element_text(size=16),
        axis.text.x  = element_text(size=14),
        axis.title.y = element_text(size=16),
        axis.text.y = element_text(size=14)) +
  scale_fill_manual(values=c("#0570b0","#6baed6","#bdd7e7","#eff3ff",
                             "#f7f7f7","#cccccc","#969696","#525252"), 
                    guide="none")

##########################
# Add feature priors
##########################
priors <- read.csv("../FeaturePriorExp/featurePriors-set-marginal.csv")
priors.animal <- subset(priors, category=="animal")
priors.person <- subset(priors, category=="person")
colnames(priors.animal)[4] <- "animalPrior"
colnames(priors.person)[4] <- "personPrior"
d.summary <- join(d.summary, priors.animal, by=c("categoryID", "featureNum"))
d.summary <- join(d.summary, priors.person, by=c("categoryID", "featureNum"))
best <- join(best, priors.animal, by=c("categoryID", "featureNum"))
best <- join(best, priors.person, by=c("categoryID", "featureNum"))
######################
# Human stats
#####################
summary(lm(data=d.f1.summary, featureProb ~ metaphor))
summary(lm(data=d.f2.summary, featureProb ~ metaphor))
summary(lm(data=d.f3.summary, featureProb ~ metaphor))
summary(lm(data=subset(d.f1.summary, metaphor==1), featureProb ~ qud))
summary(lm(data=subset(d.f2.summary, metaphor==1), featureProb ~ qud))
summary(lm(data=subset(d.f3.summary, metaphor==1), featureProb ~ qud))
summary(lm(data=subset(d.f1.summary, metaphor==0), featureProb ~ qud))
summary(lm(data=subset(d.f2.summary, metaphor==0), featureProb ~ qud))
summary(lm(data=subset(d.f3.summary, metaphor==0), featureProb ~ qud))
with(subset(d.summary, metaphor=="0" & featureNum=="1"), t.test(featureProb, personPrior, paired=TRUE))
with(subset(d.summary, metaphor=="0" & featureNum=="2"), t.test(featureProb, personPrior, paired=TRUE))
with(subset(d.summary, metaphor=="0" & featureNum=="3"), t.test(featureProb, personPrior, paired=TRUE))
with(subset(d.summary, metaphor=="1" & featureNum=="1"), t.test(featureProb, personPrior, paired=TRUE))
with(subset(d.summary, metaphor=="1" & featureNum=="2"), t.test(featureProb, personPrior, paired=TRUE))
with(subset(d.summary, metaphor=="1" & featureNum=="3"), t.test(featureProb, personPrior, paired=TRUE))
with(subset(d.summary, metaphor=="1" & featureNum=="1" & qud=="1"), t.test(featureProb, personPrior, paired=TRUE))
with(subset(d.summary, metaphor=="1" & featureNum=="2" & qud=="1"), t.test(featureProb, personPrior, paired=TRUE))
with(subset(d.summary, metaphor=="1" & featureNum=="3"& qud=="1"), t.test(featureProb, personPrior, paired=TRUE))
d.summary$featureType <- ifelse(d.summary$featureNum==1, 1, 0)
d.summary$featureType <- factor(d.summary$featureType)
anova(lm(data=d.summary, featureProb ~ metaphor * featureType))

############################## 
# Add feature labels
################################
features <- read.csv("../FeaturePriorExp/features-only.csv")
best <- join(best, features, by=c("animal", "featureNum"))
best$labels <- paste(best$animal, best$feature, sep=";")
############################
# Individual features
############################
best.f1 <- subset(best, featureNum=="1")
best.f2 <- subset(best, featureNum=="2")
best.f3 <- subset(best, featureNum=="3")
with(best.f1, cor.test(featureProb, modelProb))
with(best.f2, cor.test(featureProb, modelProb))
with(best.f3, cor.test(featureProb, modelProb))
###########################
# Compare to prior performance
###########################
with(best, cor.test(featureProb, modelProb))
with(best, cor.test(featureProb, animalPrior))
with(best, cor.test(featureProb, personPrior))
model.fit <- lm(data=best, featureProb ~ modelProb)
baseline.fit <- lm(data=best, featureProb ~ animalPrior + personPrior + qud)
with(best.f1, cor.test(featureProb, modelProb))
with(best.f1, cor.test(featureProb, animalPrior))
with(best.f1, cor.test(featureProb, personPrior))
with(best.f2, cor.test(featureProb, modelProb))
with(best.f2, cor.test(featureProb, animalPrior))
with(best.f2, cor.test(featureProb, personPrior))
with(best.f3, cor.test(featureProb, modelProb))
with(best.f3, cor.test(featureProb, animalPrior))
with(best.f3, cor.test(featureProb, personPrior))
#### No significance test
with(best, cor(featureProb, modelProb))
with(best, cor(featureProb, animalPrior))
with(best, cor(featureProb, personPrior))
with(best.f1, cor(featureProb, modelProb))
with(best.f1, cor(featureProb, animalPrior))
with(best.f1, cor(featureProb, personPrior))
with(best.f2, cor(featureProb, modelProb))
with(best.f2, cor(featureProb, animalPrior))
with(best.f2, cor(featureProb, personPrior))
with(best.f3, cor(featureProb, modelProb))
with(best.f3, cor(featureProb, animalPrior))
with(best.f3, cor(featureProb, personPrior))
#########################
# Visualize scatter plot
#########################
ggplot(best, aes(x=modelProb, y=featureProb, shape=qud, fill=featureNum)) +
  #geom_point(size=3) +
  geom_errorbar(aes(ymin=featureProb-se, ymax=featureProb+se), width=0.01, color="grey") +
  geom_text(aes(label=labels, color=qud)) +
  scale_shape_manual(values=c(21, 24), name="Goal", labels=c("Vague", "Specific")) +
  theme_bw() +
  scale_fill_manual(values=my.colors, name="Feature", labels=c("f1", "f2", "f3"), 
                    guide=guide_legend(override.aes=aes(shape=21))) +
  xlab("Model") +
  ylab("Human")
#########################
# Visualize residuals
#########################
fit <- lm(data=best, featureProb ~ modelProb)
#plot(fit)
best$resid <- residuals(fit)
best <- best[with(best, order(-abs(resid))), ]
############################
# Model analysis
############################
########
# Literalness
########
model.literalness <- aggregate(data=best.model, modelProb ~ category + categoryID + qud, FUN=sum)
model.literalness$qud <- factor(model.literalness$qud)
model.literalness.summary <- summarySE(model.literalness, measurevar="modelProb",
                                       groupvars=c("category"))
ggplot(model.literalness.summary, aes(x=category, y=modelProb, fill=category)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=modelProb-se, ymax=modelProb+se), width=0.2) +
  xlab("") +
  ylab("Probability of category given utterance") +
  scale_x_discrete(labels=c("Animal", "Person")) +
  scale_fill_manual(values=c("#003366", "#CCCCCC"), guide=FALSE) +
  theme_bw()
#######
# Aggregate feature stuff
#######
########
# Model qualitative stats
########
summary(lm(data=subset(best, featureNum=="1"), modelProb ~ qud))
summary(lm(data=subset(best, featureNum=="2"), modelProb ~ qud))
summary(lm(data=subset(best, featureNum=="3"), modelProb ~ qud))

best.marginals.summary <- summarySE(best, measurevar="modelProb",
                                    groupvars=c("featureNum", "qud"))
ggplot(best.marginals.summary, aes(x=qud, y=modelProb, fill=featureNum)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=modelProb-se, ymax=modelProb+se), width=0.2, position=position_dodge(0.9)) +
  theme_bw() +
  scale_fill_manual(values=my.colors, name="Feature", labels=c("f1", "f2", "f3")) +
  xlab("") +
  ylab("Probability of feature given utterance") +
  scale_x_discrete(labels=c("Vague goal", "Specific goal"))

###############################
## Human split-half analysis
################################
splithalf.all.sum <- 0
splithalf.met.sum <- 0
splithalf.f1.sum <- 0
splithalf.f2.sum <- 0
splithalf.f3.sum <- 0
splithalf.cors <- data.frame(all=NULL, met=NULL, f1=NULL, f2=NULL, f3=NULL)            
for (t in seq(1, 1000)) {
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
  splithalf.comp <- splithalf.comp[complete.cases(splithalf.comp),]
  # full data
  all <- prophet(with(splithalf.comp, cor(h1prob, h2prob)), 2)
  # just metaphor
  splithalf.met.comp <- subset(splithalf.comp, metaphor=="1")
  met <- prophet(with(splithalf.met.comp, cor(h1prob, h2prob)), 2)
  f1 <- prophet(with(subset(splithalf.met.comp, featureNum==1), cor(h1prob, h2prob)), 2)
  f2 <- prophet(with(subset(splithalf.met.comp, featureNum==2), cor(h1prob, h2prob)), 2)
  f3 <- prophet(with(subset(splithalf.met.comp, featureNum==3), cor(h1prob, h2prob)), 2)
  this.frame <- data.frame(all=all,
                           met=met,
                           f1=f1,
                           f2=f2,
                           f3=f3)
  splithalf.cors <- rbind(splithalf.cors, this.frame)
}

splithalf.all <- summarySE(splithalf.cors, measurevar="all", groupvars=NULL)
splithalf.met <- summarySE(splithalf.cors, measurevar="met", groupvars=NULL)
splithalf.f1 <- summarySE(splithalf.cors, measurevar="f1", groupvars=NULL)
splithalf.f2 <- summarySE(splithalf.cors, measurevar="f2", groupvars=NULL)
splithalf.f3 <- summarySE(splithalf.cors, measurevar="f3", groupvars=NULL)

prophet <- function(reliability, length) {
  prophecy <- length * reliability / (1 + (length - 1)*reliability)
  return (prophecy)
}
prophet(splithalf.all, 2)
prophet(splithalf.met, 2)
prophet(splithalf.f1, 2)
prophet(splithalf.f2, 2)
prophet(splithalf.f3, 2)

##########################
# Ant Ox Strong error analysis
#########################
d.ant <- read.csv("../../Model/CogSciModel/ant.csv", header=FALSE)
colnames(d.ant) <- c("category", "f1", "f2", "f3", "modelProb")
d.ant.ox <- read.csv("../../Model/CogSciModel/ant-ox.csv", header=FALSE)  
colnames(d.ant.ox) <- c("category", "f1", "f2", "f3", "modelProb")

sum(subset(d.ant,f2==1)$modelProb)
sum(subset(d.ant.ox,f2==1)$modelProb)
sum(subset(d.ant,f1==1)$modelProb)
sum(subset(d.ant.ox,f1==1)$modelProb)
