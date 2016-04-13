#!/bin/bash
for FILENAME in $(ls OutputLambdaParems/ | grep high) 
do
	python parseChurch.py OutputLambdaParems/$FILENAME > ParsedOutputLambdaParems/$FILENAME 
done
