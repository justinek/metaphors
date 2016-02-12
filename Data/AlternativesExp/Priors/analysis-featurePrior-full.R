source("summarySE.R")

############################################################
# Feature set priors
###########################################################
library(reshape)
library(ggplot2)
fp.set <- read.csv("long-random-100.csv")

#########################
# Long form
########################

fp.set.long <- melt(fp.set, id=c("workerid", "gender", "age", "income", "categoryID", "order", "animal", "featureNum", "alternative"))
fp.set.long$featureSetNum <- unlist(lapply(strsplit(as.character(fp.set.long$variable), "X"), "[", 2))

###################################
# Check distribution of ratings
###################################
#***** extremes *********
nrow(subset(fp.set.long, value==0)) / nrow(fp.set.long) # 6%
nrow(subset(fp.set.long, value==1)) / nrow(fp.set.long) # 2%

#***** everything ********
ggplot(fp.set.long, aes(x=value)) +
  theme_bw() +
  facet_grid(featureSetNum ~.) +
  #geom_histogram(binwidth=0.05) +
  geom_bar(aes(y = (..count..)/sum(..count..)), binwidth=0.05) +
  xlab("Proportion on slider") +
  ylab("Count (%)")


#***** just person ********
ggplot(subset(fp.set.long, alternative=="person"), aes(x=value)) +
  theme_bw() +
  #geom_histogram(binwidth=0.05)
  geom_bar(aes(y = (..count..)/sum(..count..)), binwidth=0.05) +
  facet_grid(featureSetNum ~.) +
  xlab("Proportion on slider") +
  ylab("Count (%)")
  #geom_density()

#***** just target ********
ggplot(subset(fp.set.long, featureNum=="0" & alternative!="person"), aes(x=value)) +
  theme_bw() +
  geom_bar(aes(y = (..count..)/sum(..count..)), binwidth=0.05) +
  facet_grid(featureSetNum ~.) +
  xlab("Proportion on slider") +
  ylab("Count (%)")

###################################
# No sigmoid
###################################
# normalize to sum ratings for each person/animal in each trial to 1
# get noramlizing factor by summing ratigs for each subject/category/type
fp.set.normalizing <- aggregate(data=fp.set.long, value ~ workerid + categoryID + animal + featureNum + alternative, FUN=sum)
colnames(fp.set.normalizing)[6] <- "normalizing"
fp.set.long <- join(fp.set.long, fp.set.normalizing, by=c("workerid", "categoryID", "animal", "featureNum", "alternative"))
# filter out rows with 0 as normalizer
fp.set.long <- subset(fp.set.long, normalizing != 0)
fp.set.long$normalizedProb <- fp.set.long$value / fp.set.long$normalizing

################################
# sigmoid transformation
################################
fp.set.long$sigProb <- 1 / (1 + exp(1)^(-4*(fp.set.long$value - 0.5)))

# normalize for sigmoid
fp.set.normalizing.sig <- aggregate(data=fp.set.long, sigProb ~ workerid + categoryID + animal + featureNum + alternative, FUN=sum)
colnames(fp.set.normalizing.sig)[6] <- "normalizing.sig"
fp.set.long <- join(fp.set.long, fp.set.normalizing.sig, by=c("workerid", "categoryID", "animal", "featureNum", "alternative"))
# filter out rows with 0 as normalizer
fp.set.long <- subset(fp.set.long, normalizing != 0)
fp.set.long$normalizedProb.sig <- fp.set.long$sigProb / fp.set.long$normalizing.sig


fp.set.long.summary <- summarySE(data=fp.set.long, measurevar="normalizedProb", 
                                 groupvars=c("categoryID", "featureSetNum", "animal", "featureNum", "alternative"))

fp.set.long.sig.summary <- summarySE(data=fp.set.long, measurevar="normalizedProb.sig",
                                 groupvars=c("categoryID", "featureSetNum", "animal", "featureNum", "alternative"))

################
# sanity check
################

fp.set.sanity <- subset(fp.set.long.summary, animal=="owl")

ggplot(fp.set.sanity, aes(x=featureSetNum, y=normalizedProb, fill=featureSetNum)) +
  geom_bar(stat="identity", color="black") + 
  geom_errorbar(aes(ymin=normalizedProb-se, ymax=normalizedProb+se)) +
  facet_grid(featureNum ~ alternative)

############
# Check marginals
############

mapping <- read.csv("../../FeaturePriorExp/featureSetMapping.csv")
mapping$featureSetNum <- factor(mapping$featureSetNum)
fp.set.long.summary <- join(fp.set.long.summary, mapping, by=c("featureSetNum"))
fp.set.marginal.f1 <- aggregate(data=subset(fp.set.long.summary, f1==1), 
                                            normalizedProb ~ categoryID + animal + featureNum + alternative,
                                FUN=sum)
fp.set.marginal.f1$marginal <- "f1"
fp.set.marginal.f2 <- aggregate(data=subset(fp.set.long.summary, f2==1), 
                                normalizedProb ~ categoryID + animal + featureNum + alternative,
                                FUN=sum)
fp.set.marginal.f2$marginal <- "f2"
fp.set.marginal.f3 <- aggregate(data=subset(fp.set.long.summary, f3==1), 
                                normalizedProb ~ categoryID + animal + featureNum + alternative,
                                FUN=sum)
fp.set.marginal.f3$marginal <- "f3"

fp.set.marginal <- rbind(fp.set.marginal.f1, fp.set.marginal.f2, fp.set.marginal.f3)

# sanity check
fp.set.marginal.sanity <- subset(fp.set.marginal, animal=="zebra")

ggplot(fp.set.marginal.sanity, aes(x=marginal, y=normalizedProb, fill=marginal)) +
  geom_bar(stat="identity", color="black") + 
  facet_grid(featureNum ~ alternative)


############################
# Check marginals for sigmoid transformation
############################

fp.set.long.sig.summary <- join(fp.set.long.sig.summary, mapping, by=c("featureSetNum"))
fp.set.sig.marginal.f1 <- aggregate(data=subset(fp.set.long.sig.summary, f1==1), 
                                normalizedProb.sig ~ categoryID + animal + featureNum + alternative,
                                FUN=sum)
fp.set.sig.marginal.f1$marginal <- "f1"
fp.set.sig.marginal.f2 <- aggregate(data=subset(fp.set.long.sig.summary, f2==1), 
                                normalizedProb.sig ~ categoryID + animal + featureNum + alternative,
                                FUN=sum)
fp.set.sig.marginal.f2$marginal <- "f2"
fp.set.sig.marginal.f3 <- aggregate(data=subset(fp.set.long.sig.summary, f3==1), 
                                normalizedProb.sig ~ categoryID + animal + featureNum + alternative,
                                FUN=sum)
fp.set.sig.marginal.f3$marginal <- "f3"

fp.set.sig.marginal <- rbind(fp.set.sig.marginal.f1, fp.set.sig.marginal.f2, fp.set.sig.marginal.f3)

# sanity check
fp.set.sig.marginal.sanity <- subset(fp.set.sig.marginal, animal=="zebra")

ggplot(fp.set.sig.marginal.sanity, aes(x=marginal, y=normalizedProb.sig, fill=marginal)) +
  geom_bar(stat="identity", color="black") + 
  facet_grid(featureNum ~ alternative)

#write.csv(fp.set.long.summary, "featurePriors-set-transformed.csv", row.names=FALSE)

####################################
# Split half
####################################
prophet <- function(r, n) {
  return ((n*r) / (1 + (n-1)*r))
}

fp.cors <- data.frame(cors=NULL, proph=NULL)            
for (t in seq(1, 10)) {
  ii <- seq_len(nrow(fp.set.long))
  ind1 <- sample(ii, nrow(fp.set.long) / 2) 
  ind2 <- ii[!ii %in% ind1] 
  p1 <- fp.set.long[ind1, ] 
  p2 <- fp.set.long[ind2, ]
  #p1.summary <- summarySE(fp.set.long, measurevar="normalizedProb", groupvars=c("categoryID", "type", "featureSetNum"))
  p1.summary <- summarySE(p1, measurevar="normalizedProb", groupvars=c("categoryID", "animal", "featureNum", "alternative", "featureSetNum"))
  p2.summary <- summarySE(p2, measurevar="normalizedProb", groupvars=c("categoryID", "animal", "featureNum", "alternative", "featureSetNum"))
  colnames(p1.summary)[7] <- "p1prob"
  colnames(p2.summary)[7] <- "p2prob"
  fp.splithalf.comp <- join(p1.summary, p2.summary, by=c("categoryID", "animal", "featureSetNum", "alternative", "featureNum"))
  fp.splithalf.comp <- fp.splithalf.comp[complete.cases(fp.splithalf.comp),]
  this.cor <- with(fp.splithalf.comp, cor(p1prob, p2prob))
  fp.cor <- data.frame(cors=this.cor, proph=prophet(this.cor, 2))
  fp.cors <- rbind(fp.cor, fp.cors)
}

fp.set.long.summary <- summarySE(data=fp.set.long, measurevar="normalizedProb", 
                                 groupvars=c("categoryID", "featureSetNum", "animal", "featureNum", "alternative"))

####################
# Join with priors on target animals
###################
# target.priors <- read.csv("../../FeaturePriorExp/featurePriors-set.csv")
# target.priors$animal <- factor(target.priors$animal)
# target.priors$alternative <- ifelse(target.priors$type=="animal", "target", "person")
# target.priors$type <- NULL
# target.priors$featureNum <- 0
# 
# priors.full <- rbind(target.priors, fp.set.long.summary)
# priors.full <- priors.full[with(priors.full, order(categoryID, featureNum, alternative, featureSetNum)),]

#####################
# Write in long form
#####################
#write.csv(fp.set.long.summary, "featurePriors-set.csv", row.names=FALSE)

####################
# Convert to wide form
####################
priors.full.wide <- reshape(fp.set.long.summary, v.names="normalizedProb", direction="wide", 
                               timevar="featureSetNum", idvar=c("categoryID", "alternative", "featureNum"), drop=c("N", "sd", "se", "ci",
                                                                               "f1", "f2", "f3"))
write.csv(priors.full.wide, "featurePriors-set-wide-full-random.csv", row.names=FALSE)
###################
# Do not take alternatives
###################
priors.full.wide.noAlt <- subset(priors.full.wide, featureNum=="0")
priors.full.wide.noAlt$target <- ifelse(priors.full.wide.noAlt$alternative=="person", "person", "target")

write.csv(priors.full.wide.noAlt, "featurePriors-set-wide-noAlt.csv", row.names=FALSE)

## visualize an example
fp.set.example <- subset(fp.set.long.summary, animal=="elephant")
ggplot(fp.set.example, aes(x=featureSetNum, y=normalizedProb, fill=featureSetNum)) +
  geom_bar(stat="identity", color="black") +
  geom_errorbar(aes(ymin=normalizedProb-se, ymax=normalizedProb+se), width=0.2) +
  theme_bw() +
  scale_fill_brewer(palette="Accent", guide=FALSE)

################################
## compute marginal prob for each feature
################################
mapping <- read.csv("../../FeaturePriorExp/featureSetMapping.csv")
mapping$featureSetNum <- factor(mapping$featureSetNum)
fp.set.long.summary <- join(fp.set.long.summary, mapping, by=c("featureSetNum"))

# # check anti-correlations with f1
# fp.set.f1 <- subset(fp.set.long.summary, f1==1)
# fp.set.notf1 <- subset(fp.set.long.summary, f1==0)
# 
# # f2 anticorrelations
# fp.set.f2givenf1 <- aggregate(data=fp.set.f1, normalizedProb ~ categoryID + type + f2, FUN=sum)
# colnames(fp.set.f2givenf1)[4] <- "probGivenf1"
# fp.set.f2givennotf1 <- aggregate(data=fp.set.notf1, normalizedProb ~ categoryID + type + f2, FUN=sum)
# colnames(fp.set.f2givennotf1)[4] <- "probGivenNotf1"
# fp.set.f2givenf1.compare <-join(fp.set.f2givenf1, fp.set.f2givennotf1, by=c("categoryID", "type", "f2"))
# fp.set.f2givenf1.compare.person.anti <- subset(fp.set.f2givenf1.compare, type=="person" & f2==1 & probGivenf1 < probGivenNotf1)
# fp.set.f2givenf1.compare.animal.anti <- subset(fp.set.f2givenf1.compare, type=="animal" & f2==1 & probGivenf1 < probGivenNotf1)
# # add feature names
# featureNames <- data.frame(categoryID=fp.summary$categoryID, animal=fp.summary$animal, 
#                            feature1=fp.summary$f1, feature2=fp.summary$f2, feature3=fp.summary$f3)
# fp.set.f2givenf1.compare.person.anti <- join(fp.set.f2givenf1.compare.person.anti, featureNames, by=c("categoryID"), match="first")
# fp.set.f2givenf1.compare.animal.anti <- join(fp.set.f2givenf1.compare.animal.anti, featureNames, by=c("categoryID"), match="first")
# 
# # f3 anticorrelations
# fp.set.f3givenf1 <- aggregate(data=fp.set.f1, normalizedProb ~ categoryID + type + f3, FUN=sum)
# colnames(fp.set.f3givenf1)[4] <- "probGivenf1"
# fp.set.f3givennotf1 <- aggregate(data=fp.set.notf1, normalizedProb ~ categoryID + type + f3, FUN=sum)
# colnames(fp.set.f3givennotf1)[4] <- "probGivenNotf1"
# fp.set.f3givenf1.compare <-join(fp.set.f3givenf1, fp.set.f3givennotf1, by=c("categoryID", "type", "f3"))
# fp.set.f3givenf1.compare.person.anti <- subset(fp.set.f3givenf1.compare, type=="person" & f3==1 & probGivenf1 < probGivenNotf1)
# fp.set.f3givenf1.compare.animal.anti <- subset(fp.set.f3givenf1.compare, type=="animal" & f3==1 & probGivenf1 < probGivenNotf1)
# # add feature names
# fp.set.f3givenf1.compare.person.anti <- join(fp.set.f3givenf1.compare.person.anti, featureNames, by=c("categoryID"), match="first")
# fp.set.f3givenf1.compare.animal.anti <- join(fp.set.f3givenf1.compare.animal.anti, featureNames, by=c("categoryID"), match="first")
# 

################################
# compute marginals
################################
fp.set.marginal.f1 <- aggregate(data=fp.set.long.summary, normalizedProb ~ categoryID + f1 + animal, FUN=sum) 
fp.set.marginal.f1$featureNum <- "1"
colnames(fp.set.marginal.f1)[2] <- "featurePresent"
fp.set.marginal.f2 <- aggregate(data=fp.set.long.summary, normalizedProb ~ categoryID + f2 + animal, FUN=sum) 
fp.set.marginal.f2$featureNum <- "2"
colnames(fp.set.marginal.f2)[2] <- "featurePresent"
fp.set.marginal.f3 <- aggregate(data=fp.set.long.summary, normalizedProb ~ categoryID + f3 + animal, FUN=sum) 
fp.set.marginal.f3$featureNum <- "3"
colnames(fp.set.marginal.f3)[2] <- "featurePresent"
fp.set.marginal <- rbind(fp.set.marginal.f1, fp.set.marginal.f2, fp.set.marginal.f3)
fp.set.marginal.present <- subset(fp.set.marginal, featurePresent==1)

fp.set.marginal.present <- fp.set.marginal.present[with(fp.set.marginal.present, 
                                                        order(categoryID, animal, featureNum)), ]

ggplot(fp.set.marginal.present, aes(x=featureNum, y=normalizedProb, fill=featureNum)) +
  geom_bar(stat="identity", color="black", position=position_dodge(), width=0.9) +
  #geom_errorbar(aes(ymin=normalizedProb-se, ymax=normalizedProb+se), width=0.2, position=position_dodge(0.9)) +
  facet_grid(.~animal) +
  theme_bw() +
  xlab("") +
  ylab("Probability of feature given category") +
  ylim(c(0, 1)) +
  scale_x_discrete(labels=c("f1", "f2", "f3"))




