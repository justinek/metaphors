#!/bin/bash
for i in {1..32}
do
	python parseChurch.py noQud_$i-set-a2-t3.txt > noQud_$i-set-a2-t3.csv
	python parseChurch.py qud_$i-set-a2-t3.txt > qud_$i-set-a2-t3.csv
done
