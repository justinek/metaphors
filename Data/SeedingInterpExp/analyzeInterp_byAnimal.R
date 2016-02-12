library(ggplot2)
library(reshape2)
library(plyr)
library(tidyr)
source("~/Dropbox/Work/Grad_school/Research/Utilities/summarySE.R")

d <- read.csv("../../mTurkScripts/SeedingInterpExp/LaunchInterp_byAnimal/interp-trials.csv")
d.summary <- summarySE(d, measurevar="response", 
                       groupvars=c("questionType", "featureType", "animalID", "question", "feature", "animal"))

d.summary$qudFeature <- ifelse(as.character(d.summary$feature) == as.character(d.summary$question), "true", "false")

d.summary.subset <- subset(d.summary, animalID==4)
ggplot(d.summary.subset, aes(x=feature, y=response, fill=qudFeature)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=response-se, ymax=response+se), position=position_dodge(0.9), width=0.2) +
  theme_bw() +
  facet_grid(question ~.) +
  ggtitle(d.summary.subset$animal)

####
# Bin into histograms
####

numBins <- 5
d$bin <- cut(d$response, breaks=numBins, labels=seq(from=0, to=numBins-1, by=1))
d$animal_feature_question <- paste(d$animal, d$feature, d$question, sep="_")
d.hist <- with(d, table(animal_feature_question, bin)) + 1 #laplace smoothing
d.hist <- as.data.frame(prop.table(d.hist, margin = 1))

d.hist <- separate(d.hist, animal_feature_question, c("animal", "feature", "question"), "_")

d.hist <- d.hist[with(d.hist, order(animal, feature, question)), ]

d.hist.subset <- subset(d.hist, animal=="rabbit")

p.hist.subset <- subset(p.hist, animal=="rabbit")
#p.hist.subset$question <- "prior"
colnames(p.hist.subset)[4] <- "prior" 
#p.d.hist.subset <- rbind(p.hist.subset, d.hist.subset)
p.d.hist.subset <- join(p.hist.subset, d.hist.subset, by=c("animal", "feature", "bin"))
p.d.hist.subset.long <-  melt(data=p.d.hist.subset, id.vars=c("animal", "feature", "bin", "question"),
                              measure.vars=c("Freq", "prior"))

ggplot(p.d.hist.subset.long, aes(x=bin, y=value, color=variable)) +
  geom_point() +
  geom_line(aes(group=variable)) +
  facet_grid(question~feature) +
  theme_bw() +
  scale_color_manual(values=c("black", "gray"), labels=c("Interp", "Prior")) +
  ggtitle(unique(p.d.hist.subset.long$animal))

write.csv(d.hist, "interp_byAnimal_5bins.csv", row.names=FALSE, quote=FALSE)
