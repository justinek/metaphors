source("summarySE.R")
fp <- read.csv("data40-names-long.csv")

# check the shape of the ratings distribution
fp.dist <- rbind(data.frame(prob=fp[,11], feature="f1_animal"), 
                 data.frame(prob=fp[,12], feature="f2_animal"),
                 data.frame(prob=fp[,13], feature="f3_animal"),
                 data.frame(prob=fp[,14], feature="f1_person"),
                 data.frame(prob=fp[,15], feature="f2_person"),
                 data.frame(prob=fp[,16], feature="f3_person"))

ggplot(fp.dist, aes(x=prob, fill=feature)) +
  geom_histogram(binwidth=0.05)

fp.f1.a.summary <- summarySE(fp, measurevar="f1prob_animal", groupvars=c("categoryID", "animal", "f1", "f2", "f3"))
colnames(fp.f1.a.summary)[7] <- "featureProb"
fp.f1.a.summary$feature <- fp.f1.a.summary$f1
fp.f1.a.summary$featureNum <- 1
fp.f1.a.summary$category <- "animal"

fp.f2.a.summary <- summarySE(fp, measurevar="f2prob_animal", groupvars=c("categoryID", "animal", "f1", "f2", "f3"))
colnames(fp.f2.a.summary)[7] <- "featureProb"
fp.f2.a.summary$feature <- fp.f2.a.summary$f2
fp.f2.a.summary$featureNum <- 2
fp.f2.a.summary$category <- "animal"

fp.f3.a.summary <- summarySE(fp, measurevar="f3prob_animal", groupvars=c("categoryID", "animal", "f1", "f2", "f3"))
colnames(fp.f3.a.summary)[7] <- "featureProb"
fp.f3.a.summary$feature <- fp.f3.a.summary$f3
fp.f3.a.summary$featureNum <- 3
fp.f3.a.summary$category <- "animal"

fp.f1.p.summary <- summarySE(fp, measurevar="f1prob_person", groupvars=c("categoryID", "animal", "f1", "f2", "f3"))
colnames(fp.f1.p.summary)[7] <- "featureProb"
fp.f1.p.summary$feature <- fp.f1.p.summary$f1
fp.f1.p.summary$featureNum <- 1
fp.f1.p.summary$category <- "person"

fp.f2.p.summary <- summarySE(fp, measurevar="f2prob_person", groupvars=c("categoryID", "animal", "f1", "f2", "f3"))
colnames(fp.f2.p.summary)[7] <- "featureProb"
fp.f2.p.summary$feature <- fp.f2.p.summary$f2
fp.f2.p.summary$featureNum <- 2
fp.f2.p.summary$category <- "person"

fp.f3.p.summary <- summarySE(fp, measurevar="f3prob_person", groupvars=c("categoryID", "animal", "f1", "f2", "f3"))
colnames(fp.f3.p.summary)[7] <- "featureProb"
fp.f3.p.summary$feature <- fp.f3.p.summary$f3
fp.f3.p.summary$featureNum <- 3
fp.f3.p.summary$category <- "person"

fp.summary <- rbind(fp.f1.a.summary, fp.f2.a.summary, fp.f3.a.summary, 
                    fp.f1.p.summary, fp.f2.p.summary, fp.f3.p.summary)

fp.summary <- fp.summary[with(fp.summary, order(categoryID, category, featureNum)), ]

fp.summary.summary <- summarySE(fp.summary, measurevar="featureProb", groupvars=c("category", "featureNum"))
fp.summary.summary$featureLabel <- factor(fp.summary.summary$featureNum, labels=c("f1", "f2", "f3"))
ggplot(fp.summary.summary, aes(x=category, y=featureProb, fill=featureLabel)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=featureProb-se, ymax=featureProb+se), width=0.2, position=position_dodge(0.9)) +
  theme_bw() +
  xlab("") +
  scale_fill_brewer(palette="Accent", name="Feature")      
                                            
##############
# Temporary hack, be careful!!!!!!
##############
fp.summary.nonames <- fp.summary
fp.names.comp <- join(fp.summary.nonames, fp.summary, by=c("categoryID", "animal", "feature", "featureNum", "category"))
colnames(fp.names.comp)[7] <- "prob.nonames"
colnames(fp.names.comp)[9] <- "se.nonames"
colnames(fp.names.comp)[18] <- "prob.names"
colnames(fp.names.comp)[20] <- "se.names"

with(fp.names.comp, cor.test(prob.nonames, prob.names))
ggplot(fp.names.comp, aes(x=prob.nonames, y=prob.names, color=category)) +
  geom_text(aes(label=feature)) +
  geom_point() +
  geom_errorbar(aes(ymin=prob.names-se.names, ymax=prob.names+se.names)) + 
  geom_errorbarh(aes(xmin=prob.nonames-se.nonames, xmax=prob.nonames+se.nonames)) + 
  theme_bw()

# convert back to probability space
fp.summary.prob <- fp.summary
fp.summary.prob$featureProb <- pnorm(fp.summary$featureProb)


write.csv(fp.summary.prob, row.names = FALSE, file="featurePriors-names-zscored.csv")
#########
# Visualize examples
#########

this.ID <- 22
fp.example <- subset(fp.summary, this.ID==categoryID)
fp.example$feature <- factor(fp.example$feature, 
                             levels=c(as.vector(fp.example$f1)[1], 
                                      as.vector(fp.example$f2[1]), as.vector(fp.example$f3[1])))
animal <- as.vector(fp.example$animal)[1]
ggplot(fp.example, aes(x=feature, y=featureProb, fill=feature)) +
  geom_bar(stat="identity", color="black") +
  geom_errorbar(aes(ymin=featureProb-se, ymax=featureProb+se), width=0.2) +
  facet_grid(.~category) +
  theme_bw() +
  scale_fill_brewer(palette="Accent", guide=FALSE) +
  #ylim(c(0,1)) +
  ggtitle(animal)

#####################
# Feature set priors
######################
library(reshape)
fp.set <- read.csv("data60-set-long.csv")

#fp.set.means <- aggregate(.~ categoryID + animal, data=fp.set, FUN=mean)
#write.csv(fp.set.means, "featurePriors-set.csv", row.names=FALSE)
fp.set.long <- melt(fp.set, id=c("workerid", "gender", "age", "income", "categoryID", "order", "animal",
                                 "name"))
fp.set.long$type <- ifelse(grepl("a_", fp.set.long$variable)==TRUE, "animal", "person")
fp.set.long$featureSetNum <- unlist(lapply(strsplit(as.character(fp.set.long$variable), "_"), "[", 2))

# normalize to sum ratings for each person/animal in each trial to 1
# get noramlizing factor by summing ratigs for each subject/category/type

fp.set.normalizing <- aggregate(data=fp.set.long, value ~ workerid + categoryID + type, FUN=sum)
colnames(fp.set.normalizing)[4] <- "normalizing"
fp.set.long <- join(fp.set.long, fp.set.normalizing, by=c("workerid", "categoryID", "type"))
# filter out rows with 0 as normalizer
fp.set.long <- subset(fp.set.long, normalizing != 0)
fp.set.long$normalizedProb <- fp.set.long$value / fp.set.long$normalizing

fp.set.long.summary <- summarySE(data=fp.set.long, measurevar="normalizedProb", 
                                 groupvars=c("categoryID", "type", "featureSetNum", "animal"))

write.csv(fp.set.long.summary, "featurePriors-set.csv", row.names=FALSE)
## visualize an example
this.ID <- 1
fp.set.example <- subset(fp.set.long.summary, this.ID==categoryID)
animal <- as.vector(fp.set.example$animal)[1]
ggplot(fp.set.example, aes(x=featureSetNum, y=normalizedProb, fill=featureSetNum)) +
  geom_bar(stat="identity", color="black") +
  geom_errorbar(aes(ymin=normalizedProb-se, ymax=normalizedProb+se), width=0.2) +
  facet_grid(.~type) +
  theme_bw() +
  scale_fill_brewer(palette="Accent", guide=FALSE) +
  #ylim(c(0,1)) +
  ggtitle(animal)

# compute marginal prob for each feature
mapping <- read.csv("featureSetMapping.csv")
mapping$featureSetNum <- factor(mapping$featureSetNum)
fp.set.long.summary <- join(fp.set.long.summary, mapping, by=c("featureSetNum"))
fp.set.marginal.f1 <- aggregate(data=fp.set.long.summary, normalizedProb ~ categoryID + type + f1, FUN=sum) 
fp.set.marginal.f1$featureNum <- "1"
colnames(fp.set.marginal.f1)[3] <- "featurePresent"
fp.set.marginal.f2 <- aggregate(data=fp.set.long.summary, normalizedProb ~ categoryID + type + f2, FUN=sum) 
fp.set.marginal.f2$featureNum <- "2"
colnames(fp.set.marginal.f2)[3] <- "featurePresent"
fp.set.marginal.f3 <- aggregate(data=fp.set.long.summary, normalizedProb ~ categoryID + type + f3, FUN=sum) 
fp.set.marginal.f3$featureNum <- "3"
colnames(fp.set.marginal.f3)[3] <- "featurePresent"
fp.set.marginal <- rbind(fp.set.marginal.f1, fp.set.marginal.f2, fp.set.marginal.f3)
fp.set.marginal.present <- subset(fp.set.marginal, featurePresent==1)
colnames(fp.set.marginal.present)[2] <- "category"

fp.set.marginal.present <- fp.set.marginal.present[with(fp.set.marginal.present, 
                                                        order(categoryID, category, featureNum)), ]

# plot average marginal probabilities
fp.set.marginal.summary <- summarySE(fp.set.marginal.present, measurevar="normalizedProb",
                                     groupvars=c("category", "featureNum"))

ggplot(fp.set.marginal.summary, aes(x=category, y=normalizedProb, fill=featureNum)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=normalizedProb-se, ymax=normalizedProb+se), width=0.2, position=position_dodge(0.9)) +
  #facet_grid(.~category) +
  theme_bw() +
  xlab("") +
  ylab("Probability of feature given category") +
  scale_x_discrete(labels=c("Animal category", "Person category")) +
  #scale_fill_brewer(palette="RdGy", name="Feature")
  scale_fill_manual(values=my.colors, name="Feature", labels=c("f1", "f2", "f3"))

write.csv(fp.set.marginal.present, "featurePriors-set-marginal.csv", row.names=FALSE)

# an example with marginal prob
fp.set.marginal.present.example <- subset(fp.set.marginal.present, categoryID=="1")
ggplot(fp.set.marginal.present.example, aes(x=featureNum, y=normalizedProb, fill=featureNum)) +
  geom_bar(stat="identity", position=position_dodge(), color="black") +
  facet_grid(.~category) +
  theme_bw()


# correlate with independent features
fp.set.marginal.compare <- join(fp.set.marginal.present, fp.summary, by=c("categoryID", "category", "featureNum"))
with(fp.set.marginal.compare, cor.test(featureProb, normalizedProb))
fp.set.marginal.compare$labels <- paste(fp.set.marginal.compare$f1, 
                                        fp.set.marginal.compare$f2,
                                        fp.set.marginal.compare$f3, sep=",")
ggplot(fp.set.marginal.compare, aes(x=featureProb, y=normalizedProb)) +
  geom_point(size=3, aes(shape=category, color=featureNum)) +
  geom_smooth(method=lm) +
  geom_text(aes(label=labels, color=featureNum)) +
  theme_bw()