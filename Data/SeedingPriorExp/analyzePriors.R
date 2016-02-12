library(ggplot2)
library(reshape2)
library(plyr)
library(tidyr)
library(ggbiplot)
source("~/Dropbox/Work/Grad_school/Research/Utilities/summarySE.R")



p <- read.csv("../../mTurkScripts/SeedingPriorExp/LaunchPriors/priors-trials.csv")
# Remove subjects with NAs
remove.workerIDs <- unique(subset(p, is.na(response))$workerid)

p <- subset(p, !workerid %in% remove.workerIDs)

p$feature <- factor(p$feature)
p$animal <- factor(p$animal)
p$z <- ave(p$response, p$workerid, FUN=scale)

p.summary <- summarySE(p, measurevar="response", groupvars=c("featureID", "feature", "animal"))

p.summary <- transform(p.summary, animal=reorder(animal, -response))

ggplot(p.summary, aes(x=reorder(animal, response), y=response)) +
  geom_point() +
  geom_errorbar(aes(ymin=response-ci, ymax=response+ci), width=0.05) +
  theme_bw() +
  facet_wrap(~feature, scales="free_x", ncol=5)

feature.summary <- subset(p.summary, feature=="striped")
feature.summary <- transform(feature.summary, animal=reorder(animal, -response))

ggplot(feature.summary, aes(x=animal, y=response)) +
  geom_point() +
  geom_errorbar(aes(ymin=response-ci, ymax=response+ci), width=0.05) +
  theme_bw() +
  ggtitle(feature.summary$feature)

with(p, cor.test(response, z))

ggplot(p, aes(x=response, y=z, color=factor(workerid))) +
  geom_point() +
  theme_bw()

######################
# Binned histograms
######################
numBins <- 6
p$bin <- cut(p$response, breaks=numBins, labels=seq(from=0, to=numBins-1, by=1))
p$feature_animal <- paste(p$featureID, p$feature, p$animal, sep="_")
p.hist <- with(p, table(feature_animal, bin)) + 1 #laplace smoothing
p.hist <- as.data.frame(prop.table(p.hist, margin = 1))

p.hist <- separate(p.hist, feature_animal, c("featureID", "feature", "animal"), "_")

p.hist <- p.hist[with(p.hist, order(featureID, animal)), ]

ggplot(subset(p.hist, animal=="ant"), aes(x=bin, y=Freq, color=feature)) +
  geom_point() +
  geom_line(aes(group=feature)) +
  facet_wrap(~animal, ncol=4) +
  theme_bw()

p.hist.wide <- reshape(p.hist, direction="wide", idvar=c("featureID", "feature", "animal"), timevar="bin", v.names="Freq")

write.csv(p.hist.wide, "../SeedingPriorExp/priors_6bins.csv", row.names=FALSE, quote=FALSE)

