library(ggplot2)
library(reshape2)
library(plyr)
library(ggbiplot)
source("~/Dropbox/Work/Grad_school/Research/Utilities/summarySE.R")

d <- read.csv("long.csv")
d.metaphor <- subset(d, isMetaphor=="TRUE")
d.metaphor$rating <- as.numeric(as.character(d.metaphor$rating))

d.metaphor.summary <- summarySE(d.metaphor, measurevar="rating", groupvars=c("animal", "QUD"))
d.metaphor.summary$dummy <- "dummy"

d.metaphor$qudType <- ifelse(d.metaphor$QUD == "null", "general", "specific")

ggplot(d.metaphor.summary, aes(x=dummy, y=rating, group=QUD)) +
  geom_bar(stat="identity", color="black", fill="gray", position=position_dodge()) +
  geom_text(aes(x=dummy, y=rating, label=QUD, group=QUD)) +
  geom_errorbar(aes(ymin=rating-se, ymax=rating+se), width=0.2, position=position_dodge(0.9)) +
  facet_wrap(~animal, ncol=4) +
  theme_bw()

d.metaphor.byqudType.summary <- summarySE(d.metaphor, measurevar="rating", groupvars=c("qudType"))
ggplot(d.metaphor.byqudType.summary, aes(x=qudType, y=rating)) +
  geom_bar(stat="identity", color="black", fill="gray") +
  geom_errorbar(aes(ymin=rating-se, ymax=rating+se), width=0.5) +
  theme_bw()

d.metaphor.byAnimal.summary <- summarySE(d.metaphor, measurevar="rating", groupvars=c("animal"))
d.metaphor.byAnimal.summary$animal <- factor(d.metaphor.byAnimal.summary$animal,
                                             levels=d.metaphor.byAnimal.summary[order(d.metaphor.byAnimal.summary$rating),]$animal) 

ggplot(d.metaphor.byAnimal.summary, aes(x=animal, y=rating)) +
  geom_bar(stat="identity", color="black", fill="gray") +
  geom_errorbar(aes(ymin=rating-se, ymax=rating+se), width=0.5) +
  theme_bw()

d.metaphor.byAnimal.byQUD.summary <- summarySE(d.metaphor, measurevar="rating", groupvars=c("animal", "qudType"))
d.metaphor.byAnimal.byQUD.summary$animal <- factor(d.metaphor.byAnimal.byQUD.summary$animal,
                                             levels=d.metaphor.byAnimal.summary[order(d.metaphor.byAnimal.summary$rating),]$animal) 

ggplot(d.metaphor.byAnimal.byQUD.summary, aes(x=animal, y=rating, fill=qudType)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=rating-se, ymax=rating+se), width=0.5, position=position_dodge(0.9)) +
  theme_bw()


