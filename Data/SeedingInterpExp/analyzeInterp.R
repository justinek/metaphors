library(ggplot2)
library(reshape2)
library(plyr)
library(tidyr)
library(ggbiplot)
source("~/Dropbox/Work/Grad_school/Research/Utilities/summarySE.R")

d <- read.csv("../../mTurkScripts/SeedingInterpExp/LaunchInterp_core_compare_assoc/interpCoreCompare-trials.csv")
d$feature <- factor(d$feature)
d$animal <- factor(d$animal)

d.summary <- summarySE(d, measurevar="response", groupvars=c("feature", "animal", "alternative"))

d.animal <- subset(d.summary, animal=="ant")
d.animal <- transform(d.animal, animal=reorder(alternative, -response))

ggplot(d.animal, aes(x=alternative, y=response)) +
  geom_point() +
  geom_errorbar(aes(ymin=response-ci, ymax=response+ci), width=0.05) +
  theme_bw() +
  facet_grid(.~feature)

ggplot(d.summary, aes(x=alternative, y=response)) +
  geom_point() +
  geom_errorbar(aes(ymin=response-ci, ymax=response+ci), width=0.05) +
  theme_bw() +
  facet_grid(feature~animal, scales="free_x")

p <- read.csv("../../mTurkScripts/SeedingPriorExp/LaunchPriors/priors-trials.csv")
# Remove subjects with NAs
remove.workerIDs <- unique(subset(p, is.na(response))$workerid)
p <- subset(p, !workerid %in% remove.workerIDs)

p$feature <- factor(p$feature)
p$animal <- factor(p$animal)
p$z <- ave(p$response, p$workerid, FUN=scale)

p.summary <- summarySE(p, measurevar="response", groupvars=c("featureID", "feature", "animal"))
p.humans <- subset(p.summary, animal=="man" & feature %in% d.summary$feature)
p.humans$type <- "prior"
p.humans$featureID <- NULL

d.summary$type <- "posterior"
prior.posterior <- rbind(d.summary, p.humans)

ggplot(prior.posterior, aes(x=feature, y=response)) +
  geom_point() +
  geom_errorbar(aes(ymin=response-ci, ymax=response+ci), width=0.05) +
  theme_bw() +
  facet_wrap(~animal, scales="free_x", ncol=5)


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

p.hist.wide <- reshape(p.hist, direction="wide", idvar=c("featureID", "feature", "animal"), timevar="bin", v.names="Freq")

