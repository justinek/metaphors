#!/bin/bash
for FILENAME in $(ls OutputMetaphor/) 
do
	python parseChurch.py OutputMetaphor/$FILENAME > ParsedOutputMetaphor/$FILENAME 
done
