#!/bin/bash
for FILENAME in $(ls OutputLiteral/) 
do
	python parseChurch.py OutputLiteral/$FILENAME > ParsedOutputLiteral/$FILENAME 
done
