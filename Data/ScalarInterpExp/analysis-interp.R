library(ggplot2)
library(reshape2)
library(plyr)
source("~/Dropbox/Work/Grad_school/Research/Utilities/summarySE.R")

interp <- read.csv("interp_v3_fixedbug_longer.csv")
interp$bin <- factor(interp$bin)
interp$bin_num <- factor(interp$bin_num)
interp$polarity <- ifelse(interp$quality=="tall" | interp$quality=="fast" | interp$quality=="heavy", "high", "low")
interp$group <- paste(interp$polarity, interp$literal, sep=",")

ggplot(subset(interp, dimension=="speed"), aes(x=bin_num, y=prob, color=literal, shape=polarity)) +
  geom_point() +
  geom_line(aes(group=quality)) +
  facet_wrap(~workerID) +
  theme_bw()

# Get highest-probability bin

interp.max <- aggregate(data=interp, prob ~ workerID + item + dimension + literal + quality +
                          speaker + person, FUN=max)

interp.max <- join(interp.max, interp, by=c("workerID", "item", "dimension", "literal",
                                            "quality", "speaker", "person", "prob"))

ggplot(interp.max, aes(x=bin, fill=polarity)) +
  geom_bar(stat="count") +
  theme_bw() +
  facet_grid(dimension ~ literal)

# states
splithalf.state <- data.frame(cors=NULL)
t = 1
while (t <= 100) {
  nWorkers <- length(unique(interp$workerID))
  ii <- seq_len(nWorkers)
  indices <- sample(ii, nWorkers, replace = TRUE)
  ind1 <- indices[1:ceiling(nWorkers/2)]
  ind2 <- indices[(ceiling(nWorkers/2) + 1):length(indices)] 
  #ind1 <- sample(ii, nWorkers / 2) 
  #ind2 <- ii[!ii %in% ind1] 
  interp.1 <- subset(interp, workerID %in% ind1)
  interp.2 <- subset(interp, workerID %in% ind2)
  states.1 <- summarySE(interp.1, measurevar="prob", groupvars=c("item", "dimension", "literal", "person", "bin", "polarity"))
  states.2 <- summarySE(interp.2, measurevar="prob", groupvars=c("item", "dimension", "literal", "person", "bin", "polarity"))
  colnames(states.1)[8] <- "prob.1"
  colnames(states.2)[8] <- "prob.2"
  if (nrow(states.1) == nrow(states.2)) {
    states.split <- join(states.1, states.2, by=c("item", "dimension", "literal", "person", "bin"))
    t <- t+1
    r <- with(states.split, cor(prob.1, prob.2))
    this.frame <- data.frame(cors=r)
    splithalf.state <- rbind(splithalf.state, this.frame)
  }
}

splithalf.state <- subset(splithalf.state, !is.na(cors))

prophet <- function(reliability, length) {
  prophecy <- length * reliability / (1 + (length - 1)*reliability)
  return (prophecy)
}

splithalf.state$proph <- prophet(splithalf.state$cors, 2)

split.cor.state <- summarySE(splithalf.state, measurevar=c("proph", groupvars=NULL))



interp.summary <- summarySE(interp, measurevar="prob", 
                            groupvars=c("dimension", "literal", "polarity", "person", "bin", "bin_num", "group"))
#write.csv(interp.summary, "interp_summary.csv")

#interp.summary <- read.csv("interp_summary.csv")

interp.summary$bin <- factor(interp.summary$bin, 
                                    levels=c("0-1", "1-5", "5-6", "6-7", "7-8", "8-9", "9-10", "10-20", "20-60", ">60",
                                             "1-4", "4-4.5", "4.5-5", "5-5.5", "5.5-6", "6-6.5", "6.5-7", "7-15", ">15",
                                             "0-10", "10-100", "100-120", "120-140", "140-160", "160-180", "180-200", "200-220", "220-10000", ">10000"))


ggplot(interp.summary, aes(x=bin, y=prob, color=polarity)) +
  geom_point() +
  geom_errorbar(aes(ymin=prob-se, ymax=prob+se), width=0.05, color="grey") +
  geom_line(aes(group=group, linetype=literal)) +
  theme_bw() +
  facet_grid(person ~ dimension, scales="free_x") +
  xlab("values") +
  ylab("probability") +
  scale_linetype_discrete(name="utterance type", labels=c("figurative", "literal")) +
  theme(axis.text.x  = element_text(angle=-90, vjust=0.5))

interp.summary$utterance <- ifelse(interp.summary$literal=="fig" & interp.summary$polarity=="low", "animalA",
                                   ifelse(interp.summary$literal=="fig" & interp.summary$polarity=="high", "animalB",
                                          ifelse(interp.summary$literal=="lit" & interp.summary$polarity=="low", "litA", "litB")))
##############
# Priors
##############

p.height <- read.csv("../../Data/ScalarPriorExp/priors_height.csv")
p.weight <- read.csv("../../Data/ScalarPriorExp/priors_weight.csv")
p.speed <- read.csv("../../Data/ScalarPriorExp/priors_speed.csv")

p.all <- rbind(p.height, p.weight, p.speed)
colnames(p.all) <- c("dimension", "animal", 
                     "0", "1", "2", "3", "4", "5", "6", "7", "8", "9")

p.all.long <- melt(data=p.all, id=c("dimension", "animal"))
colnames(p.all.long)[3] <- "bin_num"
colnames(p.all.long)[4] <- "prior"

ggplot(p.all.long, aes(x=bin_num, y=prior, color=animal)) +
  geom_point() +
  geom_line(aes(group=animal)) +
  facet_grid(.~dimension) +
  theme_bw()

p.all.people <- subset(p.all.long, animal%in%c("man", "woman"))
colnames(p.all.people)[2] <- "person"
colnames(p.all.people)[4] <- "model"
p.all.people$utterance <- "prior"

##############
# Model predictions for all
##############
bestModel <- data.frame()
bestParams = c()
maxCor = 0
for (alpha in seq(1, 5)) {
  for (cost in seq(0, 0.2, 0.1)) {
    suffix = paste("-", alpha, "-", cost, ".csv", sep="")
    model.height <- read.csv(paste("../../Model/ScalarMetaphor/Outputs_YesNo/height", suffix, sep=""), header=FALSE, 
                             col.names = c("dimension", "person", "utterance", "bin_num", "model"))
    model.speed <- read.csv(paste("../../Model/ScalarMetaphor/Outputs_YesNo/speed", suffix, sep=""), header=FALSE, 
                            col.names = c("dimension", "person", "utterance", "bin_num", "model"))
    model.weight <- read.csv(paste("../../Model/ScalarMetaphor/Outputs_YesNo/weight", suffix, sep=""), header=FALSE, 
                             col.names = c("dimension", "person", "utterance", "bin_num", "model"))
    
    model.all <- rbind(model.height, model.speed, model.weight)
    model.all$bin_num <- factor(model.all$bin_num)
    #model.prior <- rbind(model.all, p.all.people)
    compare <- join(model.all, interp.summary, by=c("dimension", "person", "bin_num", "utterance"))
#     ggplot(compare, aes(x=model, y=prob, color=utterance)) +
#       geom_point() +
#       #geom_text(aes(label=bin_num)) +
#       facet_grid(utterance~dimension) +
#       theme_bw()
    thisCor <- cor(compare$prob, compare$model)
    if (thisCor > maxCor) {
      maxCor <- thisCor
      bestParams <- suffix
      bestModel <- model.all
    }
  }
}


# model.all$bin_num <- factor(model.all$bin_num)
# 
# ggplot(model.all, aes(x=bin_num, y=model, color=utterance)) +
#   geom_point() +
#   geom_line(aes(group=utterance)) +
#   facet_grid(person~dimension) +
#   theme_bw()
# 
# model.prior <- rbind(model.all, p.all.people)
# 
# ggplot(model.prior, aes(x=bin_num, y=model, color=utterance)) +
#   geom_point() +
#   geom_line(aes(group=utterance)) +
#   facet_grid(person~dimension) +
#   theme_bw()


########################
# Compare model and human
########################

compare <- join(bestModel, interp.summary, by=c("dimension", "person", "bin_num", "utterance"))
ggplot(compare, aes(x=model, y=prob, color=utterance)) +
  geom_point() +
  geom_errorbar(aes(ymin=prob-se, ymax=prob+se)) +
  #geom_text(aes(label=bin_num)) +
  #facet_grid(utterance~dimension) +
  facet_grid(literal~.) +
  theme_bw()

with(subset(compare), cor.test(prob,model))
with(subset(compare, utterance=="animalA"), cor.test(prob,model))
with(subset(compare, utterance=="animalB"), cor.test(prob,model))
with(subset(compare, literal=="fig"), cor.test(prob,model))
with(subset(compare, utterance=="litA"), cor.test(prob,model))
with(subset(compare, utterance=="litB"), cor.test(prob,model))


# model.height.man  <- read.csv("../../Model/ScalarMetaphor/height-man.csv")
# model.height.man$dimension <- "height"
# model.height.man$person <- "man"
# 
# model.height.woman <- read.csv("../../Model/ScalarMetaphor/height-woman.csv")
# model.height.woman$dimension <- "height"
# model.height.woman$person <- "woman"
# 
# model.speed.man  <- read.csv("../../Model/ScalarMetaphor/speed-man.csv")
# model.speed.man$dimension <- "speed"
# model.speed.man$person <- "man"
# 
# model.speed.woman <- read.csv("../../Model/ScalarMetaphor/speed-woman.csv")
# model.speed.woman$dimension <- "speed"
# model.speed.woman$person <- "woman"
# 
# model.weight.man  <- read.csv("../../Model/ScalarMetaphor/weight-man.csv")
# model.weight.man$dimension <- "weight"
# model.weight.man$person <- "man"
# 
# model.weight.woman <- read.csv("../../Model/ScalarMetaphor/weight-woman.csv")
# model.weight.woman$dimension <- "weight"
# model.weight.woman$person <- "woman"
# 
# model.all <- rbind(model.height.man, model.height.woman, model.speed.man, model.speed.woman, model.weight.man, model.weight.woman)
# model.all$bin <- factor(model.all$bin)
# 
# colnames(model.all)[5] <- "model"
# 
# comp.all <- join(model.all, interp.summary, by=c("dimension", "literal", "polarity", "person", "bin"))
# 
# with(comp.all, cor.test(model, prob))
# 
# ggplot(comp.all, aes(x=model, y=prob)) +
#   #geom_errorbar(aes(ymin=prob-se, ymax=prob+se), color="gray") +
#   geom_point(aes(color=polarity, shape=literal)) +
#   geom_smooth(method=lm, color="gray") +
#   #facet_grid(person ~ dimension) +
#   theme_bw() +
#   scale_shape_manual(values=c(1, 16), name="utterance type", labels=c("figurative", "literal")) +
#   xlab("Model") +
#   ylab("Human")
#   
#   
# 
# ggplot(model.all, aes(x=bin, y=model, color=polarity)) +
#   geom_point() +
#   #geom_errorbar(aes(ymin=prob-se, ymax=prob+se), width=0.05, color="grey") +
#   geom_line(aes(group=utterance, linetype=literal)) +
#   theme_bw() +
#   facet_grid(person ~ dimension, scales="free_x") +
#   xlab("values") +
#   ylab("probability") +
#   scale_linetype_discrete(name="utterance type", labels=c("figurative", "literal")) +
#   theme(axis.text.x  = element_text(angle=-90, vjust=0.5))
# 
# ### toy model example
# 
# interp.heights <- subset(interp.summary, dimension=="height" & person=="man")
# interp.heights$utterance <- ifelse(interp.heights$literal=="fig" & interp.heights$polarity=="high", "giraffe", 
#                                    ifelse(interp.heights$literal=="fig" & interp.heights$polarity=="low", "hamster",
#                                           ifelse(interp.heights$literal=="lit" & interp.heights$polarity=="high", "tall",
#                                                  "short")))
# 
# interp.heights$utterance <- factor(interp.heights$utterance, levels=c("giraffe", "hamster", "tall", "short"))
# ggplot(interp.heights, aes(x=bin, y=prob, color=utterance)) +
#   geom_point() +
#   geom_errorbar(aes(ymin=prob-se, ymax=prob+se), width=0.05, color="grey") +
#   geom_line(aes(group=utterance, linetype=literal)) +
#   theme_bw() +
#   scale_color_manual(values=c("#cb181d", "#0570b0", "#fe9929", "#74c476")) +
#   scale_linetype_discrete(guide=FALSE) +
#   xlab("height") +
#   ylab("probability")
# 
# model.heights <- read.csv("../../Model/ScalarMetaphor/height-woman.csv")
# model.heights$bin <- factor(model.heights$bin)
# model.heights$group <- paste(model.heights$polarity, model.heights$literal, sep=",")
# 
# model.heights$utterance <- ifelse(model.heights$literal=="fig" & model.heights$polarity=="high", "giraffe", 
#                                    ifelse(model.heights$literal=="fig" & model.heights$polarity=="low", "hamster",
#                                           ifelse(model.heights$literal=="lit" & model.heights$polarity=="high", "tall",
#                                                  "short")))
# model.heights$utterance <- factor(model.heights$utterance, levels=c("giraffe", "hamster", "tall", "short"))
# 
# ggplot(model.heights, aes(x=bin, y=prob, color=utterance)) +
#   geom_point() +
#   geom_line(aes(group=group, linetype=literal)) +
#   theme_bw() +
#   scale_color_manual(values=c("#cb181d", "#0570b0", "#fe9929", "#74c476")) +
#   scale_linetype_discrete(guide=FALSE) +
#   xlab("height") +
#   ylab("probability")
# 
# priors.heights <- subset(priors.summary, item_dimension=="man,height")
# priors.heights$utterance <- "prior"
# priors.heights$polarity <- "mid"
# priors.heights$literal <- "lit"
# priors.heights$item <- NULL
# priors.heights$item_dimension <- NULL
# priors.heights$dimension <- NULL
# priors.heights$N <- NULL
# priors.heights$sd <- NULL
# priors.heights$se <- NULL
# priors.heights$ci <- NULL
# priors.heights$group <- "prior"
# colnames(priors.heights)[2] <- "prob"
# 
# model.heights <- rbind(model.heights, priors.heights)
# 
# ggplot(model.heights, aes(x=bin, y=prob, color=utterance)) +
#   geom_point() +
#   geom_line(aes(group=group, linetype=literal)) +
#   theme_bw() +
#   scale_color_manual(values=c("#cb181d", "#0570b0", "#fe9929", "#74c476", "grey")) +
#   scale_linetype_discrete(guide=FALSE) +
#   xlab("height") +
#   ylab("probability")


