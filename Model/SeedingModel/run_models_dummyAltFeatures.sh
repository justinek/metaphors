#!/bin/bash

for FILENAME in $(ls /Users/justinek/Dropbox/Work/Grad_school/Research/Metaphor/metaphors/Model/SeedingModel/CoreAnimals/New_Folder_With_Items/*_3_*_dummyAltFeatures.church)
do
	node test/run_sandbox.js $FILENAME
done

