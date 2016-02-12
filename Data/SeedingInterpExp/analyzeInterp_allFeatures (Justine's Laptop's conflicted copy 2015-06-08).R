library(ggplot2)
library(reshape2)
library(plyr)
library(tidyr)
library(ggbiplot)
source("~/Dropbox/Work/Grad_school/Research/Utilities/summarySE.R")

d <- read.csv("../../mTurkScripts/SeedingInterpExp/LaunchInterp_allFeatures/allFeatures-trials.csv")
d.clean <- d[complete.cases(d),]

d.summary <- summarySE(d.clean, measurevar="response", groupvars=c("animalID", "utterance", "feature", "alternative"))

d.animal <- subset(d.summary, animalID==10)

ggplot(d.animal, aes(x=alternative, y=response)) +
  geom_bar(stat="identity", color="black", fill="gray") +
  geom_errorbar(aes(ymin=response-se, ymax=response+se), width=0.2) +
  theme_bw() +
  facet_wrap(~feature, ncol=4) +
  ggtitle(d.animal$utterance)

# Find core features for each utterance animal
# Sort features by core vs not
# Sort animals by average man, man, and utterance, vs others

# Find histogram of responses for "man" for each feature/animal
# Compare with histogram of responses for "average man"
# Compare with histogram of responses for prior
