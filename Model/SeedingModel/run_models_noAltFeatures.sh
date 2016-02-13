#!/bin/bash

for FILENAME in $(ls /Users/justinek/Dropbox/Work/Grad_school/Research/Metaphor/metaphors/Model/SeedingModel/CoreAnimals/*_6_*_noAltFeatures.church)
do
	node test/run_sandbox.js $FILENAME
done

