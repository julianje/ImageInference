#!/bin/bash

for FILE in $(find ../data/experiment_2/model/ -maxdepth 1 -type f -name "*[0-9].csv"); do
	tail -23 $FILE
done > ../data/experiment_2/model/bayes_factors.csv
sed -i "1iparticipant,map,bayes_factor" bayes_factors.csv
