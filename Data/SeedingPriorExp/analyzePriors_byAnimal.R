library(ggplot2)
library(reshape2)
#library(plyr)
library(tidyr)
source("~/Dropbox/Work/Grad_school/Research/Utilities/summarySE.R")

p <- read.csv("../../mTurkScripts/SeedingPriorExp/LaunchPriors_byAnimal/priors-trials.csv")

p.summary <- summarySE(p, measurevar="response", groupvars=c("animalID", "animal", "feature"))

byAnimal.summary.subset <- subset(p.summary, animalID==2)
byAnimal.summary.subset <- transform(byAnimal.summary.subset, feature=reorder(feature, -response))
ggplot(byAnimal.summary.subset, aes(x=feature, y=response)) +
  geom_point() +
  geom_errorbar(aes(ymin=response-se, ymax=response+se), width=0.05) +
  theme_bw() +
  ggtitle(byAnimal.summary.subset$animal)

byFeature.summary.subset <- subset(p.summary, feature=="striped")
byFeature.summary.subset <- transform(byFeature.summary.subset, animal=reorder(animal, -response))
ggplot(byFeature.summary.subset, aes(x=animal, y=response)) +
  geom_point() +
  geom_errorbar(aes(ymin=response-se, ymax=response+se), width=0.05) +
  theme_bw() +
  ggtitle(byFeature.summary.subset$feature)

####
# Bin into histograms
####

numBins <- 5
p$bin <- cut(p$response, breaks=numBins, labels=seq(from=0, to=numBins-1, by=1))
p$animal_feature <- paste(p$animal, p$feature, sep="_")
p.hist <- with(p, table(animal_feature, bin)) + 1 #laplace smoothing
p.hist <- as.data.frame(prop.table(p.hist, margin = 1))

p.hist <- separate(p.hist, animal_feature, c("animal", "feature"), "_")

p.hist <- p.hist[with(p.hist, order(animal, feature)), ]

ggplot(subset(p.hist, animal=="whale"), aes(x=bin, y=Freq, color=feature)) +
  geom_point() +
  geom_line(aes(group=feature)) +
  facet_wrap(~feature, ncol=4) +
  theme_bw()

p.hist.wide <- reshape(p.hist,direction="wide", idvar=c("animal", "feature"), timevar="bin", v.names="Freq")

write.csv(p.hist.wide, "priors_byAnimal_5bins.csv", row.names=FALSE, quote=FALSE)
