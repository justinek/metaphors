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
###################
# Visualize properties of the ratings
###################
d.summary.summary <- summarySE(d.summary, measurevar="featureProb", 
                               groupvars=c("qud", "metaphor", "featureNum"))
d.summary.summary$featureLabel <- factor(d.summary.summary$featureNum, labels=c("f1", "f2", "f3"))
d.summary.summary$qudLabel <- factor(d.summary.summary$qud, labels=c("Vague QUD", "Specific QUD"))
d.summary.summary$metaphorLabel <- factor(d.summary.summary$metaphor, labels=c("Literal utterance", "Metaphorical utterance"))
my.colors <- c("#990033", "#CC9999", "#FFFFFF")
ggplot(d.summary.summary, aes(x=qudLabel, y=featureProb, fill=featureLabel)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=featureProb-se, ymax=featureProb+se), width=0.2, position=position_dodge(0.9)) +
  facet_grid(.~metaphorLabel) +
  theme_bw() +
  xlab("") +
  ylab("Probability of feature given utterance") +
  #scale_fill_brewer(palette="RdGy", name="Feature")
  scale_fill_manual(values=my.colors, name="Feature")
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
    name.noQud <- paste("noQud-a", as.list(strsplit(name, "a"))[[1]][2], sep="")
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
    }
  }
}
with(best, cor.test(featureProb, modelProb))
##########################
# Add feature priors
##########################
priors <- read.csv("../FeaturePriorExp/featurePriors-set-marginal.csv")
priors.animal <- subset(priors, category=="animal")
priors.person <- subset(priors, category=="person")
colnames(priors.animal)[4] <- "animalPrior"
colnames(priors.person)[4] <- "personPrior"
best <- join(best, priors.animal, by=c("categoryID", "featureNum"))
best <- join(best, priors.person, by=c("categoryID", "featureNum"))
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
ggplot(best.f2, aes(x=modelProb, y=featureProb, shape=qud, fill=featureNum)) +
  #geom_point(size=3) +
  #geom_errorbar(aes(ymin=featureProb-se, ymax=featureProb+se), width=0.01, color="grey") +
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
plot(fit)
best$resid <- residuals(fit)
best <- best[with(best, order(-abs(resid))), ]
########################
# Human split-half
########################
###############################
## Human split-half analysis
################################
splithalf.all.sum <- 0
splithalf.met.sum <- 0
splithalf.f1.sum <- 0
splithalf.f2.sum <- 0
splithalf.f3.sum <- 0
for (t in seq(1, 100)) {
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
  splithalf.all.sum <- splithalf.all.sum + with(splithalf.comp, cor(h1prob, h2prob))
  # just metaphor
  splithalf.met.comp <- subset(splithalf.comp, metaphor=="1")
  splithalf.met.sum <- splithalf.met.sum + with(splithalf.met.comp, cor(h1prob, h2prob))
  splithalf.f1.sum <- splithalf.f1.sum + with(subset(splithalf.met.comp, featureNum==1), cor(h1prob, h2prob))
  splithalf.f2.sum <- splithalf.f2.sum + with(subset(splithalf.met.comp, featureNum==2), cor(h1prob, h2prob))
  splithalf.f3.sum <- splithalf.f3.sum + with(subset(splithalf.met.comp, featureNum==3), cor(h1prob, h2prob))
}
splithalf.all <- splithalf.all.sum / 100
splithalf.met <- splithalf.met.sum / 100
splithalf.f1 <- splithalf.f1.sum / 100
splithalf.f2 <- splithalf.f2.sum / 100
splithalf.f3 <- splithalf.f3.sum / 100

prophet <- function(reliability, length) {
  prophecy <- length * reliability / (1 + (length - 1)*reliability)
  return (prophecy)
}
prophet(splithalf.all, 2)
prophet(splithalf.met, 2)
prophet(splithalf.f1, 2)
prophet(splithalf.f2, 2)
prophet(splithalf.f3, 2)

  
