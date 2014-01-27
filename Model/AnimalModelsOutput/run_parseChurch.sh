#!/bin/bash
for i in {1..32}
do
	python parseChurch.py noQud_$i-set-multi.txt > noQud_$i-set-multi.csv
	python parseChurch.py qud_$i-set-multi.txt > qud_$i-set-multi.csv
	python parseChurch.py uniform_$i-set-multi.txt > uniform_$i-set-multi.csv
done
