library(ggplot2)
library(reshape2)
library(plyr)
library(lme4)
source("~/Dropbox/Work/Grad_school/Research/Utilities/summarySE.R")

#########################################
# Priors
#########################################

p <- read.csv("../Data/PsychReviewExps/prior1-trials.csv")
# Calculate denominator for normalizing
p.denom <- aggregate(data=p, response ~ workerid + animal + alternative, FUN=sum)
colnames(p.denom)[4] <- "denom"
p <- join(p, p.denom, by=c("workerid", "animal", "alternative"))

# If the denominator is 0, remove
p <- subset(p, denom > 0)
p$prior <- p$response / p$denom
p$f1 <- ifelse(p$setNum %in% c(1, 2), 1, 0)
p$f2 <- ifelse(p$setNum %in% c(1, 3), 1, 0)
p$setNum <- factor(p$setNum, labels=c("1,1", "1,0", "0,1", "0,0"))

ggplot(p, aes(x=categoryID, y=prior, color=categoryID)) +
  geom_point() +
  facet_wrap(~workerid) +
  theme_bw()

# Summarize
p.summary <- summarySE(p, measurevar="prior", 
                       groupvars=c("animal", "alternative", "setNum", "featureSet"))

ggplot(p.summary, aes(x=setNum, y=prior)) +
  geom_bar(stat="identity", fill="gray", color="black") +
  geom_errorbar(aes(ymin=prior-se, ymax=prior+se)) +
  facet_wrap(animal~alternative, ncol=6) +
  theme_bw()

# Turn into wide form for printing
p.summary.wide <- reshape(p.summary, 
                     timevar = "setNum",
                     idvar = c("animal", "alternative"),
                     drop = c("featureSet", "N", "sd", "se", "ci"),
                     direction = "wide")

colnames(p.summary.wide)[3:6] <- c("set1", "set2", "set3", "set4")

for (a in unique(p.summary.wide$animal)) {
  p.subset <- subset(p.summary.wide, animal==a)
  p.subset$animal <- NULL
  write.csv(p.subset, paste("../Data/PsychReviewExps/Priors/priors_mean_", a, ".csv", sep=""), 
            quote=FALSE, row.names=FALSE)
}


# Get marginal of features
p.f1.marginal <- aggregate(data=subset(p, f1==1), prior ~ workerid + animal + categoryID +
                             alternative, FUN=sum)
p.f1.marginal$feature <- "f1"

p.f2.marginal <- aggregate(data=subset(p, f2==1), prior ~ workerid + animal + categoryID +
                             alternative, FUN=sum)
p.f2.marginal$feature <- "f2"

p.marginal <- rbind(p.f1.marginal, p.f2.marginal)

p.marginal.summary <- summarySE(p.marginal, measurevar="prior",
                                groupvars=c("animal", "categoryID",
                                            "alternative", "feature"))

ggplot(p.marginal.summary, aes(x=feature, y=prior)) +
  geom_bar(stat="identity", fill="gray", color="black") +
  geom_errorbar(aes(ymin=prior-se, ymax=prior+se), width=0.2) +
  facet_wrap(animal~alternative) +
  theme_bw()

# Turn into wide format
p.f1.marginal.summary <- summarySE(p.f1.marginal, measurevar="prior",
                                   groupvars=c("animal", "categoryID",
                                               "alternative"))

p.f2.marginal.summary <- summarySE(p.f2.marginal, measurevar="prior",
                                   groupvars=c("animal", "categoryID",
                                               "alternative"))

colnames(p.f1.marginal.summary)[5:8] <- c("f1", "f1.sd", "f1.se", "f1.ci")
colnames(p.f2.marginal.summary)[5:8] <- c("f2", "f2.sd", "f2.se", "f2.ci")

p.marginal.summary.wide <- join(p.f1.marginal.summary, p.f2.marginal.summary,
                                by=c("animal", "categoryID", "alternative"))

p.marginal.summary.wide$animalType <- 
  ifelse(as.character(p.marginal.summary.wide$animal)==
           as.character(p.marginal.summary.wide$alternative),
                                             "orig", "alt")

ggplot(p.marginal.summary.wide, aes(x=f1, y=f2, color=animalType)) +
  geom_point() +
  geom_errorbar(aes(ymin=f2-f2.se, ymax=f2+f2.se), width=0.01) +
  geom_errorbarh(aes(xmin=f1-f1.se, xmax=f1+f1.se), height=0.01) +
  theme_bw()

##############################################
# Interpretation
##############################################

d <- read.csv("../Data/PsychReviewExps/interp1-trials.csv")
colnames(d)[4] <- "alternative"

# Calculate denominator for normalizing
d.denom <- aggregate(data=d, response ~ workerid + utteranceType + animal + alternative + QUD, FUN=sum)
colnames(d.denom)[6] <- "denom"
d <- join(d, d.denom, by=c("workerid", "utteranceType", "animal", "alternative", "QUD"))

# If the denominator is 0, remove
d <- subset(d, denom > 0)
d$interp <- d$response / d$denom
d$f1 <- ifelse(d$setNum %in% c(1, 2), 1, 0)
d$f2 <- ifelse(d$setNum %in% c(1, 3), 1, 0)
d$setNum <- factor(d$setNum, labels=c("1,1", "1,0", "0,1", "0,0"))

# Summarize
d.summary <- summarySE(d, measurevar="interp", 
                       groupvars=c("utteranceType", "animalType", "animal",
                                   "alternative", "setNum", "featureSet", "QUD"))

# Each item
ggplot(subset(d.summary, alternative=="whale"), 
       aes(x=setNum, y=interp)) +
  geom_bar(stat="identity", color="black", fill="gray") +
  geom_errorbar(aes(ymin=interp-se, ymax=interp+se), width=0.2) +
  facet_grid(utteranceType ~ QUD) +
  theme_bw()

# Only metaphors
ggplot(subset(d.summary, utteranceType=="fig" & animalType=="alt"), 
       aes(x=QUD, y=interp, group=setNum)) +
  geom_bar(stat="identity", color="black", fill="gray", position=position_dodge()) +
  geom_errorbar(aes(ymin=interp-se, ymax=interp+se), width=0.2, position=position_dodge(0.9)) +
  facet_wrap(alternative ~ animal) +
  theme_bw()

# Summarize over all items
d.summary.allItems <- summarySE(d, measurevar="interp", 
                                groupvars=c("utteranceType", "setNum", "QUD", "animalType"))

ggplot(d.summary.allItems, 
       aes(x=QUD, y=interp, fill=setNum)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=interp-se, ymax=interp+se), width=0.2, position=position_dodge(0.9)) +
  facet_grid(animalType ~ utteranceType) +
  theme_bw()

# Get marginal of features
d.f1.marginal <- aggregate(data=subset(d, f1==1), interp ~ 
                             workerid + utteranceType + animalType +
                             alternative + animal + categoryID + 
                             QUD, FUN=sum)
d.f1.marginal$feature <- "f1"

d.f2.marginal <- aggregate(data=subset(d, f2==1), interp ~ 
                             workerid + utteranceType + animalType +
                             alternative + animal + categoryID + 
                             QUD, FUN=sum)
d.f2.marginal$feature <- "f2"

d.marginal <- rbind(d.f1.marginal, d.f2.marginal)

d.marginal.summary <- summarySE(d.marginal, measurevar="interp",
                                groupvars=c("animal", "categoryID",
                                            "alternative", "feature",
                                            "utteranceType", "animalType", "QUD"))

ggplot(subset(d.marginal.summary, alternative=="ant"), aes(x=feature, y=interp)) +
  geom_bar(stat="identity", fill="gray", color="black") +
  geom_errorbar(aes(ymin=interp-se, ymax=interp+se), width=0.2) +
  facet_grid(QUD ~ utteranceType) +
  theme_bw()


d.marginal.summary.allItems <- summarySE(d.marginal, measurevar="interp", 
                                groupvars=c("utteranceType", "QUD", "animalType", "feature"))

ggplot(d.marginal.summary.allItems, 
       aes(x=QUD, y=interp, fill=feature)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=interp-se, ymax=interp+se), width=0.2, position=position_dodge(0.9)) +
  facet_grid(animalType ~ utteranceType) +
  theme_bw()

# Get all animal/alternative pairs
amalt <- unique(data.frame(animal=d$animal, alternative=d$alternative))

########################
# Check whether priors predict interp
########################
# Mean priors for all features for men
p.men <- subset(p.summary, alternative=="man")
# Mean priors for features for all other animals
p.animals <- subset(p.summary, alternative != "man")

colnames(p.men)[6] <- "prior.man"
colnames(p.animals)[6] <- "prior.animal"

p.men$sd <- NULL
p.men$se <- NULL
p.men$N <- NULL
p.men$ci <- NULL
p.men$alternative <- NULL
p.animals$sd <- NULL
p.animals$se <- NULL
p.animals$N <- NULL
p.animals$ci <- NULL

# Join priors with interp
d.interp.priors <- join(d.summary, p.men, by=c("animal", "setNum", "featureSet"))
d.interp.priors <- join(d.interp.priors, p.animals, by=c("animal", "alternative", "setNum", "featureSet"))

# Only look at metaphors
d.interp.priors.fig <- subset(d.interp.priors, utteranceType=="fig")

# Correlation between animal prior and interpretation = 0.799
with(d.interp.priors.fig, cor.test(interp, prior.animal))
ggplot(d.interp.priors.fig, aes(x=prior.animal, y=interp, color=QUD)) +
  geom_text(aes(label=alternative)) +
  theme_bw() +
  facet_wrap(~setNum)

with(subset(d.interp.priors.fig, QUD=="f1"), cor.test(interp, prior.animal))
with(subset(d.interp.priors.fig, QUD=="f2"), cor.test(interp, prior.animal))
with(subset(d.interp.priors.fig, QUD=="gen"), cor.test(prior.animal, prior.man))

# R^2 with animal and man prior (additive) = 0.64, r = 0.8
summary(lm(data=d.interp.priors.fig, interp ~ prior.animal + prior.man))

# R^2 with animal and man prior (interactive) = 0.6429, r = 0.801
summary(lm(data=d.interp.priors.fig, interp ~ prior.animal * prior.man))

# R^2 with animal and man prior and QUD (additive) = 0.6376, r=0.798
summary(lm(data=d.interp.priors.fig, interp ~ prior.animal + prior.man + QUD))

# R^2 with animal and QUD (interactive) = 0.634, r=0.796
summary(lm(data=d.interp.priors.fig, interp ~ prior.animal * QUD))


###################################
# Model
####################################

# Model without alternative utterances, general QUD
f.genQ_noAlt <- read.csv("../Model/PsychReviewModels/Output/f_a1_genQ_noAlt.txt", header=FALSE)
m.genQ_noAlt <- data.frame()
for (f in f.genQ_noAlt$V1) {
  m <- read.csv(paste("../Model/PsychReviewModels/Output/", f, sep=""), header=FALSE)
  m.genQ_noAlt <- rbind(m, m.genQ_noAlt)
}

colnames(m.genQ_noAlt) <- c("featureSource", "utterance", "category", "f1", "f2", "QUD", "modelProb")

# Aggregate across goals, just look at features
m.genQ_noAlt.marginalQ <- aggregate(data=m.genQ_noAlt, 
                                    modelProb ~ featureSource + utterance + f1 + f2, FUN=sum)
m.genQ_noAlt.marginalQ$setNum <- paste(m.genQ_noAlt.marginalQ$f1, m.genQ_noAlt.marginalQ$f2, sep=",")
m.genQ_noAlt.marginalQ$setNum <- factor(m.genQ_noAlt.marginalQ$setNum, 
                                        levels=c("1,1","1,0", "0,1", "0,0"))

ggplot(subset(m.genQ_noAlt.marginalQ, !utterance %in% c("f1", "f2"))
       , aes(x=setNum, y=modelProb, fill=setNum)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  theme_bw() +
  facet_wrap(featureSource ~ utterance)

# Human interp for metaphor and general QUD
d.interp.priors.fig.genQ <- subset(d.interp.priors.fig, QUD=="gen")

ggplot(d.interp.priors.fig.genQ, aes(x=setNum, y=interp, fill=setNum)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=interp-se, ymax=interp+se), width=0.05, position=position_dodge(0.9)) +
  theme_bw() +
  facet_wrap(animal ~ alternative)

colnames(d.interp.priors.fig.genQ)[3:4] <- c("featureSource", "utterance")

d.interp.fig.genQ.modelComp <- join(d.interp.priors.fig.genQ, m.genQ_noAlt.marginalQ,
                                    by=c("featureSource", "utterance", "setNum"))

with(d.interp.fig.genQ.modelComp, cor.test(modelProb, interp))
with(d.interp.fig.genQ.modelComp, cor.test(interp, prior.animal))

ggplot(d.interp.fig.genQ.modelComp, aes(x=prior.animal, y=interp, color=setNum)) +
  geom_text(aes(label=utterance)) +
  theme_bw()

# Model WITH alternative utterances, general QUD
f.genQ_figAlt <- read.csv("../Model/PsychReviewModels/Output/f_a5_genQ_figAlt.txt", header=FALSE)
m.genQ_figAlt <- data.frame()
for (f in f.genQ_figAlt$V1) {
  m <- read.csv(paste("../Model/PsychReviewModels/Output/", f, sep=""), header=FALSE)
  m.genQ_figAlt <- rbind(m, m.genQ_figAlt)
}

colnames(m.genQ_figAlt) <- c("featureSource", "utterance", "category", "f1", "f2", "QUD", "modelProb_alt")

# Aggregate across goals, just look at features
m.genQ_figAlt.marginalQ <- aggregate(data=m.genQ_figAlt, 
                                    modelProb_alt ~ featureSource + utterance + f1 + f2, FUN=sum)
m.genQ_figAlt.marginalQ$setNum <- paste(m.genQ_figAlt.marginalQ$f1, m.genQ_figAlt.marginalQ$f2, sep=",")
m.genQ_figAlt.marginalQ$setNum <- factor(m.genQ_figAlt.marginalQ$setNum, 
                                        levels=c("1,1","1,0", "0,1", "0,0"))



d.interp.fig.genQ.modelComp <- join(d.interp.fig.genQ.modelComp, m.genQ_figAlt.marginalQ,
                                    by=c("featureSource", "utterance", "setNum", "f1", "f2"))

ggplot(subset(d.interp.fig.genQ.modelComp, !utterance %in% c("f1", "f2"))
       , aes(x=setNum, y=modelProb_alt, fill=setNum)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  theme_bw() +
  facet_wrap(featureSource ~ utterance)

ggplot(subset(d.interp.fig.genQ.modelComp, !utterance %in% c("f1", "f2"))
       , aes(x=setNum, y=interp, fill=setNum)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  theme_bw() +
  facet_wrap(featureSource ~ utterance)

with(d.interp.fig.genQ.modelComp, cor.test(modelProb, interp))
with(d.interp.fig.genQ.modelComp, cor.test(interp, prior.animal))
with(d.interp.fig.genQ.modelComp, cor.test(modelProb, modelProb_alt))
with(subset(d.interp.fig.genQ.modelComp, animalType=="alt"), cor.test(interp, modelProb))

ggplot(d.interp.fig.genQ.modelComp, aes(x=modelProb_alt, y=interp, color=featureSource)) +
  geom_text(aes(label=utterance)) +
  theme_bw() +
  facet_wrap(~setNum)

ggplot(d.interp.fig.genQ.modelComp, aes(x=modelProb_alt, y=interp, color=setNum)) +
  geom_text(aes(label=utterance)) +
  theme_bw()

ggplot(d.interp.fig.genQ.modelComp, aes(x=prior.animal, y=interp, color=setNum)) +
  geom_text(aes(label=utterance)) +
  theme_bw()

ggplot(d.interp.fig.genQ.modelComp, aes(x=modelProb, y=interp, color=setNum)) +
  geom_text(aes(label=utterance)) +
  theme_bw()

ggplot(d.interp.fig.genQ.modelComp, aes(x=modelProb_alt, y=modelProb, color=setNum)) +
  geom_text(aes(label=utterance)) +
  theme_bw()


###############################
# Scalar free interp
###############################
s <- read.csv("../Data/PsychReviewExps/scalarFree1_long.csv")
s.summary <- summarySE(s, measurevar="response", 
                       groupvars=c("item", "utteranceType", "quality", "dimension",
                                   "describedGender"))

ggplot(s.summary, aes(x=describedGender, y=response, fill=utteranceType)) +
    geom_bar(stat="identity", color="black", position=position_dodge()) +
    geom_errorbar(aes(ymin=response-se, ymax=response+se), 
                  position=position_dodge(0.9), width=0.2) +
    theme_bw() +
    facet_grid(quality ~., scales="free")

ggplot(subset(s, describedGender=="woman"), aes(x=response, fill=utteranceType)) +
  geom_bar(stat="count", color="black") +
  theme_bw() +
  facet_grid(utteranceType ~ quality, scales="free")

t.test(subset(s, quality=="tall" & utteranceType=="fig" & describedGender=="woman")$response, 
       subset(s, quality=="tall" & utteranceType=="lit" & describedGender=="woman")$response)
