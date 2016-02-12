library(ggplot2)
library(reshape2)
library(plyr)
library(tidyr)
library(ggbiplot)
source("~/Dropbox/Work/Grad_school/Research/Utilities/summarySE.R")

######################
# All animals so far
allAnimals <- read.csv("Animals/animals0.csv", header=FALSE, col.names=c("animalID", "animal"))
######################

######################
# Animals1 (animals that have feature0)
######################
a1 <- read.csv("animals1_long.csv")

a1.count <- count(a1, vars=c("featureID", "feature", "animal"))
a1.count <- a1.count[with(a1.count, order(featureID, -freq)),]

write.csv(a1.count, "animals1_tally_byFeature.csv", row.names=FALSE, quote=FALSE)

#####################
# Get the top most salient animals for each feature
a1.top <- read.csv("animals1_tally_byFeature_top.csv", header=FALSE, col.names=c("featureID", "feature", "animal", "count"))

# Make data frame for salient animals
animals1 <- data.frame(animal=unique(a1.top$animal))

allAnimals_new <- join(allAnimals, animals1, by="animal", type="full")
allAnimals_new <- allAnimals_new[with(allAnimals_new, order(animalID)),]

# Add unique animalID for each animal
allAnimals_new$animalID <- seq(1, length(allAnimals_new$animalID))

# Extract new animals that were not in existing set of animals
newAnimals <- subset(allAnimals_new, animalID > max(allAnimals$animalID))

write.csv(newAnimals, "Animals/animals1.csv", row.names=FALSE, quote=FALSE, col.names=FALSE)

#######################
# Update all animals so far
allAnimals <- allAnimals_new
write.csv(allAnimals, "Animals/allAnimals_0_1.csv", row.names=FALSE, quote=FALSE)
#######################

######################
# Animals2 (animals that have feature1)
######################
a2 <- read.csv("animals2_long.csv")

a2.count <- count(a2, vars=c("featureID", "feature", "animal"))
a2.count <- a2.count[with(a2.count, order(featureID, -freq)),]

write.csv(a2.count, "animals2_tally_byFeature.csv", row.names=FALSE, quote=FALSE)

#####################
# Get the top most salient animals for each feature
a2.top <- read.csv("animals2_tally_byFeature_top.csv", header=FALSE, col.names=c("featureID", "feature", "animal", "count"))

# Make data frame for salient animals
animals2 <- data.frame(animal=unique(a2.top$animal))

allAnimals_new <- join(allAnimals, animals2, by="animal", type="full")
allAnimals_new <- allAnimals_new[with(allAnimals_new, order(animalID)),]

# Add unique animalID for each animal
allAnimals_new$animalID <- seq(1, length(allAnimals_new$animalID))

# Extract new animals that were not in existing set of animals
newAnimals <- subset(allAnimals_new, animalID > max(allAnimals$animalID))

write.csv(newAnimals, "Animals/animals2.csv", row.names=FALSE, quote=FALSE)

#######################
# Update all animals so far
allAnimals <- allAnimals_new
write.csv(allAnimals, "Animals/allAnimals_0_1_2.csv", row.names=FALSE, quote=FALSE)
#######################

###################################
# Make data frame of animals given all features
###################################

allAnimalsGivenFeatures <- rbind(a1.top, a2.top)

write.csv(allAnimalsGivenFeatures, "Animals/allAnimals_givenFeatures.csv", row.names=FALSE, quote=FALSE)

