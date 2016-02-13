#!/bin/bash
for FILENAME in $(ls Output/) 
do
	python parseChurch.py Output/$FILENAME > ParsedOutput/$FILENAME 
done
