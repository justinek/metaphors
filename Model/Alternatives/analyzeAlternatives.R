##############
# Case study on whales
##############

d.noAlt <- read.csv("whale-noQUD-noAlt.csv", header=FALSE, col.names=c("animal", "f1", "f2", "f3", "prob"))
d.allAlt <- read.csv("whale-noQUD-allAlt.csv", header=FALSE, col.names=c("animal", "f1", "f2", "f3", "prob"))

noAlt.f1 <- data.frame(animal="whale", featureNum="1", prob=sum(subset(d.noAlt, f1==1)$prob))
noAlt.f2 <- data.frame(animal="whale", featureNum="2", prob=sum(subset(d.noAlt, f2==1)$prob))
noAlt.f3 <- data.frame(animal="whale", featureNum="3", prob=sum(subset(d.noAlt, f3==1)$prob))

noAlt <- rbind(noAlt.f1, noAlt.f2, noAlt.f3)

allAlt.f1 <- data.frame(animal="whale", featureNum="1", prob=sum(subset(d.allAlt, f1==1)$prob))
allAlt.f2 <- data.frame(animal="whale", featureNum="2", prob=sum(subset(d.allAlt, f2==1)$prob))
allAlt.f3 <- data.frame(animal="whale", featureNum="3", prob=sum(subset(d.allAlt, f3==1)$prob))

allAlt <- rbind(allAlt.f1, allAlt.f2, allAlt.f3)

############
# Look at human whales data
############

d.human <- read.csv("../../Data/MetaphorExp/data49-long.csv")
d.human$qud <- ifelse(d.human$condition==1 | d.human$condition==2, 0, 1)
d.human$metaphor <- ifelse(d.human$condition==1 | d.human$condition==3, 0, 1)
d.human.f1.summary <- summarySE(d.human, measurevar="f1prob", groupvars=c("animal", "qud", "metaphor"))
d.human.f2.summary <- summarySE(d.human, measurevar="f2prob", groupvars=c("animal", "qud", "metaphor"))
d.human.f3.summary <- summarySE(d.human, measurevar="f3prob", groupvars=c("animal", "qud", "metaphor"))
d.human.f1.summary$featureNum <- "1"
d.human.f2.summary$featureNum <- "2"
d.human.f3.summary$featureNum <- "3"
colnames(d.human.f1.summary)[5] <- "prob"
colnames(d.human.f2.summary)[5] <- "prob"
colnames(d.human.f3.summary)[5] <- "prob"

d.human.summary <- rbind(d.human.f1.summary, d.human.f2.summary, d.human.f3.summary)

# Subset of interest (whale, metahor, no qud)
d.human.whale.met.noQud.summary <- subset(d.human.summary, animal=="whale" & metaphor==1 & qud ==0)

d.human.whale.met.noQud.summary$qud <- NULL
d.human.whale.met.noQud.summary$metaphor <- NULL
d.human.whale.met.noQud.summary$N <- NULL
d.human.whale.met.noQud.summary$sd <- NULL
d.human.whale.met.noQud.summary$ci <- NULL
d.human.whale.met.noQud.summary$type <- "human"

noAlt$se <- 0
noAlt$type <- "model (no alternatives)"
allAlt$se <- 0
allAlt$type <- "model (alternatives)"

compare.whale <- rbind(d.human.whale.met.noQud.summary, noAlt, allAlt)

ggplot(compare.whale, aes(x=featureNum, y=prob, fill=featureNum)) +
  geom_bar(stat="identity", color="black") +
  geom_errorbar(aes(ymin=prob-se, ymax=prob+se), width=0.2) +
  facet_grid(.~type) +
  theme_bw()
