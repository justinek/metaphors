#!/bin/bash

for FILENAME in $(ls ~/Dropbox/Work/Grad_school/Research/Metaphor/metaphors1/Model/ScalarMetaphor/ModelsWithParams_YesNo)
do
	node test/run_sandbox.js ~/Dropbox/Work/Grad_school/Research/Metaphor/metaphors1/Model/ScalarMetaphor/ModelsWithParams_YesNo/$FILENAME
done

