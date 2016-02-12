library(ggplot2)
library(reshape2)
library(plyr)
library(tidyr)
library(ggbiplot)
library(stringr)
source("~/Dropbox/Work/Grad_school/Research/Utilities/summarySE.R")

#############
# Priors
############
p <- read.csv("../../mTurkScripts/SeedingPriorExp/LaunchPriors/priors-trials.csv")
# Remove subjects with NAs
remove.workerIDs <- unique(subset(p, is.na(response))$workerid)

p <- subset(p, !workerid %in% remove.workerIDs)

p$feature <- factor(p$feature)
p$animal <- factor(p$animal)
p$z <- ave(p$response, p$workerid, FUN=scale)

########################
# Models
########################

#############
# Compare with different alternatives
#############

animals <- read.csv("~/Dropbox/Work/Grad_school/Research/Metaphor/metaphors/Data/SeedingExp/animals_alternatives_features_sorted_coreAnimals.csv")
numBins <- 3
alpha <- 3
#utterance <- "monkey"

p$bin <- cut(p$response, breaks=numBins, labels=seq(from=0, to=numBins-1, by=1))
p$feature_animal <- paste(p$featureID, p$feature, p$animal, sep="_")
p.hist <- with(p, table(feature_animal, bin)) + 1 #laplace smoothing
p.hist <- as.data.frame(prop.table(p.hist, margin = 1))

p.hist <- separate(p.hist, feature_animal, c("featureID", "feature", "animal"), "_")
p.hist <- p.hist[with(p.hist, order(featureID, animal)), ]

man.prior <- subset(p.hist, animal=="man")
man.prior$bin <- factor(man.prior$bin)
man.prior$animal <- NULL
colnames(man.prior)[4] <- "prior"

models <- data.frame(utterance=NULL, feature=NULL, bin=NULL, prob=NULL, featureID=NULL, featureNum=NULL, model=NULL)

for (utterance in animals$animal) {
  
  m <- read.csv(paste("../../Model/SeedingModel/CoreAnimalsOutput/", 
                      utterance, "_", numBins, "_", alpha, ".csv", sep=""), header=FALSE)
  colnames(m)[ncol(m)] <- "prob"
  features <- unlist(strsplit(as.character(subset(animals, animal==utterance)$features), ';')[1])
  colnames(m) <- c("category", features, "prob")
  m.features <- data.frame(feature=NULL, bin=NULL, prob=NULL)
  for (feature in features) {
    m.feature <- aggregate(m[ncol(m)],by=m[feature],FUN=sum)
    m.feature$feature <- feature
    colnames(m.feature)[1] <- "bin"
    m.features <- rbind(m.features, m.feature)
  }
  
  m.features$feature <- factor(m.features$feature)
  m.features$bin <- factor(m.features$bin)
  colnames(m.features)[2] <- "model.full"
  m.features$utterance <- utterance
  m.noAlt <- read.csv(paste("../../Model/SeedingModel/CoreAnimalsOutput/", 
                            utterance, "_", numBins, "_", alpha, "_noAltFeatures.csv", sep=""))
  m.noAlt.features <- data.frame(feature=NULL, bin=NULL, prob=NULL)
  for (feature in colnames(m.noAlt)[3:ncol(m.noAlt)-1]) {
    m.noAlt.feature <- aggregate(m.noAlt[ncol(m.noAlt)],by=m.noAlt[feature],FUN=sum)
    m.noAlt.feature$feature <- feature
    colnames(m.noAlt.feature)[1] <- "bin"
    m.noAlt.features <- rbind(m.noAlt.features, m.noAlt.feature)
  }
  
  m.noAlt.features$feature <- factor(m.noAlt.features$feature)
  m.noAlt.features$bin <- factor(m.noAlt.features$bin)
  
  colnames(m.noAlt.features)[2] <- "model.noAltFeatures"
  m.noAlt.features$utterance <- utterance

  m.noAltUtts <- read.csv(paste("../../Model/SeedingModel/CoreAnimalsOutput/", 
                                utterance, "_", numBins, "_", alpha, "_noAltUtts.csv", sep=""))
  m.noAltUtts.features <- data.frame(feature=NULL, bin=NULL, prob=NULL)
  for (feature in colnames(m.noAltUtts)[3:ncol(m.noAltUtts)-1]) {
    m.noAltUtts.feature <- aggregate(m.noAltUtts[ncol(m.noAltUtts)],by=m.noAltUtts[feature],FUN=sum)
    m.noAltUtts.feature$feature <- feature
    colnames(m.noAltUtts.feature)[1] <- "bin"
    m.noAltUtts.features <- rbind(m.noAltUtts.features, m.noAltUtts.feature)
  }
  
  m.noAltUtts.features$feature <- factor(m.noAltUtts.features$feature)
  m.noAltUtts.features$bin <- factor(m.noAltUtts.features$bin)
  
  colnames(m.noAltUtts.features)[2] <- "model.noAltUtts"
  m.noAltUtts.features$utterance <- utterance
  
  m.dummy <- read.csv(paste("../../Model/SeedingModel/CoreAnimalsOutput/", 
                            utterance, "_", numBins, "_", alpha, "_dummyAltFeatures.csv", sep=""))
  m.dummy.features <- data.frame(feature=NULL, bin=NULL, prob=NULL)
  for (feature in colnames(m.dummy)[3:ncol(m.dummy)-1]) {
    m.dummy.feature <- aggregate(m.dummy[ncol(m.dummy)],by=m.dummy[feature],FUN=sum)
    m.dummy.feature$feature <- feature
    colnames(m.dummy.feature)[1] <- "bin"
    m.dummy.features <- rbind(m.dummy.features, m.dummy.feature)
  }
  
  m.dummy.features$feature <- factor(m.dummy.features$feature)
  m.dummy.features$bin <- factor(m.dummy.features$bin)
  
  colnames(m.dummy.features)[2] <- "model.dummy"
  m.dummy.features$utterance <- utterance
  
  m.compare.features <- join(m.features, m.noAlt.features, by=c("feature", "bin", "utterance"), type="inner")
  m.compare.features <- join(m.compare.features, m.noAltUtts.features, by=c("feature", "bin", "utterance"))
  m.compare.features <- join(m.compare.features, m.dummy.features, by=c("feature", "bin", "utterance"))
  m.compare.features <- join(m.compare.features, man.prior, by=c("feature", "bin"), type="inner")
  
  m.compare.features.long <- gather(m.compare.features, model, prob, c(model.full, model.dummy, model.noAltFeatures, model.noAltUtts, prior))
  m.compare.features.long$utterance <- utterance
  m.compare.features.long$featureNum <- factor(m.compare.features.long$feature, labels=c("f1", "f2"))
  m.compare.features.long$featureNum <- factor(m.compare.features.long$featureNum)
  
  models <- rbind(models, m.compare.features.long)
}

ggplot(models, aes(x=bin, y=prob, color=model)) +
  #geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_point() +
  geom_line(aes(group=model)) +
  facet_grid(featureNum~utterance) +
  theme_bw() +
  geom_text(aes(x=1, y=2, label=feature, group=utterance), color="black") +
  scale_color_manual(values=c("#d95f02", "gray", "#1b9e77", "#7570b3", "black"))

ggplot(subset(models, model=="model.full" | model=="model.dummy" | model=="prior"), aes(x=bin, y=prob, color=model)) +
  #geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_point() +
  #geom_line(aes(group=model), position=position_jitter(w=0.2, h=0)) +
  facet_grid(featureNum~utterance) +
  theme_bw() +
  geom_text(aes(x=1, y=2, label=feature, group=utterance), color="black") +
  scale_color_manual(values=c("#d95f02", "#1b9e77","black"))


#############
# Compare with different alternatives -> 6 bins
#############
numBins <- 6
alpha <- 2
utterance <- "ant"

p$bin <- cut(p$response, breaks=numBins, labels=seq(from=0, to=numBins-1, by=1))
p$feature_animal <- paste(p$featureID, p$feature, p$animal, sep="_")
p.hist <- with(p, table(feature_animal, bin)) + 1 #laplace smoothing
p.hist <- as.data.frame(prop.table(p.hist, margin = 1))

p.hist <- separate(p.hist, feature_animal, c("featureID", "feature", "animal"), "_")

p.hist <- p.hist[with(p.hist, order(featureID, animal)), ]

man.prior <- subset(p.hist, animal=="man")
man.prior$bin <- factor(man.prior$bin)
man.prior$animal <- NULL
colnames(man.prior)[4] <- "prior"

models <- data.frame(utterance=NULL, feature=NULL, bin=NULL, prob=NULL, featureID=NULL, featureNum=NULL, model=NULL)

for (utterance in animals$animal) {
  m.noAlt <- read.csv(paste("../../Model/SeedingModel/CoreAnimalsOutput/", 
                            utterance, "_", numBins, "_", alpha, "_noAltFeatures.csv", sep=""))
  m.noAlt.features <- data.frame(feature=NULL, bin=NULL, prob=NULL)
  for (feature in colnames(m.noAlt)[3:ncol(m.noAlt)-1]) {
    m.noAlt.feature <- aggregate(m.noAlt[ncol(m.noAlt)],by=m.noAlt[feature],FUN=sum)
    m.noAlt.feature$feature <- feature
    colnames(m.noAlt.feature)[1] <- "bin"
    m.noAlt.features <- rbind(m.noAlt.features, m.noAlt.feature)
  }
  
  m.noAlt.features$feature <- factor(m.noAlt.features$feature)
  m.noAlt.features$bin <- factor(m.noAlt.features$bin)
  colnames(m.noAlt.features)[2] <- "model.noAltFeatures"
  m.noAlt.features$utterance <- utterance
  
  m.noAltUtts <- read.csv(paste("../../Model/SeedingModel/CoreAnimalsOutput/", 
                                utterance, "_", numBins, "_", alpha, "_noAltUtts.csv", sep=""))
  m.noAltUtts.features <- data.frame(feature=NULL, bin=NULL, prob=NULL)
  for (feature in colnames(m.noAltUtts)[3:ncol(m.noAltUtts)-1]) {
    m.noAltUtts.feature <- aggregate(m.noAltUtts[ncol(m.noAltUtts)],by=m.noAltUtts[feature],FUN=sum)
    m.noAltUtts.feature$feature <- feature
    colnames(m.noAltUtts.feature)[1] <- "bin"
    m.noAltUtts.features <- rbind(m.noAltUtts.features, m.noAltUtts.feature)
  }
  
  m.noAltUtts.features$feature <- factor(m.noAltUtts.features$feature)
  m.noAltUtts.features$bin <- factor(m.noAltUtts.features$bin)
  colnames(m.noAltUtts.features)[2] <- "model.noAltUtts"
  m.noAltUtts.features$utterance <- utterance
  
  
  m.compare.features <- join(m.noAlt.features, m.noAltUtts.features, by=c("feature", "bin", "utterance"), type="inner")
  m.compare.features <- join(m.compare.features, man.prior, by=c("feature", "bin"), type="inner")
  m.compare.features.long <- gather(m.compare.features, model, prob, c(model.noAltFeatures, model.noAltUtts, prior))
  m.compare.features.long$utterance <- utterance
  m.compare.features.long$featureNum <- factor(m.compare.features.long$feature, labels=c("f1", "f2"))
  m.compare.features.long$featureNum <- factor(m.compare.features.long$featureNum)
  
  models <- rbind(models, m.compare.features.long)
}

ggplot(models, aes(x=bin, y=prob, color=model)) +
  #geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_point() +
  geom_line(aes(group=model)) +
  facet_grid(featureNum~utterance) +
  theme_bw() +
  geom_text(aes(x=1, y=2, label=feature, group=utterance), color="black") +
  scale_color_manual(values=c("#1b9e77", "#7570b3", "gray"))

###############################
# Compare dummy alternative features vs real alternative features
###############################
alpha <- 1
numBins <- 3
utterance <- "panda"
m.full <- read.csv(paste("../../Model/SeedingModel/CoreAnimalsOutput/", 
                    utterance, "_", numBins, "_", alpha, ".csv", sep=""), header=FALSE)
colnames(m.full)[ncol(m.full)] <- "prob"
features <- unlist(strsplit(as.character(subset(animals, animal==utterance)$features), ';')[1])
colnames(m.full) <- c("category", features, "prob")
m.full.features <- data.frame(feature=NULL, bin=NULL, prob=NULL)
for (feature in features) {
  m.full.feature <- aggregate(m.full[ncol(m.full)],by=m.full[feature],FUN=sum)
  m.full.feature$feature <- feature
  colnames(m.full.feature)[1] <- "bin"
  m.full.features <- rbind(m.full.features, m.full.feature)
}

m.full.features$feature <- factor(m.full.features$feature)
m.full.features$bin <- factor(m.full.features$bin)

colnames(m.full.features)[2] <- "model.full"
m.full.features$utterance <- utterance

m.dummy <- read.csv(paste("../../Model/SeedingModel/CoreAnimalsOutput/", 
                              utterance, "_", numBins, "_", alpha, "_dummyAltFeatures.csv", sep=""))
m.dummy.features <- data.frame(feature=NULL, bin=NULL, prob=NULL)
for (feature in colnames(m.dummy)[3:ncol(m.dummy)-1]) {
  m.dummy.feature <- aggregate(m.dummy[ncol(m.dummy)],by=m.dummy[feature],FUN=sum)
  m.dummy.feature$feature <- feature
  colnames(m.dummy.feature)[1] <- "bin"
  m.dummy.features <- rbind(m.dummy.features, m.dummy.feature)
}

m.dummy.features$feature <- factor(m.dummy.features$feature)
m.dummy.features$bin <- factor(m.dummy.features$bin)

colnames(m.dummy.features)[2] <- "model.dummy"
m.dummy.features$utterance <- utterance

m.compare.features <- join(m.full.features, m.dummy.features, by=c("feature", "bin", "utterance"), type="inner")
m.compare.features <- join(m.compare.features, man.prior, by=c("feature", "bin"), type="inner")
m.compare.features.long <- gather(m.compare.features, model, prob, c(model.full, model.dummy, prior))
m.compare.features.long$utterance <- utterance

#ggplot(subset(m.compare.features.long, feature %in% c("slow", "strong")), aes(x=bin, y=prob, color=model)) +
ggplot(m.compare.features.long, aes(x=bin, y=prob, color=model)) +
  #geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_point() +
  geom_line(aes(group=model)) +
  facet_wrap(~feature, ncol=3) +
  theme_bw() +
  geom_text(aes(x=1, y=2, label=feature, group=utterance), color="black") +
  scale_color_manual(values=c("#1b9e77", "#7570b3", "gray"))

###############################
# Compare different bin numbers
###############################

# Construct outputs for binNum = 3, with no alternative features
numBins.1 <- 3

outputs.1 <- data.frame(utterance=NULL, feature=NULL, bin.1=NULL, prob=NULL)

for (utterance in animals$animal) {
  m1 <- read.csv(paste("../../Model/SeedingModel/CoreAnimalsOutput/", 
                       utterance, "_", numBins.1, "_", alpha, "_noAltUtts.csv", sep=""))
  m1.features <- data.frame(utterance=NULL, feature=NULL, bin.1=NULL, prob=NULL)
  for (feature in colnames(m1)[3:ncol(m1)-1]) {
    m1.feature <- aggregate(m1[ncol(m1)],by=m1[feature],FUN=sum)
    m1.feature$feature <- feature
    colnames(m1.feature)[1] <- "bin.1"
    m1.features <- rbind(m1.features, m1.feature)
  }
  m1.features$utterance <- utterance
  outputs.1 <- rbind(outputs.1, m1.features)
}

# Construct outputs for binNum = 6, with no alternative features
numBins.2 <- 6

outputs.2 <- data.frame(utterance=NULL, feature=NULL, bin.2=NULL, prob=NULL)

for (utterance in animals$animal) {
  m2 <- read.csv(paste("../../Model/SeedingModel/CoreAnimalsOutput/", 
                       utterance, "_", numBins.2, "_", alpha, "_noAltUtts.csv", sep=""))
  m2.features <- data.frame(utterance=NULL, feature=NULL, bin.2=NULL, prob=NULL)
  for (feature in colnames(m2)[3:ncol(m2)-1]) {
    m2.feature <- aggregate(m2[ncol(m2)],by=m2[feature],FUN=sum)
    m2.feature$feature <- feature
    colnames(m2.feature)[1] <- "bin.2"
    m2.features <- rbind(m2.features, m2.feature)
  }
  m2.features$utterance <- utterance
  outputs.2 <- rbind(outputs.2, m2.features)
}

outputs.2$bin.1 <- ifelse(outputs.2$bin.2 <= 1, 0,
                          ifelse(outputs.2$bin.2 <= 3, 1, 2))

outputs.2$bin.1 <- factor(outputs.2$bin.1)
outputs.1$bin.1 <- factor(outputs.1$bin.1)

outputs.2.collapsed <- aggregate(data=outputs.2, prob ~ utterance + feature + bin.1, FUN=sum)
outputs.2.collapsed <- rename(outputs.2.collapsed, c("prob"="collapsed.prob"))

outputs.compare <- join(outputs.1, outputs.2.collapsed, by=c("utterance", "feature", "bin.1"))

with(outputs.compare, cor.test(prob, collapsed.prob))

ggplot(outputs.compare, aes(x=prob, y=collapsed.prob, color=bin.1)) +
  geom_point() +
  theme_bw()
