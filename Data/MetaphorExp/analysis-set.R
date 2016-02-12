library(reshape)
library(ggplot2)
m.set <- read.csv("data80-set-long.csv")

#########################
# Long form
########################
m.set.long <- melt(m.set, id=c("workerid", "gender", "age", "income", "categoryID", "order", "animal", "condition"))
m.set.long$featureSetNum <- unlist(lapply(strsplit(as.character(m.set.long$variable), "X"), "[", 2))
m.set.long$qud <- ifelse(m.set.long$condition==1 | m.set.long$condition==2, 0, 1)
m.set.long$metaphor <- ifelse(m.set.long$condition==1 | m.set.long$condition==3, 0, 1)
m.set.long$qud <- factor(m.set.long$qud)
m.set.long$metaphor <- factor(m.set.long$metaphor)
m.set.long$featureSetNum <- factor(m.set.long$featureSetNum)

####################################
# Split half
####################################
prophet <- function(r, n) {
  return ((n*r) / (1 + (n-1)*r))
}

#check <- m.set.long
check <- subset(m.set.long, metaphor=="1")

m.cors <- data.frame(cors=NULL, proph=NULL)            
for (t in seq(1, 10)) {
  ii <- seq_len(nrow(check))
  ind1 <- sample(ii, nrow(check) / 2) 
  ind2 <- ii[!ii %in% ind1] 
  p1 <- check[ind1, ] 
  p2 <- check[ind2, ]
  #p1.summary <- summarySE(fp.set.long, measurevar="normalizedProb", groupvars=c("categoryID", "type", "featureSetNum"))
  p1.summary <- summarySE(p1, measurevar="normalizedProb", groupvars=c("categoryID", "animal", "featureSetNum", "condition"))
  p2.summary <- summarySE(p2, measurevar="normalizedProb", groupvars=c("categoryID", "animal", "featureSetNum", "condition"))
  colnames(p1.summary)[6] <- "p1prob"
  colnames(p2.summary)[6] <- "p2prob"
  m.splithalf.comp <- join(p1.summary, p2.summary, by=c("categoryID", "animal", "featureSetNum", "condition"))
  m.splithalf.comp <- m.splithalf.comp[complete.cases(m.splithalf.comp),]
  this.cor <- with(m.splithalf.comp, cor(p1prob, p2prob))
  m.cor <- data.frame(cors=this.cor, proph=prophet(this.cor, 2))
  m.cors <- rbind(m.cor, m.cors)
}

###################################
# Check distribution of ratings
###################################
m.set.long$condition <- factor(m.set.long$condition, levels=c(1, 3, 2, 4), 
                               labels=c("Literal vague", "Literal specific", "Metaphorical vague", "Metaphorical specific"))

m.set.long$featureSetNum <- factor(m.set.long$featureSetNum)

#m.set.long$featureSetNum <- factor(m.set.long$featureSetNum,
#                                   labels=c("1,1,1", "1,1,0", "1,0,1", "1,0,0",
#                                            "0,1,1", "0,1,0", "0,0,1", "0,0,0"))
ggplot(m.set.long, aes(x=value)) +
  theme_bw() +
  geom_histogram(binwidth=0.05)
  #geom_density()

#***** extremes *********
nrow(subset(m.set.long, value==0)) / nrow(m.set.long) # 8.6%
nrow(subset(m.set.long, value==1)) / nrow(m.set.long) # 1.5%

#***** everything ********
ggplot(m.set.long, aes(x=value)) +
  theme_bw() +
  facet_grid(featureSetNum ~ condition) +
  #geom_histogram(binwidth=0.05) +
  geom_bar(aes(y = (..count..)/sum(..count..)), binwidth=0.05) +
  xlab("Proportion on slider") +
  ylab("Count (%)")


###################################
# No sigmoid
###################################
# normalize to sum ratings for each person/animal in each trial to 1
# get noramlizing factor by summing ratigs for each sbject/category/type
m.set.normalizing <- aggregate(data=m.set.long, value ~ workerid + categoryID + animal + qud + metaphor + condition, FUN=sum)
colnames(m.set.normalizing)[7] <- "normalizing"
m.set.long <- join(m.set.long, m.set.normalizing, by=c("workerid", "categoryID", "animal", "qud", "metaphor", "condition"))
# filter out rows with 0 as normalizer
m.set.long <- subset(m.set.long, normalizing != 0)
m.set.long$normalizedProb <- m.set.long$value / m.set.long$normalizing

m.set.long.summary <- summarySE(m.set.long, measurevar="normalizedProb", 
                                groupvars=c("categoryID", "animal", "metaphor", "qud", "featureSetNum", "condition"))

#### sanity check ####
sanity <- subset(m.set.long.summary, as.numeric(categoryID) <= 10)

ggplot(sanity, aes(x=featureSetNum, y=normalizedProb, fill=featureSetNum)) +
  geom_bar(stat="identity", color="black") +
  geom_errorbar(aes(ymin=normalizedProb-se, ymax=normalizedProb+se)) +
  theme_bw() +
  facet_grid(condition ~ categoryID)

#################
# Check distribution
#################

#***** everything normalized ********
ggplot(m.set.long, aes(x=normalizedProb)) +
  theme_bw() +
  facet_grid(featureSetNum ~ condition) +
  #geom_histogram(binwidth=0.05) +
  geom_bar(aes(y = (..count..)/sum(..count..)), binwidth=0.05) +
  xlab("Normalized probability") +
  ylab("Count (%)")

############################
# Summary of probability for featureSets across conditions
############################
m.set.long.summary.condition <- summarySE(m.set.long.summary, measurevar="normalizedProb",
                                          groupvars=c("metaphor", "qud", "featureSetNum"))

m.set.long.summary.condition$qud <- factor(m.set.long.summary.condition$qud, 
                                           labels=c("Vague", "Specifc"))
m.set.long.summary.condition$metaphor <- factor(m.set.long.summary.condition$metaphor,
                                                labels=c("Literal", "Metaphorical"))

ggplot(m.set.long.summary.condition, aes(x=qud, y=normalizedProb, fill=featureSetNum)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=normalizedProb-se, ymax=normalizedProb+se), position=position_dodge(0.9), width=0.2) +
  theme_bw() +
  scale_fill_brewer(name="Feature sets", palette="RdGy") +
  facet_grid(.~ metaphor) +
  xlab("QUD") +
  ylab("Normalized probability")
  

############################
# Marginals
############################
mapping <- read.csv("../FeaturePriorExp/featureSetMapping.csv")
mapping$featureSetNum <- factor(mapping$featureSetNum)
#mapping$featureSetNum <- factor(mapping$featureSetNum, 
#                                labels=c("1,1,1", "1,1,0", "1,0,1", "1,0,0",
#                                         "0,1,1", "0,1,0", "0,0,1", "0,0,0"))
m.set.long.summary <- join(m.set.long.summary, mapping, by=c("featureSetNum"))
m.set.marginal.f1 <- aggregate(data=subset(m.set.long.summary, f1=="1"), 
                               normalizedProb ~ categoryID + metaphor + qud + condition, FUN=sum)
m.set.marginal.f1$featureNum="1"
m.set.marginal.f2 <- aggregate(data=subset(m.set.long.summary, f2=="1"), 
                               normalizedProb ~ categoryID + metaphor + qud + condition, FUN=sum)
m.set.marginal.f2$featureNum="2"
m.set.marginal.f3 <- aggregate(data=subset(m.set.long.summary, f3=="1"), 
                               normalizedProb ~ categoryID + metaphor + qud + condition, FUN=sum)
m.set.marginal.f3$featureNum="3"
m.set.marginal <- rbind(m.set.marginal.f1, m.set.marginal.f2, m.set.marginal.f3)

m.set.marginal.condition <- summarySE(m.set.marginal, measurevar="normalizedProb",
                                      groupvars=c("metaphor", "qud", "featureNum"))

m.set.marginal.condition$qud <- factor(m.set.marginal.condition$qud, labels=c("Vague", "Specific"))
m.set.marginal.condition$metaphor <- factor(m.set.marginal.condition$metaphor, 
                                            labels=c("Literal", "Metaphorical"))
ggplot(m.set.marginal.condition, aes(x=qud, y=normalizedProb, fill=featureNum)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=normalizedProb-se, ymax=normalizedProb+se), position=position_dodge(0.9), width=0.2) +
  theme_bw() +
  facet_grid(.~ metaphor) +
  scale_fill_brewer(name="Features", palette="RdGy") +
  facet_grid(.~ metaphor) +
  xlab("QUD") +
  ylab("Normalized probability") +
  ylim(c(0, 1))

############################
# Fit model
############################
m.metaphor <- subset(m.set.long.summary, metaphor==1)

# Get all the names of the model files to fit
#filenames <- read.csv("../../Model/Alternatives/combinedOutputFilenames.txt", header=FALSE)
filenames <- read.csv("../../Model/CogSciModel/combinedOutputFilenames.txt", header=FALSE)
#filenames <- read.csv("../../Model/NoAlternatives/combinedOutputFilenames.txt", header=FALSE)
#filenames <- read.csv("../../Model/LiteralAdjectives/combinedOutputFilenames.txt", header=FALSE)
max.cor <- 0
max.name <- ""
for (n in filenames$V1) {
  if (grepl("g", n)) {
    name.qud <- n
    name.noQud <- paste("noQud-a", as.list(strsplit(n, "a"))[[1]][2], sep="")
    #m.qud <- read.csv(paste("../../Model/Alternatives/CombinedOutput/", name.qud, sep=""), header=FALSE)
    #m.noQud <- read.csv(paste("../../Model/Alternatives/CombinedOutput/",name.noQud, sep=""), header=FALSE)
    m.qud <- read.csv(paste("../../Model/CogSciModel/CombinedOutput/", name.qud, sep=""), header=FALSE)
    m.noQud <- read.csv(paste("../../Model/CogSciModel/CombinedOutput/", name.noQud, sep=""), header=FALSE)
    #m.qud <- read.csv(paste("../../Model/NoAlternatives/CombinedOutput/", name.qud, sep=""), header=FALSE)
    #m.noQud <- read.csv(paste("../../Model/NoAlternatives/CombinedOutput/", name.noQud, sep=""), header=FALSE)
    #m.qud <- read.csv(paste("../../Model/LiteralAdjectives/CombinedOutputMetaphor/", name.qud, sep=""), header=FALSE)
    #m.noQud <- read.csv(paste("../../Model/LiteralAdjectives/CombinedOutputMetaphor/", name.noQud, sep=""), header=FALSE)
    
    #### No goal distinction ####
     colnames(m.qud) <- c("category", "f1", "f2", "f3", "modelProb", "categoryID")
     colnames(m.noQud) <- c("category", "f1", "f2", "f3", "modelProb", "categoryID")
    #############################
    #### With goal distinction ####
    #colnames(m.qud) <- c("category", "f1", "f2", "f3", "goal", "modelProb", "categoryID")
    #colnames(m.noQud) <- c("category", "f1", "f2", "f3", "goal", "modelProb", "categoryID")
    
    ############################
    
    m.qud$qud <- "1"
    m.noQud$qud <- "0"
    m <- rbind(m.qud, m.noQud)
    #m$featureSetNum <- factor(m$featureSetNum, labels=c("1,1,1", "1,1,0", "1,0,1", "1,0,0",
    #                                                    "0,1,1", "0,1,0", "0,0,1", "0,0,0"))
    m <- join(m, mapping, by=c("f1", "f2", "f3"))
    model.agg <- aggregate(data=m, modelProb ~ categoryID + featureSetNum + qud, FUN=sum)
    compare.set <- join(m.metaphor, model.agg, by=c("categoryID", "featureSetNum", "qud"))
    cor <- with(compare.set, cor(normalizedProb, modelProb))
    if (cor > max.cor) {
      max.cor <- cor
      max.name <- name.qud
      best <- compare.set
      best.model <- m
    }
  }
}
with(best, cor.test(normalizedProb, modelProb))

best$qud <- factor(best$qud)
best$featureSetNum <- factor(best$featureSetNum, 
                             labels=c("1,1,1", "1,1,0", "1,0,1", "1,0,0",
                                    "0,1,1", "0,1,0", "0,0,1", "0,0,0"))

#########################
# Just metaphor
#########################
best.met <- subset(best, metaphor=="1")
best.met.summary <- summarySE(best, measurevar="modelProb", 
                              groupvars=c("qud", "featureSetNum"))
ggplot(best.met.summary, aes(x=qud, y=modelProb, fill=featureSetNum)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=modelProb-se, ymax=modelProb+se), position=position_dodge(0.9), width=0.2) +
  theme_bw() +
  scale_fill_brewer(palette="RdGy")


ggplot(best, aes(x=modelProb, y=normalizedProb, color=featureSetNum, shape=qud)) +
  #geom_errorbar(aes(ymin=normalizedProb-se, ymax=normalizedProb+se), color="grey") +
  #geom_text(aes(label=animal)) +
  geom_point(size=2.5) +
  theme_bw() +
  scale_color_brewer(name="Feature sets", palette="RdGy") +
  xlab("Model") +
  ylab("Human")

best.qud <- subset(best, qud=="1")
with(best.qud, cor.test(normalizedProb, modelProb))
ggplot(best.qud, aes(x=modelProb, y=normalizedProb, color=featureSetNum)) +
  geom_errorbar(aes(ymin=normalizedProb-se, ymax=normalizedProb+se), color="grey") +
  geom_point(size=2.5) +
  #geom_text(aes(label=animal)) +
  theme_bw()

best.noQud <- subset(best, qud=="0")
with(best.noQud, cor.test(normalizedProb, modelProb))
ggplot(best.noQud, aes(x=modelProb, y=normalizedProb, color=featureSetNum)) +
  geom_errorbar(aes(ymin=normalizedProb-se, ymax=normalizedProb+se), color="grey") +
  geom_point(size=2.5) +
  #geom_text(aes(label=animal)) +
  theme_bw()

#### MARGINAL ####
best.marginal.f1 <- aggregate(data=subset(best, f1==1), 
                                     normalizedProb ~ categoryID + animal + qud,
                                     FUN=sum)
best.marginal.f1$featureNum <- "1"
best.marginal.f2 <- aggregate(data=subset(best, f2==1), 
                                     normalizedProb ~ categoryID + animal + qud,
                                     FUN=sum)
best.marginal.f2$featureNum <- "2"
best.marginal.f3 <- aggregate(data=subset(best, f3==1), 
                                     normalizedProb ~ categoryID + animal + qud,
                                     FUN=sum)
best.marginal.f3$featureNum <- "3"

best.marginal <- rbind(best.marginal.f1, best.marginal.f2, best.marginal.f3)

best.model.marginal.f1 <- aggregate(data=subset(best, f1==1), 
                                     modelProb ~ categoryID + animal + qud,
                                     FUN=sum)
best.model.marginal.f1$featureNum <- "1"
best.model.marginal.f2 <- aggregate(data=subset(best, f2==1), 
                                     modelProb ~ categoryID + animal + qud,
                                     FUN=sum)
best.model.marginal.f2$featureNum <- "2"
best.model.marginal.f3 <- aggregate(data=subset(best, f3==1), 
                                     modelProb ~ categoryID + animal + qud,
                                     FUN=sum)
best.model.marginal.f3$featureNum <- "3"

best.model.marginal <- rbind(best.model.marginal.f1, best.model.marginal.f2, best.model.marginal.f3)

compare.marginal <- join(best.marginal, best.model.marginal, 
                         by=c("categoryID", "animal", "qud", "featureNum"))
with(compare.marginal, cor.test(normalizedProb, modelProb))
with(subset(compare.marginal, featureNum=="1"), cor.test(normalizedProb, modelProb))
with(subset(compare.marginal, featureNum=="2"), cor.test(normalizedProb, modelProb))
with(subset(compare.marginal, featureNum=="3"), cor.test(normalizedProb, modelProb))

ggplot(compare.marginal, aes(x=modelProb, y=normalizedProb, color=featureNum, shape=qud)) +
  geom_point() +
  geom_text(aes(label=animal)) +
  theme_bw()

####################################
# Add priors
####################################
# priors <- read.csv("../FeaturePriorExp/featurePriors-set.csv")
# priors$N <- NULL
# priors$sd <- NULL
# priors$se <- NULL
# priors$ci <- NULL
# priors.a <- subset(priors, type=="animal")
# priors.p <- subset(priors, type=="person")
# colnames(priors.a)[5] <- "animalPrior"
# colnames(priors.p)[5] <- "personPrior"
# best <- join(best, priors.a, by=c("categoryID", "animal", "featureSetNum"))
# best <- join(best, priors.p, by=c("categoryID", "animal", "featureSetNum"))

priors <- read.csv("../AlternativesExp/Priors/featurePriors-set-wide-noAlt.csv")
priors <- melt(priors, id=c("categoryID", "animal", "featureNum", "alternative"))
priors$featureSetNum <- unlist(lapply(strsplit(as.character(priors$variable), "normalizedProb."), "[", 2))
priors$variable <- NULL
priors.a <- subset(priors, alternative!="person")
priors.p <- subset(priors, alternative=="person")
colnames(priors.a)[5] <- "animalPrior"
colnames(priors.p)[5] <- "personPrior"
best <- join(best, priors.a, by=c("categoryID", "animal", "featureSetNum"))
best <- join(best, priors.p, by=c("categoryID", "animal", "featureSetNum"))

with(best, cor.test(animalPrior, normalizedProb))

ggplot(best, aes(x=animalPrior, y=normalizedProb, color=featureSetNum, shape=qud)) +
  #geom_errorbar(aes(ymin=normalizedProb-se, ymax=normalizedProb+se), color="grey") +
  geom_point(size=2.5) +
  theme_bw()

with(subset(best, qud=="0"), cor.test(animalPrior, normalizedProb))
with(subset(best, qud=="1"), cor.test(animalPrior, normalizedProb))

with(subset(best, featureSetNum==1), cor.test(animalPrior, normalizedProb))
with(subset(best, featureSetNum==1), cor.test(modelProb, normalizedProb))
with(subset(best, featureSetNum==2), cor.test(animalPrior, normalizedProb))
with(subset(best, featureSetNum==2), cor.test(modelProb, normalizedProb))
with(subset(best, featureSetNum==3), cor.test(animalPrior, normalizedProb))
with(subset(best, featureSetNum==3), cor.test(modelProb, normalizedProb))
with(subset(best, featureSetNum==4), cor.test(animalPrior, normalizedProb))
with(subset(best, featureSetNum==4), cor.test(modelProb, normalizedProb))
with(subset(best, featureSetNum==5), cor.test(animalPrior, normalizedProb))
with(subset(best, featureSetNum==5), cor.test(modelProb, normalizedProb))
with(subset(best, featureSetNum==6), cor.test(animalPrior, normalizedProb))
with(subset(best, featureSetNum==6), cor.test(modelProb, normalizedProb))
with(subset(best, featureSetNum==7), cor.test(animalPrior, normalizedProb))
with(subset(best, featureSetNum==7), cor.test(modelProb, normalizedProb))
with(subset(best, featureSetNum==8), cor.test(animalPrior, normalizedProb))
with(subset(best, featureSetNum==8), cor.test(modelProb, normalizedProb))

summary(lm(data=best, normalizedProb ~ animalPrior + personPrior))

##############
# Check correlation between marginal and joint experiments
##############
compare.marginaljoint <- join(d.met.summary, compare.marginal, by=c("categoryID", "animal", "qud",
                                                                    "featureNum"))

with(compare.marginaljoint, cor.test(normalizedProb, featureProb))
with(subset(compare.marginaljoint, featureNum=="1"), cor.test(normalizedProb, featureProb))
with(subset(compare.marginaljoint, featureNum=="2"), cor.test(normalizedProb, featureProb))
with(subset(compare.marginaljoint, featureNum=="3"), cor.test(normalizedProb, featureProb))
ggplot(compare.marginaljoint, aes(x=normalizedProb, y=featureProb, color=featureNum)) +
  geom_point() +
  theme_bw()

#########################
# Model with literal adjectives
#########################

name.qud <- max.name
name.noQud <- paste("noQud-a", as.list(strsplit(n, "a"))[[1]][2], sep="")
met.qud <- read.csv(paste("../../Model/LiteralAdjectives/CombinedOutputMetaphor/", name.qud, sep=""), header=FALSE)
met.noQud <- read.csv(paste("../../Model/LiteralAdjectives/CombinedOutputMetaphor/", name.noQud, sep=""), header=FALSE)
lit.qud <- read.csv(paste("../../Model/LiteralAdjectives/CombinedOutputLiteral/", name.qud, sep=""), header=FALSE)
lit.noQud <- read.csv(paste("../../Model/LiteralAdjectives/CombinedOutputLiteral/", name.noQud, sep=""), header=FALSE)

#### With goal distinction ####
colnames(met.qud) <- c("category", "f1", "f2", "f3", "goal", "modelProb", "categoryID")
colnames(met.noQud) <- c("category", "f1", "f2", "f3", "goal", "modelProb", "categoryID")
colnames(lit.qud) <- c("category", "f1", "f2", "f3", "goal", "modelProb", "categoryID")
colnames(lit.noQud) <- c("category", "f1", "f2", "f3", "goal", "modelProb", "categoryID")
met.qud$qud <- "1"
met.noQud$qud <- "0"
lit.qud$qud <- "1"
lit.noQud$qud <- "0"
met.qud$metaphor <- "1"
met.noQud$metaphor <- "1"
lit.qud$metaphor <- "0"
lit.noQud$metaphor <- "0"
model.lit.met <- rbind(met.qud, met.noQud, lit.qud, lit.noQud)
model.lit.met <- join(model.lit.met, mapping, by=c("f1", "f2", "f3"))

agg.goal <- aggregate(data=model.lit.met, modelProb ~ 
                        f1 + f2 + f3 + categoryID + qud + metaphor + featureSetNum, FUN=sum)
agg.goal$featureSetNum <- factor(agg.goal$featureSetNum)

###################
# Literal analysis
###################

agg.goal.lit <- subset(agg.goal, metaphor=="0")
agg.goal.lit$qud <- factor(agg.goal.lit$qud)
agg.goal.lit$metaphor <- factor(agg.goal.lit$metaphor)
m.lit <- subset(m.set.long.summary, metaphor=="0")
m.lit$qud <- factor(m.lit$qud)
m.lit$metaphor <- factor(m.lit$metaphor)
m.lit$categoryID <- factor(m.lit$categoryID)
compare.lit <- join(agg.goal.lit, m.lit, by=c("categoryID", "qud", "metaphor", "featureSetNum", 
                                              "f1", "f2", "f3"))

with(compare.lit, cor.test(modelProb, normalizedProb))
ggplot(compare.lit, aes(x=modelProb, y=normalizedProb, color=featureSetNum, shape=qud)) +
  #geom_errorbar(aes(ymin=normalizedProb-se, ymax=normalizedProb+se), color="grey") +
  geom_text(aes(label=animal)) +
  #geom_point(size=2.5) +
  theme_bw() +
  scale_color_brewer(name="Feature sets", palette="RdGy") +
  xlab("Model") +
  ylab("Human")

with(subset(compare.lit, f1=="1"), cor.test(modelProb, normalizedProb))
with(subset(compare.lit, f1=="0"), cor.test(modelProb, normalizedProb))

#######################
# Condition analysis
#######################
agg.goal.condition <- summarySE(agg.goal, measurevar="modelProb", 
                                groupvars=c("qud", "metaphor", "featureSetNum"))

agg.goal.condition$featureSetNum <- factor(agg.goal.condition$featureSetNum, 
                             labels=c("1,1,1", "1,1,0", "1,0,1", "1,0,0",
                                      "0,1,1", "0,1,0", "0,0,1", "0,0,0"))
agg.goal.condition$qud <- factor(agg.goal.condition$qud, labels=c("Vague", "Specific"))
agg.goal.condition$metaphor <- factor(agg.goal.condition$metaphor, labels=c("Literal", "Metaphorical"))
ggplot(agg.goal.condition, aes(x=qud, y=modelProb, fill=featureSetNum)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=modelProb-se, ymax=modelProb+se), position=position_dodge(0.9), width=0.2) +
  facet_grid(.~metaphor) +
  scale_fill_brewer(name="Feature sets", palette="RdGy") +
  theme_bw()

#########################
# Goal analysis
#########################
agg.goalAnalysis <- aggregate(data=model.lit.met, modelProb ~ 
                                categoryID + qud + metaphor + goal, FUN=sum)
agg.goalAnalysis.condition <- summarySE(agg.goalAnalysis, measurevar="modelProb",
                                      groupvars=c("qud", "metaphor", "goal"))
agg.goalAnalysis.condition$qud <- factor(agg.goalAnalysis.condition$qud, labels=c("Vague", "Specific"))
agg.goalAnalysis.condition$metaphor <- factor(agg.goalAnalysis.condition$metaphor, 
                                              labels=c("Literal", "Metaphorical"))
agg.goalAnalysis.condition$goal <- factor(agg.goalAnalysis.condition$goal,
                                          levels=c("goal-f1", "goal-f2", "goal-f3", 
                                                   "goal-f1-f2", "goal-f1-f3", "goal-f2-f3",
                                                   "goal-all"))

ggplot(agg.goalAnalysis.condition, aes(x=qud, y=modelProb, fill=goal)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=modelProb-se, ymax=modelProb+se), 
                position=position_dodge(0.9), width=0.2) +
  facet_grid(.~metaphor) +
  scale_fill_brewer(palette="Set2") +
  theme_bw()

