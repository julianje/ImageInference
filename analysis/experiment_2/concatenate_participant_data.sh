#!/bin/bash

for FILE in $(find data/experiment_2/model/ -maxdepth 1 -type f -name "*.csv"); do
	cat $FILE | 
done