library(ggplot2)
library(reshape2)
library(plyr)
source("~/Dropbox/Work/Grad_school/Research/Utilities/summarySE.R")

priors <- read.csv("../Data//FeaturePriorExp/FeaturePrior2/data_normalized.csv")
priors.long <- melt(data=priors, id.vars=c("workerID", "gender", "age", "income", "language", "order", "categoryID",
                                           "animal", "condition", "set1", "set2", "set3", "set4"),
                    measure.vars=c("set1prob", "set2prob", "set3prob", "set4prob"))
colnames(priors.long)[14] <- "setNum"
colnames(priors.long)[15] <- "probability"
priors.long$setNumber <- factor(priors.long$setNum, levels=c("set1prob", "set2prob", "set3prob", "set4prob"),
                                labels=c("1;1", "1;0", "0;1", "0;0"))
priors.summary <- summarySE(priors.long, measurevar="probability", groupvars=c("animal", "condition", "setNum"))
ggplot(priors.summary, aes(x=setNum, y=probability, color=condition)) +
  #geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_point(size=2) +
  geom_errorbar(aes(ymin=probability-ci, ymax=probability+ci), width=0.2) +
  geom_line(aes(group=condition)) +
  facet_wrap(~animal, ncol=6) +
  theme_bw()

#################
# Calculate marginals
#################
priors$f1prob <- priors$set1prob + priors$set2prob
priors$f2prob <- priors$set1prob + priors$set3prob
priors.marginal.long <- melt(data=priors, id.vars=c("workerID", "gender", "age", "income", "language", "order", "categoryID",
                                           "animal", "condition", "set1", "set2", "set3", "set4"),
                    measure.vars=c("f1prob", "f2prob"))
colnames(priors.marginal.long)[14] <- "featureNum"
colnames(priors.marginal.long)[15] <- "probability"
priors.marginal.long$featureNum <- factor(priors.marginal.long$featureNum, levels=c("f1prob", "f2prob"),
                                       labels=c("f1", "f2"))

priors.marginal.summary <- summarySE(priors.marginal.long, measurevar="probability", 
                                     groupvars=c("animal", "condition", "featureNum"))

ggplot(priors.marginal.summary, aes(x=featureNum, y=probability, color=condition)) +
  #geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_point(size=2) +
  geom_line(aes(group=condition)) +
  facet_wrap(~animal, ncol=6) +
  theme_bw()