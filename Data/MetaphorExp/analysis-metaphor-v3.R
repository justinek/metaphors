library(ggplot2)
library(reshape2)
library(plyr)
library(lme4)
source("~/Dropbox/Work/Grad_school/Research/Utilities/summarySE.R")
d <- read.csv("data49-long.csv")
nsubjs <- length(unique(d$workerid))
workerid.dict <- data.frame(workerid=unique(d$workerid), anonym=c(0:(nsubjs -1)))
d <- join(workerid.dict, d, by="workerid", type="right")
d$workerid <- NULL
colnames(d)[1] <- "workerid"
d$qud <- ifelse(d$condition==1 | d$condition==2, 0, 1)
d$metaphor <- ifelse(d$condition==1 | d$condition==3, 0, 1)
#########################
# Turn into long form per feature
#########################
d.long <- melt(d, id.vars=c("workerid", "animal", "qud", "metaphor"), 
               measure.vars=c("f1prob", "f2prob", "f3prob"))
colnames(d.long)[5] <- "featureNum"
colnames(d.long)[6] <- "featureProb"
d.long$featureNum <- factor(d.long$featureNum, levels=c("f1prob", "f2prob", "f3prob"),
                            labels=c("1", "2", "3"))
d.long$qud <- factor(d.long$qud, 
                            labels=c("Vague", "Specific"))
d.long$metaphor <- factor(d.long$metaphor, 
                            labels=c("Literal", "Metaphor"))
d.long.summary <- summarySE(d.long, measurevar="featureProb", groupvars=c("featureNum", "qud", "metaphor"))


ggplot(d.long.summary, aes(x=qud, y=featureProb, fill=featureNum)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=featureProb-se, ymax=featureProb+se), width=0.2, position=position_dodge(0.9)) +
  facet_grid(.~metaphor) +
  ylim(c(0, 1)) 

write.csv(d.long, "~/Desktop/metaphor_interp.csv", row.names=FALSE, quote=FALSE)
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
d.summary.summary$qudLabel <- factor(d.summary.summary$qud, labels=c("Vague goal", "Specific goal"))
d.summary.summary$metaphorLabel <- factor(d.summary.summary$metaphor, labels=c("Literal utterance", "Metaphorical utterance"))
my.colors <- c("#990033", "#CC9999", "#FFFFFF")
ggplot(d.summary.summary, aes(x=qudLabel, y=featureProb, fill=featureLabel)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=featureProb-se, ymax=featureProb+se), width=0.2, position=position_dodge(0.9)) +
  facet_grid(.~metaphorLabel) +
  ylim(c(0, 1)) +
  theme_bw() +
  xlab("") +
  ylab("Probability of feature given utterance") +
  #scale_fill_brewer(palette="RdGy", name="Feature")
  scale_fill_manual(values=my.colors, name="Feature") +
  theme(legend.position=c(0.9,0.8))

######################
# Separate data into metaphor and literal
#####################
d.met.summary <- subset(d.summary, metaphor=="1")
d.met.summary$featureNum <- factor(d.met.summary$featureNum)
d.met.summary$qud <- factor(d.met.summary$qud)

d.lit.summary <- subset(d.summary, metaphor=="0")
d.lit.summary$featureNum <- factor(d.lit.summary$featureNum)
d.lit.summary$qud <- factor(d.lit.summary$qud)

############################
# Fit model
############################
# Get all the names of the model files to fit
filenames <- read.csv("../../Model/CogSciModel/combinedOutputFilenames_lambda.txt", header=FALSE)
#filenames <- read.csv("../../Model/CogSciModel/combinedOutputFilenames.txt", header=FALSE)
#filenames <- read.csv("../../Model/LiteralAdjectives/combinedOutputFilenames.txt", header=FALSE)
#filenames <- read.csv("../../Model/CogSciModel/testOutputFilenames.txt", header=FALSE)
cor.table <- data.frame()
max.cor <- 0
max.name <- ""
for (n in filenames$V1) {
  if (grepl("g", n)) {
    name.qud <- n
    name.noQud <- paste("noQud-a", as.list(strsplit(n, "-a"))[[1]][2], sep="")
    m.qud <- read.csv(paste("../../Model/CogSciModel/CombinedOutputLambdaParems/", name.qud, sep=""), header=FALSE)
    m.noQud <- read.csv(paste("../../Model/CogSciModel/CombinedOutputLambdaParems/",name.noQud, sep=""), header=FALSE)
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
    cor.info <- data.frame(name=name.qud, met=cor)
    cor.table <- rbind(cor.table, cor.info)
    if (cor > max.cor) {
      max.cor <- cor
      max.name <- name.qud
      best <- compare
      best.model <- m
      best.marginals <- m.marginals
    }
  }
}
with(best, cor.test(featureProb, modelProb))
cor.table <- cor.table[with(cor.table, order(-met)), ]

best.marginals <- join(best.marginals, d.met.summary)
best.marginals$N <- NULL
best.marginals$featureProb <- NULL
best.marginals$sd <- NULL
best.marginals$se <- NULL
best.marginals$ci <- NULL

write.csv(best.marginals, "~/Desktop/metaphor_model.csv", row.names=FALSE, quote=FALSE)

#######################
# Fit model with literal adjectives
#######################
# Get all the names of the model files to fit
filenames <- read.csv("../../Model/CogSciModelWithLitAdjs/combinedOutputFilenames_complexQp_compose.txt", header=FALSE)

cor.table <- data.frame()
cor.best <- 0
name.best <- ""
#filenames$V1 <- "g0.5-a1.csv"
for (n in filenames$V1) {
  if (grepl("g", n)) {
    name.qud <- n
    name.noQud <- paste("noQud-a", as.list(strsplit(n, "a"))[[1]][2], sep="")
    m.qud.met <- read.csv(paste("../../Model/CogSciModelWithLitAdjs/CombinedOutputMetaphor/", name.qud, sep=""), header=FALSE)
    m.noQud.met <- read.csv(paste("../../Model/CogSciModelWithLitAdjs/CombinedOutputMetaphor/", name.noQud, sep=""), header=FALSE)
    m.qud.met$qud <- "1"
    m.noQud.met$qud <- "0"
    m.qud.met$metaphor <- "1"
    m.noQud.met$metaphor <- "1"
    m.qud.lit <- read.csv(paste("../../Model/CogSciModelWithLitAdjs/CombinedOutputLiteral/", name.qud, sep=""), header=FALSE)
    m.noQud.lit <- read.csv(paste("../../Model/CogSciModelWithLitAdjs/CombinedOutputLiteral/", name.noQud, sep=""), header=FALSE)
    m.qud.lit$qud <- "1"
    m.noQud.lit$qud <- "0"
    m.qud.lit$metaphor <- "0"
    m.noQud.lit$metaphor <- "0"
    m <- rbind(m.qud.met, m.noQud.met, m.qud.lit, m.noQud.lit)
    colnames(m) <- c("category", "f1", "f2", "f3", "goal", "modelProb", "categoryID", "qud", "metaphor")
    # compute marginals
    m.f1 <- aggregate(data=subset(m, f1==1), modelProb ~ categoryID + qud + metaphor, FUN=sum)
    m.f1$featureNum <- "1"
    m.f2 <- aggregate(data=subset(m, f2==1), modelProb ~ categoryID + qud + metaphor, FUN=sum)
    m.f2$featureNum <- "2"
    m.f3 <- aggregate(data=subset(m, f3==1), modelProb ~ categoryID + qud + metaphor, FUN=sum)
    m.f3$featureNum <- "3"
    m.marginals <- rbind(m.f1, m.f2, m.f3)
    compare <- join(d.summary, m.marginals, by=c("categoryID", "featureNum", "qud", "metaphor"))
    cor.all <- with(compare, cor(featureProb, modelProb))
    cor.met <- with(subset(compare, metaphor=="1"), cor(featureProb, modelProb))
    cor.lit <- with(subset(compare, metaphor=="0"), cor(featureProb, modelProb))
    cor.info <- data.frame(name=name.qud, all=cor.all, met=cor.met, lit=cor.lit)
    cor.table <- rbind(cor.table, cor.info)
    if (cor.all > cor.best) {
      cor.best <- cor.all
      name.best <- name.qud
      best <- compare
      best.model <- m
    }
  }
}
with(best, cor.test(featureProb, modelProb))
max(cor.table$all)
max(cor.table$met)
max(cor.table$lit)

cor.table <- cor.table[with(cor.table, order(-all)), ]

############################## 
# Add feature labels
################################
features <- read.csv("../FeaturePriorExp/features-only.csv")
best <- join(best, features, by=c("animal", "featureNum"))
best$labels <- paste(best$animal, best$feature, sep=";")

##########################
# Add feature priors
##########################
priors <- read.csv("../FeaturePriorExp/featurePriors-set-marginal-plaw-l3.csv")
#priors <- read.csv("../FeaturePriorExp/featurePriors-set-marginal.csv")
priors.animal <- subset(priors, type=="animal")
priors.person <- subset(priors, type=="person")
colnames(priors.animal)[5] <- "animalPrior"
colnames(priors.person)[5] <- "personPrior"
d.summary <- join(d.summary, priors.animal, by=c("categoryID", "featureNum"))
d.summary <- join(d.summary, priors.person, by=c("categoryID", "featureNum"))
best <- join(best, priors.animal, by=c("categoryID", "featureNum"))
best <- join(best, priors.person, by=c("categoryID", "featureNum"))

############################
# Individual features
############################
best.f1 <- subset(best, featureNum=="1")
best.f2 <- subset(best, featureNum=="2")
best.f3 <- subset(best, featureNum=="3")
with(best.f1, cor.test(featureProb, modelProb))
with(best.f2, cor.test(featureProb, modelProb))
with(best.f3, cor.test(featureProb, modelProb))

#########################################
# Calculate distance to prior
########################################
# People's distance to prior
d.summary$featureUpdate <- d.summary$featureProb - d.summary$personPrior
ggplot(d.summary, aes(x=featureUpdate)) +
  geom_histogram(binwidth=0.1) +
  facet_grid(metaphor ~ featureNum) +
  theme_bw()

d.summary.featureUpdate <- summarySE(d.summary, measurevar="featureUpdate", groupvars=c("metaphor", "featureNum", "qud"))
ggplot(d.summary.featureUpdate, aes(x=qud, y=featureUpdate, fill=featureNum)) +
  #geom_line(aes(group=qud)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=featureUpdate-ci, ymax=featureUpdate+ci), width=0.1, position=position_dodge(0.9)) +
  #geom_point(data=best.modelFeatureUpdate, aes(x=featureNum, y=modelFeatureUpdate)) +
  #geom_line(data=best.modelFeatureUpdate, aes(x=featureNum, y=modelFeatureUpdate, group=qud)) +
  theme_bw() +
  facet_grid(.~metaphor)

# Model's distance to prior
best$modelFeatureUpdate <- best$modelProb - best$personPrior
best.modelFeatureUpdate <- summarySE(best, measurevar="modelFeatureUpdate", groupvars=c("featureNum", "qud", "metaphor"))
ggplot(best.modelFeatureUpdate, aes(x=qud, y=modelFeatureUpdate, fill=featureNum)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=modelFeatureUpdate-ci, ymax=modelFeatureUpdate+ci), position=position_dodge(0.9), width=0.2) +
  theme_bw() +
  facet_grid(.~metaphor)

### Plot together
d.summary.featureUpdate$type <- "human"
best.modelFeatureUpdate$type <- "model"
colnames(best.modelFeatureUpdate)[5] <- "featureUpdate"
featureUpdate.compare <- rbind(d.summary.featureUpdate, best.modelFeatureUpdate)
featureUpdate.compare$metaphor <- factor(featureUpdate.compare$metaphor, 
                                         labels=c("Literal", "Metaphorical"))
featureUpdate.compare$qud <- factor(featureUpdate.compare$qud, labels=c("Vague", "Specific"))
featureUpdate.compare$type <- factor(featureUpdate.compare$type, labels=c("Human", "Model"))
ggplot(featureUpdate.compare, aes(x=metaphor, y=featureUpdate, group=featureNum, fill=type, alpha=featureNum)) +
  geom_bar(stat="identity", position=position_dodge(), color="black") +
  geom_errorbar(aes(ymin=featureUpdate-ci, ymax=featureUpdate+ci), position=position_dodge(0.9), width=0.2, alpha=1) +
  theme_bw() +
  ylim(c(-0.051, 0.5)) +
  xlab("Utterance Type") +
  ylab("P(feature | utterance) - P(feature)") +
  facet_grid(type~qud) +
  scale_fill_manual(values=c("#333333", "#3399FF"), guide=FALSE) +
  scale_alpha_manual(values=c(1, 0.6, 0.4), name="Feature Number") +
  theme(axis.text.x = element_text(size=12),
        panel.grid.minor=element_blank(), panel.grid.major=element_blank(),
        axis.title = element_text(size=14),
        strip.text = element_text(size=14))

featureUpdate.compare$facet <- ifelse(featureUpdate.compare$type=="Human" &
                                        featureUpdate.compare$metaphor=="Literal", "Literal",
                                ifelse(featureUpdate.compare$type=="Human" &
                                      featureUpdate.compare$metaphor=="Metaphorical", "Metaphorical",
                                      "Model"))

ggplot(featureUpdate.compare, aes(x=qud, y=featureUpdate, group=featureNum, fill=type, alpha=featureNum)) +
  geom_bar(stat="identity", position=position_dodge(), color="black") +
  geom_errorbar(aes(ymin=featureUpdate-ci, ymax=featureUpdate+ci), position=position_dodge(0.9), width=0.2, alpha=1) +
  theme_bw() +
  ylim(c(-0.05, 0.5)) +
  xlab("QUD Type") +
  ylab("P(feature | utterance) - P(feature)") +
  facet_grid(.~facet) +
  scale_fill_manual(values=c("#333333", "#3399FF"), guide=FALSE) +
  scale_alpha_manual(values=c(1, 0.6, 0.4), name="Feature Number") +
  theme(axis.text.x = element_text(size=12),
        panel.grid.minor=element_blank(), panel.grid.major=element_blank(),
        axis.title = element_text(size=14),
        strip.text = element_text(size=14))

###########################
# Compare to prior performance on metaphor
###########################
with(subset(best, metaphor=="1"), cor.test(featureProb, modelProb))
with(subset(best, metaphor=="1"), cor.test(featureProb, animalPrior))
with(subset(best, metaphor=="1"), cor.test(featureProb, personPrior))
model.fit <- lm(data=subset(best, metaphor=="1"), featureProb ~ modelProb)
baseline.fit <- lm(data=subset(best, metaphor=="1"), featureProb ~ animalPrior + personPrior + qud)
baseline.fit.interact <- lm(data=subset(best, metaphor=="1"), featureProb ~ animalPrior * personPrior * qud)
summary(model.fit)
summary(baseline.fit)
summary(baseline.fit.interact)
library(lmtest)
coxtest(model.fit, baseline.fit)
coxtest(model.fit, baseline.fit.interact)
jtest(model.fit, baseline.fit)

anova(model.fit, baseline.fit)
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
ggplot(best, aes(x=modelProb, y=featureProb)) +
  #geom_point(size=3) +
  geom_errorbar(aes(ymin=featureProb-se, ymax=featureProb+se), width=0.01, color="grey") +
  geom_text(aes(label=labels, color=qud)) +
  scale_shape_manual(values=c(21, 24), name="Goal", labels=c("Vague", "Specific")) +
  theme_bw() +
  geom_smooth(method=lm) +
  scale_fill_manual(values=my.colors, name="Feature", labels=c("f1", "f2", "f3"), 
                    guide=guide_legend(override.aes=aes(shape=21))) +
  xlab("Model") +
  ylab("Human")

#########################
# Visualize residuals
#########################
fit <- lm(data=best, featureProb ~ modelProb)
#plot(fit)
best$resid <- residuals(fit)
best <- best[with(best, order(-abs(resid))), ]
best$residualOrder <- seq(1, nrow(best), 1)

with(subset(best, residualOrder <=10), cor.test(modelProb, featureProb))
with(subset(best, residualOrder > 10), cor.test(modelProb, featureProb))

best <- join(best, features, by=c("animal", "featureNum"))
best$labeltext <- ifelse(best$residualOrder <= 10, 
                                  paste(best$animal, best$feature, sep=":"), "")

ggplot(best, aes(x=modelProb, y=featureProb, fill=qud, color=qud)) +
  geom_smooth(method=lm, color="gray", fill="gray") +
  geom_errorbar(aes(ymin=featureProb-se, ymax=featureProb+se), width=0.01, color="gray") +
  geom_point(aes(alpha=featureNum, shape=featureNum), size=2) +
  geom_text(aes(label=labeltext, color=qud, y=featureProb-0.01), size=5)+
  #, position=position_jitter(height=0.1)) +
  theme_bw() +
  xlim(c(0, 1)) +
  #ylim(c(0, 1)) +
  scale_alpha_manual(values=c(1, 0.7, 0.5), guide=FALSE) +
  scale_shape_manual(values=c(21, 22, 24), name="Feature Number") +
  scale_fill_manual(values=c("#000033", "#d95f02"), guide=FALSE) +
  scale_color_manual(values=c("#000033", "#d95f02"), name="QUD", labels=c("Vague", "Specific")) +
  #scale_color_manual(values=c("#1b9e77", "#d95f02")) +
  theme(axis.text = element_text(size=12),
        panel.grid.minor=element_blank(), panel.grid.major=element_blank(),
        axis.title = element_text(size=16),
        legend.title = element_text(size=14),
        legend.text = element_text(size=14)
        ) +
  xlab("Model") +
  ylab("Human")


# Animals with worst fit
worstanimals <- unique(subset(best, residualOrder <= 10)$animal)
worstdatapoints <- subset(best, residualOrder <= 10)

# Get all three features for the worst fit animals
worstfeatures <- subset(best, animal%in%worstanimals & qud=="0")
worstfeatures.wide <- dcast(
  data = worstfeatures,
  formula = animal ~ featureNum, 
  value.var = "feature"
)

# Save features for the worst-fit animals
write.csv(worstfeatures.wide, "../PsychReviewExps/Alternatives/worstfeatures_lambda.csv", quote=FALSE, row.names=FALSE)

#########################################
# Worst fit animals with alternatives
#########################################

######
# Model with alternatives
######
alpha = 3
probGoal = 0.9
lambda = 5
# No QUD
alt.model.noQUD <- data.frame()
for (a in worstanimals) {
  filename.noQUD <- paste("../../Model/PsychReviewModels/OutputAltByGoal/noQud-a", alpha,
                           "-c2-l", lambda, "-plaw-alt-", a, ".csv", sep="")
  alt.m.noQUD <- read.csv(filename.noQUD, header=FALSE)
  alt.model.noQUD <- rbind(alt.model.noQUD, alt.m.noQUD)
}
colnames(alt.model.noQUD) <- c("animal", "utterance", "category", "f1", "f2", "f3", "goal", "modelProb")
alt.model.noQUD$qud <- "0"

# QUD
alt.model.QUD <- data.frame()
for (a in worstanimals) {
  filename.QUD <- paste("../../Model/PsychReviewModels/OutputAltByGoal/g", probGoal, "-a", alpha,
                          "-c2-l", lambda, "-plaw-alt-", a, ".csv", sep="")
  alt.m.QUD <- read.csv(filename.QUD, header=FALSE)
  alt.model.QUD <- rbind(alt.model.QUD, alt.m.QUD)
}
colnames(alt.model.QUD) <- c("animal", "utterance", "category", "f1", "f2", "f3", "goal", "modelProb")
alt.model.QUD$qud <- "1"

alt.model <- rbind(alt.model.noQUD, alt.model.QUD)
alt.model$alternatives <- "1"

######
# Model with no alternatives
######
# No QUD
noAlt.model.noQUD <- data.frame()
for (a in worstanimals) {
  noAlt.filename.noQUD <- paste("../../Model/PsychReviewModels/OutputAltByGoal/noQud-a", alpha,
                          "-c2-l", lambda, "-plaw-noAlt-", a, ".csv", sep="")
  noAlt.m.noQUD <- read.csv(noAlt.filename.noQUD, header=FALSE)
  noAlt.model.noQUD <- rbind(noAlt.model.noQUD, noAlt.m.noQUD)
}
colnames(noAlt.model.noQUD) <- c("animal", "utterance", "category", "f1", "f2", "f3", "goal", "modelProb")
noAlt.model.noQUD$qud <- "0"

# QUD
noAlt.model.QUD <- data.frame()
for (a in worstanimals) {
  noAlt.filename.QUD <- paste("../../Model/PsychReviewModels/OutputAltByGoal/g", probGoal, "-a", alpha,
                        "-c2-l", lambda, "-plaw-noAlt-", a, ".csv", sep="")
  noAlt.m.QUD <- read.csv(noAlt.filename.QUD, header=FALSE)
  noAlt.model.QUD <- rbind(noAlt.model.QUD, noAlt.m.QUD)
}
colnames(noAlt.model.QUD) <- c("animal", "utterance", "category", "f1", "f2", "f3", "goal", "modelProb")
noAlt.model.QUD$qud <- "1"

noAlt.model <- rbind(noAlt.model.noQUD, noAlt.model.QUD)
noAlt.model$alternatives <- "0"

alt.noAlt.model <- rbind(alt.model, noAlt.model)

##############
# Calculate feature marginals
##############
alt.noAlt.model.f1 <- aggregate(data=subset(alt.noAlt.model, f1==1), 
                                modelProb ~ animal + utterance + qud + alternatives, FUN=sum)
alt.noAlt.model.f1$featureNum <- 1
alt.noAlt.model.f2 <- aggregate(data=subset(alt.noAlt.model, f2==1), 
                                modelProb ~ animal + utterance + qud + alternatives, FUN=sum)
alt.noAlt.model.f2$featureNum <- 2
alt.noAlt.model.f3 <- aggregate(data=subset(alt.noAlt.model, f3==1), 
                                modelProb ~ animal + utterance + qud + alternatives, FUN=sum)
alt.noAlt.model.f3$featureNum <- 3

alt.noAlt.model.marginals <- rbind(alt.noAlt.model.f1, alt.noAlt.model.f2, alt.noAlt.model.f3)

###################
# Join with human metaphor interpretation
###################
alt.noAlt.model.compare <- join(alt.noAlt.model.marginals, d.met.summary, 
                                by=c("animal", "qud", "featureNum"))
alt.noAlt.model.compare$animal.feature <- paste(alt.noAlt.model.compare$animal, 
                                                alt.noAlt.model.compare$featureNum, sep=":")
ggplot(alt.noAlt.model.compare, aes(x=modelProb, y=featureProb, color=qud)) +
  geom_text(aes(label=animal.feature)) +
  geom_point() +
  theme_bw() +
facet_grid(.~alternatives) +
  geom_abline(intercept=0, slope=1, color="gray") +
  xlim(c(0, 1)) +
  ylim(c(0, 1))


with(subset(alt.noAlt.model.compare, alternatives=="0"), cor.test(modelProb, featureProb))
with(subset(alt.noAlt.model.compare, alternatives=="1"), cor.test(modelProb, featureProb))

# Look only at data points with the highest residuals, and not all features of all worst
# fit aniamls

worstdatapoints$animal.feature.qud <- paste(worstdatapoints$animal, worstdatapoints$featureNum, worstdatapoints$qud, sep=":")
alt.noAlt.model.compare$animal.feature.qud <- paste(alt.noAlt.model.compare$animal,
                                                    alt.noAlt.model.compare$featureNum,
                                                    alt.noAlt.model.compare$qud, sep=":")
alt.noAlt.model.compare.onlyWorst <- subset(alt.noAlt.model.compare, animal.feature.qud%in%worstdatapoints$animal.feature.qud)


with(subset(alt.noAlt.model.compare.onlyWorst, alternatives=="0"), cor.test(modelProb, featureProb))
with(subset(alt.noAlt.model.compare.onlyWorst, alternatives=="1"), cor.test(modelProb, featureProb))

ggplot(alt.noAlt.model.compare.onlyWorst, aes(x=modelProb, y=featureProb, color=qud)) +
  geom_text(aes(label=animal.feature)) +
  geom_point() +
  theme_bw() +
  facet_grid(.~alternatives) +
  geom_abline(intercept=0, slope=1, color="gray") +
  xlim(c(0, 1)) +
  ylim(c(0, 1))


subset(alt.noAlt.model.compare.onlyWorst, animal=="ant")
subset(alt.noAlt.model.compare.onlyWorst, animal=="whale")

### Plot side by side with human interp as bar plot
alt.noAlt.model.compare.onlyWorst.long <- mutate(alt.noAlt.model.compare.onlyWorst,
                                                featureProb=NULL, animal.feature=NULL,
                                                sd=0, se=0, ci=0, utterance=NULL)
d.met.summary$animal.feature.qud <- paste(d.met.summary$animal,
                                         d.met.summary$featureNum,
                                         d.met.summary$qud, sep=":")
d.met.summary.onlyWorst <- subset(d.met.summary, animal.feature.qud%in%worstdatapoints$animal.feature.qud)

d.met.summary.onlyWorst <- mutate(d.met.summary.onlyWorst,
                                  alternatives = "human")

colnames(d.met.summary.onlyWorst)[6] <- "modelProb"

alt.noAlt.model.compare.onlyWorst.long <- rbind(alt.noAlt.model.compare.onlyWorst.long,
                                                d.met.summary.onlyWorst)


worstdatapoints.labels <- data.frame(animal.feature.qud = worstdatapoints$animal.feature.qud,
                                     labeltext = worstdatapoints$labeltext)

alt.noAlt.model.compare.onlyWorst.long <- join(alt.noAlt.model.compare.onlyWorst.long,
                                               worstdatapoints.labels, by=c("animal.feature.qud"))

alt.noAlt.model.compare.onlyWorst.long$alternatives <- 
  factor(alt.noAlt.model.compare.onlyWorst.long$alternatives,
         levels=c("0", "1", "human"), labels=c("Orig", "Alt", "Human"))

ggplot(alt.noAlt.model.compare.onlyWorst.long, aes(x=alternatives, y=modelProb, fill=alternatives)) +
  geom_bar(stat="identity", color="black") +
  #geom_point(aes(x=animal.feature.qud, y=featureProb)) +
  geom_errorbar(aes(ymin=modelProb-ci, ymax=modelProb+ci), width=0.2) +
  theme_bw() +
  facet_wrap(~labeltext, ncol=5) +
  xlab("") +
  ylab("Probability") +
  scale_fill_manual(values=c("#3399FF", "#99ccff", "gray"), guide=FALSE) +
  scale_alpha_manual(values=c(1, 0.6, 0.4), name="Feature Number") +
  theme(axis.text.x = element_text(size=12),
        panel.grid.minor=element_blank(), panel.grid.major=element_blank(),
        axis.title = element_text(size=14),
        strip.text = element_text(size=14))


########################################
# Fit model for literal utterances 
# Get all the names of the model files to fit
filenames <- read.csv("../../Model/CogSciModelWithLitAdjs/combinedOutputFilenames_complexQp_compose.txt", header=FALSE)

max.cor <- 0
max.name <- ""
#filenames$V1 <- "g0.5-a1.csv"
for (n in filenames$V1) {
  if (grepl("g", n)) {
    name.qud <- n
    name.noQud <- paste("noQud-a", as.list(strsplit(n, "a"))[[1]][2], sep="")
    m.qud <- read.csv(paste("../../Model/CogSciModelWithLitAdjs/CombinedOutputLiteral/", name.qud, sep=""), header=FALSE)
    m.noQud <- read.csv(paste("../../Model/CogSciModelWithLitAdjs/CombinedOutputLiteral/", name.noQud, sep=""), header=FALSE)
    m.qud$qud <- "1"
    m.noQud$qud <- "0"
    m <- rbind(m.qud, m.noQud)
    colnames(m) <- c("category", "f1", "f2", "f3", "goal", "modelProb", "categoryID", "qud")
    # compute marginals
    m.f1 <- aggregate(data=subset(m, f1==1), modelProb ~ categoryID + qud, FUN=sum)
    m.f1$featureNum <- "1"
    m.f2 <- aggregate(data=subset(m, f2==1), modelProb ~ categoryID + qud, FUN=sum)
    m.f2$featureNum <- "2"
    m.f3 <- aggregate(data=subset(m, f3==1), modelProb ~ categoryID + qud, FUN=sum)
    m.f3$featureNum <- "3"
    m.marginals <- rbind(m.f1, m.f2, m.f3)
    compare <- join(d.lit.summary, m.marginals, by=c("categoryID", "featureNum", "qud"))
    cor <- with(compare, cor(featureProb, modelProb))
    if (cor > max.cor) {
      max.cor <- cor
      max.name <- name.qud
      best.literal <- compare
      best.literal.model <- m
    }
  }
}
with(best.literal, cor.test(featureProb, modelProb))

best.literal.metaphor <- rbind(best.literal, best.metaphor)
with(best.literal.metaphor, cor.test(featureProb, modelProb))
best.literal.metaphor <- join(best.literal.metaphor, features, by=c("animal", "featureNum"))
best.literal.metaphor$labels <- paste(best.literal.metaphor$animal, best.literal.metaphor$feature,
                                      sep = ";")
ggplot(subset(best.literal.metaphor, metaphor=="1"), aes(x=modelProb, y=featureProb, color=qud, shape=featureNum)) +
  #geom_text(aes(label=labels)) +
  geom_point() +
  facet_grid(.~qud) +
  theme_bw()

ggplot(subset(best.literal.metaphor, metaphor=="0"), aes(x=modelProb, y=featureProb, color=qud, shape=featureNum)) +
  geom_text(aes(label=labels)) +
  #geom_point() +
  facet_grid(.~qud) +
  theme_bw()

features <- read.csv("../FeaturePriorExp/features-only.csv")
best <- join(best, features, by=c("animal", "featureNum"))
best$labels <- paste(best$animal, best$feature, sep=";")

ggplot(best.literal.metaphor, aes(x=modelProb, y=featureProb, color=metaphor, shape=featureNum)) +
  #geom_text(aes(label=labels)) +
  geom_point() +
  theme_bw()

######################
# Plot characteristics of best model
######################
# Probability of person vs animal given "john is a shark"
best.model.category <- aggregate(data=best.model, modelProb ~ category + categoryID + qud, FUN=sum)
best.model.category.summary <- summarySE(best.model.category, measurevar="modelProb", groupvars=c("category"))
ggplot(best.model.category.summary, aes(x=category, y=modelProb)) +
  geom_bar(stat="identity", color="black", fill="gray") +
  geom_errorbar(aes(ymin=modelProb-ci, ymax=modelProb+ci), width=0.5) +
  theme_bw()

# Probability of feature given utterance qud
best.model.feature <- aggregate(data=best.model, modelProb ~ f1 + f2 + f3 + qud + categoryID, FUN=sum)
best.model.feature.summary <- summarySE(best.model.feature, measurevar="modelProb", 
                                        groupvars=c("f1", "f2", "f3", "qud")) 
best.model.feature.summary$featureSet <- paste(best.model.feature.summary$f1, best.model.feature.summary$f2,
                                               best.model.feature.summary$f3, sep=",")
ggplot(best.model.feature.summary, aes(x=qud, y=modelProb, fill=featureSet)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=modelProb-se, ymax=modelProb+se), width=0.5, position=position_dodge(0.9)) +
  theme_bw() 

# Probability of feature margins given utterance qud
best.model.f1 <- subset(aggregate(data=best.model, modelProb ~ f1 + qud + categoryID, FUN=sum), f1==1)
best.model.f2 <- subset(aggregate(data=best.model, modelProb ~ f2 + qud + categoryID, FUN=sum), f2==1)
best.model.f3 <- subset(aggregate(data=best.model, modelProb ~ f3 + qud + categoryID, FUN=sum), f3==1)
best.model.f1$feature <- "f1"
best.model.f2$feature <- "f2"
best.model.f3$feature <- "f3"
best.model.f1$f1 <- NULL
best.model.f2$f2 <- NULL
best.model.f3$f3 <- NULL
best.model.featureMarginals <- rbind(best.model.f1, best.model.f2, best.model.f3)
best.model.featureMarginals.summary <- summarySE(best.model.featureMarginals, measurevar=c("modelProb"),
                                                 groupvars=c("qud", "feature"))
ggplot(best.model.featureMarginals.summary, aes(x=qud, y=modelProb, fill=feature)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=modelProb-se, ymax=modelProb+se), width=0.5, position=position_dodge(0.9)) +
  theme_bw()


#######################
# Lion example
#######################
name.qud <- max.name
name.noQud <- paste("noQud-a", as.list(strsplit(n, "a"))[[1]][2], sep="")
m.qud <- read.csv(paste("../../Model/CogSciModel/CombinedOutput/", name.qud, sep=""), header=FALSE)
m.noQud <- read.csv(paste("../../Model/CogSciModel/CombinedOutput/",name.noQud, sep=""), header=FALSE)
m.qud$qud <- "1"
m.noQud$qud <- "0"
m <- rbind(m.qud, m.noQud)
colnames(m) <- c("category", "f1", "f2", "f3", "modelProb", "categoryID", "qud")

lion <- subset(m, categoryID==20)
lion$features <- paste(lion$f1, lion$f2, lion$f3, sep=",")
lion.noqud <- subset(lion, qud=="0")
lion.qud <- subset(lion, qud=="1")
# show metaphor effect for no qud only
lion.metaphor <- aggregate(data=lion.noqud, modelProb ~ category, FUN=sum)
ggplot(lion.metaphor, aes(x=category, y=modelProb)) +
  geom_bar(stat="identity", color="black", position=position_dodge(), fill="#99CCFF") +
  theme_bw() +
  xlab("Category") +
  ylab("Probability") +
  scale_x_discrete(labels=c("Lion", "Person")) +
  theme(axis.title.x = element_text(size=16),
        axis.text.x  = element_text(size=14),
        axis.title.y = element_text(size=16),
        axis.text.y = element_text(size=14))

# show marginal feature interpretation for no qud only
getMarginalFeatures <- function(modelResult) {
  f1 <- aggregate(data=subset(modelResult, f1==1), modelProb ~ qud, FUN=sum)
  f1$featureNum <- 1
  f2 <- aggregate(data=subset(modelResult, f2==1), modelProb ~ qud, FUN=sum)
  f2$featureNum <- 2
  f3 <- aggregate(data=subset(modelResult, f3==1), modelProb ~ qud, FUN=sum)
  f3$featureNum <- 3
  marginal <- rbind(f1, f2, f3)
  return (marginal)
}

lion.marginal.noqud <- getMarginalFeatures(lion.noqud)
lion.marginal.noqud$featureNum <- factor(lion.marginal.noqud$featureNum)
ggplot(lion.marginal.noqud, aes(x=featureNum, y=modelProb, fill=featureNum)) +
  geom_bar(stat="identity", color="black") +
  theme_bw() +
  xlab("Feature") +
  ylab("Probability") +
  scale_x_discrete(labels=c("ferocious", "scary", "strong")) +
  theme(axis.title.x = element_text(size=16),
        axis.text.x  = element_text(size=14),
        axis.title.y = element_text(size=16),
        axis.text.y = element_text(size=14)) +
  scale_fill_manual(values=c("#003366", "#006699", "#99ccff"), guide="none")
#scale_fill_brewer(palette="Blues")

lion.marginal.qud <- getMarginalFeatures(lion.qud)
lion.marginal.qud$featureNum <- factor(lion.marginal.qud$featureNum)
ggplot(lion.marginal.qud, aes(x=featureNum, y=modelProb, fill=featureNum)) +
  geom_bar(stat="identity", color="black") +
  theme_bw() +
  xlab("Feature") +
  ylab("Probability") +
  scale_x_discrete(labels=c("ferocious", "scary", "strong")) +
  theme(axis.title.x = element_text(size=16),
        axis.text.x  = element_text(size=14),
        axis.title.y = element_text(size=16),
        axis.text.y = element_text(size=14)) +
  scale_fill_manual(values=c("#003366", "#006699", "#99ccff"), guide="none")

# Show cluster of features for qud
lion.noqud$featureSetNum <- c(1, 2, 3, 4, 5, 6, 7, 8)
lion.noqud$featureSetNum <- factor(lion.noqud$featureSetNum,
                                   labels=c("1,1,1","1,1,0","1,0,1","1,0,0",
                                            "0,1,1","0,1,0","0,0,1","0,0,0"))
ggplot(lion.noqud, aes(x=featureSetNum, y=modelProb, fill=featureSetNum)) +
  geom_bar(stat="identity", color="black") +
  theme_bw() +
  xlab("Feature vector") +
  ylab("Probability") +
  ylim(0,0.3) +
  theme(axis.title.x = element_text(size=16),
        axis.text.x  = element_text(size=14),
        axis.title.y = element_text(size=16),
        axis.text.y = element_text(size=14)) +
  scale_fill_manual(values=c("#0570b0","#6baed6","#bdd7e7","#eff3ff",
                             "#f7f7f7","#cccccc","#969696","#525252"), 
                    guide="none")

priors.joint <- read.csv("../FeaturePriorExp/featurePriors-set.csv")
personPriors.joint.lion <- subset(priors.joint, categoryID==20 & type=="person")
personPriors.joint.lion.f1present <- subset(personPriors.joint.lion, featureSetNum <=4)
normalizer <- sum(personPriors.joint.lion.f1present$normalizedProb)
personPriors.joint.lion.f1present$probGivenF1 <- 
  personPriors.joint.lion.f1present$normalizedProb / normalizer

personPriors.joint.lion.f1notpresent <- data.frame(categoryID=c(20,20,20,20),
                                                   type=c("person","person","person","person"),
                                                   featureSetNum=c(5,6,7,8),
                                                   animal=c("lion","lion","lion","lion"),
                                                   N=c(35,35,35,35),
                                                   normalizedProb=c(0,0,0,0),
                                                   sd=c(0,0,0,0),
                                                   se=c(0,0,0,0),
                                                   ci=c(0,0,0,0),
                                                   probGivenF1=c(0,0,0,0))
personPriors.joint.lion.all <- rbind(personPriors.joint.lion.f1present,
                                     personPriors.joint.lion.f1notpresent)
personPriors.joint.lion.all$featureSetNum <- 
  factor(personPriors.joint.lion.all$featureSetNum,
         labels=c("1,1,1","1,1,0","1,0,1","1,0,0",
                  "0,1,1","0,1,0","0,0,1","0,0,0"))
ggplot(personPriors.joint.lion.all, aes(x=featureSetNum, y=probGivenF1, fill=featureSetNum)) +
  geom_bar(stat="identity", color="black") +
  theme_bw() +
  xlab("Feature vector") +
  ylab("Probability") +
  theme(axis.title.x = element_text(size=16),
        axis.text.x  = element_text(size=14),
        axis.title.y = element_text(size=16),
        axis.text.y = element_text(size=14)) +
  scale_fill_manual(values=c("#0570b0","#6baed6","#bdd7e7","#eff3ff",
                             "#f7f7f7","#cccccc","#969696","#525252"), 
                    guide="none")


######################
# Human stats
#####################
summary(lm(data=d.f1.summary, featureProb ~ metaphor))
summary(lm(data=d.f2.summary, featureProb ~ metaphor))
summary(lm(data=d.f3.summary, featureProb ~ metaphor))
summary(lm(data=subset(d.f1.summary, metaphor==1), featureProb ~ qud))
summary(lm(data=subset(d.f2.summary, metaphor==1), featureProb ~ qud))
summary(lm(data=subset(d.f3.summary, metaphor==1), featureProb ~ qud))
summary(lm(data=subset(d.f1.summary, metaphor==0), featureProb ~ qud))
summary(lm(data=subset(d.f2.summary, metaphor==0), featureProb ~ qud))
summary(lm(data=subset(d.f3.summary, metaphor==0), featureProb ~ qud))
with(subset(d.summary, metaphor=="0" & featureNum=="1"), t.test(featureProb, personPrior, paired=TRUE))
with(subset(d.summary, metaphor=="0" & featureNum=="2"), t.test(featureProb, personPrior, paired=TRUE))
with(subset(d.summary, metaphor=="0" & featureNum=="3"), t.test(featureProb, personPrior, paired=TRUE))
with(subset(d.summary, metaphor=="1" & featureNum=="1"), t.test(featureProb, personPrior, paired=TRUE))
with(subset(d.summary, metaphor=="1" & featureNum=="2"), t.test(featureProb, personPrior, paired=TRUE))
with(subset(d.summary, metaphor=="1" & featureNum=="3"), t.test(featureProb, personPrior, paired=TRUE))
with(subset(d.summary, metaphor=="1" & featureNum=="1" & qud=="1"), t.test(featureProb, personPrior, paired=TRUE))
with(subset(d.summary, metaphor=="1" & featureNum=="2" & qud=="1"), t.test(featureProb, personPrior, paired=TRUE))
with(subset(d.summary, metaphor=="1" & featureNum=="3"& qud=="1"), t.test(featureProb, personPrior, paired=TRUE))
d.summary$featureType <- ifelse(d.summary$featureNum==1, 1, 0)
d.summary$featureType <- factor(d.summary$featureType)
anova(lm(data=d.summary, featureProb ~ metaphor * featureType))

############################
# Model analysis
############################
########
# Literalness
########
model.literalness <- aggregate(data=best.model, modelProb ~ category + categoryID + qud, FUN=sum)
model.literalness$qud <- factor(model.literalness$qud)
model.literalness.summary <- summarySE(model.literalness, measurevar="modelProb",
                                       groupvars=c("category"))
ggplot(model.literalness.summary, aes(x=category, y=modelProb, fill=category)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=modelProb-se, ymax=modelProb+se), width=0.2) +
  xlab("") +
  ylab("Probability of category given utterance") +
  scale_x_discrete(labels=c("Animal", "Person")) +
  scale_fill_manual(values=c("#003366", "#CCCCCC"), guide=FALSE) +
  theme_bw()
#######
# Aggregate feature stuff
#######
########
# Model qualitative stats
########
summary(lm(data=subset(best, featureNum=="1"), modelProb ~ qud))
summary(lm(data=subset(best, featureNum=="2"), modelProb ~ qud))
summary(lm(data=subset(best, featureNum=="3"), modelProb ~ qud))

best.marginals.summary <- summarySE(best, measurevar="modelProb",
                                    groupvars=c("featureNum", "qud"))
ggplot(best.marginals.summary, aes(x=qud, y=modelProb, fill=featureNum)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=modelProb-se, ymax=modelProb+se), width=0.2, position=position_dodge(0.9)) +
  theme_bw() +
  scale_fill_manual(values=my.colors, name="Feature", labels=c("f1", "f2", "f3")) +
  xlab("") +
  ylab("Probability of feature given utterance") +
  scale_x_discrete(labels=c("Vague goal", "Specific goal"))

###############################
## Human split-half analysis
################################
splithalf.all.sum <- 0
splithalf.met.sum <- 0
splithalf.f1.sum <- 0
splithalf.f2.sum <- 0
splithalf.f3.sum <- 0
splithalf.cors <- data.frame(all=NULL, met=NULL, f1=NULL, f2=NULL, f3=NULL)            
for (t in seq(1, 1000)) {
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
  all <- prophet(with(splithalf.comp, cor(h1prob, h2prob)), 2)
  # just metaphor
  splithalf.met.comp <- subset(splithalf.comp, metaphor=="1")
  met <- prophet(with(splithalf.met.comp, cor(h1prob, h2prob)), 2)
  f1 <- prophet(with(subset(splithalf.met.comp, featureNum==1), cor(h1prob, h2prob)), 2)
  f2 <- prophet(with(subset(splithalf.met.comp, featureNum==2), cor(h1prob, h2prob)), 2)
  f3 <- prophet(with(subset(splithalf.met.comp, featureNum==3), cor(h1prob, h2prob)), 2)
  this.frame <- data.frame(all=all,
                           met=met,
                           f1=f1,
                           f2=f2,
                           f3=f3)
  splithalf.cors <- rbind(splithalf.cors, this.frame)
}

splithalf.all <- summarySE(splithalf.cors, measurevar="all", groupvars=NULL)
splithalf.met <- summarySE(splithalf.cors, measurevar="met", groupvars=NULL)
splithalf.f1 <- summarySE(splithalf.cors, measurevar="f1", groupvars=NULL)
splithalf.f2 <- summarySE(splithalf.cors, measurevar="f2", groupvars=NULL)
splithalf.f3 <- summarySE(splithalf.cors, measurevar="f3", groupvars=NULL)

prophet <- function(reliability, length) {
  prophecy <- length * reliability / (1 + (length - 1)*reliability)
  return (prophecy)
}
prophet(splithalf.all, 2)
prophet(splithalf.met, 2)
prophet(splithalf.f1, 2)
prophet(splithalf.f2, 2)
prophet(splithalf.f3, 2)

##########################
# Ant Ox Strong error analysis
#########################
d.ant <- read.csv("../../Model/CogSciModel/ant.csv", header=FALSE)
colnames(d.ant) <- c("category", "f1", "f2", "f3", "modelProb")
d.ant.ox <- read.csv("../../Model/CogSciModel/ant-ox.csv", header=FALSE)  
colnames(d.ant.ox) <- c("category", "f1", "f2", "f3", "modelProb")

sum(subset(d.ant,f2==1)$modelProb)
sum(subset(d.ant.ox,f2==1)$modelProb)
sum(subset(d.ant,f1==1)$modelProb)
sum(subset(d.ant.ox,f1==1)$modelProb)
