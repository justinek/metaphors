animalIDs <- read.csv("Animals/allAnimals.csv")
data <- read.csv("animals_alternatives_features.csv")
data <- join(animalIDs, data, by="animal")

write.csv(data, "animals_alternatives_features_sorted.csv", row.names=FALSE, quote=FALSE)

#########################################################
featureIDs <- read.csv("Features/allFeatures_0_1_2.csv")
data.features <- read.csv("alternatives_per_feature.csv")
data.features <- join(animalIDs, data.features, by="animal", type="right")
data.features <- join(featureIDs, data.features, by="feature", type="right")
data.features <- data.features[c("animalID", "animal", "featureID", "feature", "alternatives", "numAlts")]

data.features <- data.features[with(data.features, order(animalID, featureID)),]

write.csv(data.features, "alternatives_per_feature_sorted.csv", row.names=FALSE, quote=FALSE)

###########################################################
data.feature.animals <- read.csv("features_and_associated_animals.csv")
data.feature.animals <- join(featureIDs, data.feature.animals, by=c("feature"), type="right")
data.feature.animals <- data.feature.animals[c("featureID", "feature", "animals", "numAnimals")]
data.feature.animals <- data.feature.animals[with(data.feature.animals, order(featureID)),]

write.csv(data.feature.animals, "features_and_associated_animals_sorted.csv", row.names=FALSE, quote=FALSE)
