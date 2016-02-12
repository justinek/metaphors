library(ggplot2)
library(reshape2)
library(plyr)
library(tidyr)
library(ggbiplot)
source("~/Dropbox/Work/Grad_school/Research/Utilities/summarySE.R")

############################
# Filter color words
colorWords <- c("black", "blue", "brown", "gray", "green", "orange", "pink", "purple", "red", "white", "yellow")
############################

############################
# Features0 (features of animals0)
############################
# Read data in long form
f0 <- read.csv("features0_long.csv")

# Count tokens for each feature; sort
f0.count <- count(f0, vars=c("adjective"))
f0.count <- f0.count[with(f0.count, order(-freq)),]

# Write all features from this iteration
write.csv(f0.count, "features0_tally_all.csv", row.names=FALSE, quote=FALSE)

#####################
# Read in data with synonym for each feature
f0.syn <- read.csv("features0_synonym.csv")

# Filter out color words
f0.syn <- subset(f0.syn, !adjective %in% colorWords)

# Count tokens for each feature for each animal; sort
f0.syn.count <- count(f0.syn, vars=c("categoryID", "animal", "adjective"))
f0.syn.count <- f0.syn.count[with(f0.syn.count, order(categoryID, -freq)),]

# Write features for each animal from this iteraction
write.csv(f0.syn.count, "features0_tally_byAnimal.csv", row.names=FALSE, quote=FALSE)

#####################
# Read in curated features (top three non-synonymous features)
f0.curated <- read.csv("features0_curated.csv", header=FALSE, col.names=c("categoryID", "animal", "feature", "count"))

# Make data frame with unique featureIDs
features0 <- data.frame(featureID=seq(1, length(unique(f0.curated$feature))))
features0$feature <- unique(f0.curated$feature)

# Write features and featureIDs from this iteration
write.csv(features0, "Features/features0.csv", quote=FALSE, row.names=FALSE)

############################
# All features so far
allFeatures <- features0
############################

############################
# Features1 (features of animals1)
############################
f1 <- read.csv("features1_long.csv")
# Patching a bug in data (missing animalID column)
f1$categoryID <- NULL
animals1 <- read.csv("Animals/animals1.csv")
f1 <- join(f1, animals1, by="animal")

# Count tokens for each feature; sort
f1.count <- count(f1, vars=c("adjective"))
f1.count <- f1.count[with(f1.count, order(-freq)),]

write.csv(f1.count, "features1_tally_all.csv", row.names=FALSE, quote=FALSE)

######################
# Read in data with synonym for each feature; sort; fix bug; filter color words
f1.syn <- read.csv("features1_synonym.csv")
f1.syn$categoryID <- NULL
f1.syn <- join(f1.syn, animals1, by="animal")
f1.syn <- subset(f1.syn, !adjective %in% colorWords)

# Count tokens for each feature for each animal; sort
f1.syn.count <- count(f1.syn, vars=c("animalID", "animal", "adjective"))
f1.syn.count <- f1.syn.count[with(f1.syn.count, order(animalID, -freq)),]

write.csv(f1.syn.count, "features1_tally_byAnimal.csv", row.names=FALSE, quote=FALSE)

######################
# Read in curated features (top two non-synonymous features)
f1.curated <- read.csv("features1_curated.csv", col.names=c("animalID", "animal", "feature", "count"))

# Make data frame for new features
features1 <- data.frame(feature=unique(f1.curated$feature))

# Join allFeatures so far with features from this iteration
allFeatures_new <- join(allFeatures, features1, by="feature", type="full")
allFeatures_new <- allFeatures_new[with(allFeatures_new, order(featureID)),]
# Create unique featureIDs
allFeatures_new$featureID <- seq(1, length(allFeatures_new$featureID))

# Extract only features that were not in the old set
newFeatures <- subset(allFeatures_new, featureID > max(allFeatures$featureID))

# Write new features from this iteration
write.csv(newFeatures, "Features/features1.csv", row.names=FALSE, quote=FALSE)

###################################
# Update all features so far
allFeatures <- allFeatures_new
write.csv(allFeatures, "Features/allFeatures_0_1.csv", row.names=FALSE, quote=FALSE)
###################################

############################
# Features2 (features of animals2)
############################
f2 <- read.csv("features2_long.csv")

# Count tokens for each feature; sort
f2.count <- count(f2, vars=c("adjective"))
f2.count <- f2.count[with(f2.count, order(-freq)),]

write.csv(f2.count, "features2_tally_all.csv", row.names=FALSE, quote=FALSE)

######################
# Read in data with synonym for each feature; sort; fix bug; filter color words
f2.syn <- read.csv("features2_synonym.csv")
f2.syn <- subset(f2.syn, !adjective %in% colorWords)

# Count tokens for each feature for each animal; sort
f2.syn.count <- count(f2.syn, vars=c("animalID", "animal", "adjective"))
f2.syn.count <- f2.syn.count[with(f2.syn.count, order(animalID, -freq)),]

write.csv(f2.syn.count, "features2_tally_byAnimal.csv", row.names=FALSE, quote=FALSE)

######################
# Read in curated features (top two non-synonymous features)
f2.curated <- read.csv("features2_curated.csv", col.names=c("animalID", "animal", "feature", "count"))

# Make data frame for new features
features2 <- data.frame(feature=unique(f2.curated$feature))

# Join allFeatures so far with features from this iteration
allFeatures_new <- join(allFeatures, features2, by="feature", type="full")
allFeatures_new <- allFeatures_new[with(allFeatures_new, order(featureID)),]
# Create unique featureIDs
allFeatures_new$featureID <- seq(1, length(allFeatures_new$featureID))

# Extract only features that were not in the old set
newFeatures <- subset(allFeatures_new, featureID > max(allFeatures$featureID))

# Write new features from this iteration
write.csv(newFeatures, "Features/features2.csv", row.names=FALSE, quote=FALSE)

###################################
# Update all features so far
allFeatures <- allFeatures_new
write.csv(allFeatures, "Features/allFeatures_0_1_2.csv", row.names=FALSE, quote=FALSE)
###################################

###################################
# Make data frame of features given all animals
###################################
colnames(f0.curated) <- c("animalID", "animal", "feature", "count")
allFeaturesGivenAnimals <- rbind(f0.curated, f1.curated, f2.curated)
write.csv(allFeaturesGivenAnimals, "Features/allFeatures_givenAnimals.csv", row.names=FALSE, quote=FALSE)
