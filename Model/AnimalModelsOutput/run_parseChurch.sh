#!/bin/bash
for i in {1..32}
do
	python parseChurch.py noQud_$i-set-transformed-d2.txt > noQud_$i-set-transformed-d2.csv
	python parseChurch.py qud_$i-set-transformed-d2.txt > qud_$i-set-transformed-d2.csv
done
