library(ggplot2)
library(reshape2)
library(plyr)
library(tidyr)
#library(ggbiplot)
source("~/Dropbox/Work/Grad_school/Research/Utilities/summarySE.R")

###################
# utterance can be literal adjective or metaphor
###################
d <- read.csv("../../mTurkScripts/SeedingInterpExp/LaunchInterp_allFeatures_litfig/allFeatures_litfig-trials.csv")
d.summary <- summarySE(d, measurevar="response", groupvars=c("animalID", "animal", "utteranceType", "utterance", "alternative", "feature"))

d.animal <- subset(d.summary, animalID==1 & (alternative=="average man" | alternative == "man"))

ggplot(d.animal, aes(x=utterance, y=response, fill=alternative)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=response-se, ymax=response+se), width=0.2, position=position_dodge(0.9)) +
  theme_bw() +
  facet_wrap(~ feature, ncol=4) +
  ggtitle(d.animal$animal)

####################
# Utterances are all metaphors
####################
d <- read.csv("../../mTurkScripts/SeedingInterpExp/LaunchInterp_allFeatures/allFeatures-trials.csv")
d.summary <- summarySE(d, measurevar="response", groupvars=c("animalID", "utterance", "alternative", "feature"))
d.animal <- subset(d.summary, animalID==2 & (alternative=="average man" | alternative == "man"))

ggplot(d.animal, aes(x=alternative, y=response)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=response-se, ymax=response+se), width=0.2, position=position_dodge(0.9)) +
  theme_bw() +
  facet_wrap(~ feature, ncol=4) +
  ggtitle(d.animal$utterance)

####
# Bin into histograms
####

numBins <- 6
d$bin <- cut(d$response, breaks=numBins, labels=seq(from=0, to=numBins-1, by=1))
d$utterance_alternative_feature <- paste(d$utterance, d$alternative, d$feature, sep="_")
d.hist <- with(d, table(utterance_alternative_feature, bin)) + 1 #laplace smoothing
d.hist <- as.data.frame(prop.table(d.hist, margin = 1))

d.hist <- separate(d.hist, utterance_alternative_feature, c("utterance", "alternative", "feature"), "_")

d.hist <- d.hist[with(d.hist, order(utterance, feature, alternative)), ]

ggplot(subset(d.hist, utterance=="small"), aes(x=bin, y=Freq, color=feature)) +
  geom_point() +
  geom_line(aes(group=feature)) +
  facet_grid(feature~alternative) +
  theme_bw()
