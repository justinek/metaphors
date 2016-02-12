library(ggplot2)
library(reshape2)
library(plyr)
library(tidyr)
source("~/Dropbox/Work/Grad_school/Research/Utilities/summarySE.R")

p <- read.csv("long_v2.csv")
p$item_dimension <- paste(p$item, p$dimension, sep=",")
p$item_dimension <- factor(p$item_dimension, levels=c("man,height",  "man,speed", "man,weight", 
                                                      "woman,height", "woman,speed", "woman,weight",
                                                      "giraffe,height", "cheetah,speed", "elephant,weight", 
                                                      "penguin,height", "turtle,speed", "bird,weight"))                                  
ggplot(p, aes(x=response)) +
  geom_histogram(stat="bin", color="black", fill="gray") +
  theme_bw() +
  facet_wrap(~item_dimension, ncol=3, scales="free")

ggplot(subset(p, item_dimension=="man,weight"), aes(x=response)) +
  geom_histogram(stat="bin", color="black", fill="gray", binwidth=10) +
  theme_bw()

priors <- read.csv("longer_v2.csv")
# priors$item_dimension <- paste(priors$item, priors$dimension, sep=",")
# priors$item_dimension <- factor(priors$item_dimension, levels=c("man,height",  "man,speed", "man,weight", 
#                                                                 "woman,height", "woman,speed", "woman,weight",
#                                                                 "giraffe,height", "cheetah,speed", "elephant,weight", 
#                                                                 "penguin,height", "turtle,speed", "bird,weight")) 

priors$animal <- ifelse(priors$item=="man", "man", 
                              ifelse(priors$item=="woman", "woman", 
                                     ifelse(priors$item=="penguin" | priors$item=="turtle" | priors$item=="bird", "animalA",
                                            "animalB")))

priors.summary <- summarySE(priors, measurevar="prior", groupvars=c("item", "dimension", "bin", "bin_num", "animal"))


#priors.summary <- read.csv("priors_summary.csv")

priors.summary$bin <- factor(priors.summary$bin, 
                                    levels=c("0-1", "1-5", "5-6", "6-7", "7-8", "8-9", "9-10", "10-20", "20-60", ">60",
                                             "1-4", "4-4.5", "4.5-5", "5-5.5", "5.5-6", "6-6.5", "6.5-7", "7-15", ">15",
                                             "0-10", "10-100", "100-120", "120-140", "140-160", "160-180", "180-200", "200-220", "220-10000", ">10000"))

priors.summary$animal <- factor(priors.summary$animal, levels=c("man", "woman", "animalA", "animalB"))
ggplot(priors.summary, aes(x=bin, y=prior)) +
  geom_line(aes(group=item), color="grey") +
  geom_point(color="black") +
  geom_errorbar(aes(ymin=prior-se, ymax=prior+se), width=0.05) +
  theme_bw() +
  facet_grid(animal~dimension, scales="free_x") +
  xlab("values") +
  ylab("probability") +
  theme(axis.text.x  = element_text(angle=-90, vjust=0.5))

################
# Clean into church readable priors
################

priors.means <- aggregate(data=priors, prior ~ dimension + animal + bin_num, FUN=mean)

priors.wide <- spread(data=priors.means, bin_num, prior, drop=TRUE) 

write.csv(priors.wide, "priors_means_wide.csv", row.names=FALSE, quote=FALSE)
write.csv(subset(priors.wide, dimension=="height"), "priors_height.csv", row.names=FALSE, quote=FALSE)
write.csv(subset(priors.wide, dimension=="speed"), "priors_speed.csv", row.names=FALSE, quote=FALSE)
write.csv(subset(priors.wide, dimension=="weight"), "priors_weight.csv", row.names=FALSE, quote=FALSE)
