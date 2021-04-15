#!/bin/bash

for FILE in $(find ../data/experiment_3/model/predictions/Manhattan/ -maxdepth 1 -type f -name "*posterior.csv"); do
	cat $FILE
done > ../data/experiment_3/model/predictions/Manhattan/data.csv
sed -i "1imap,l_1,l_2,p_2" ../data/experiment_3/model/predictions/Manhattan/data.csv
