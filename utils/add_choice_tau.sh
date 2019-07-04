#!/bin/bash

for file in $(find ../maps -type f -name "*.ini")
do
	sed -i 's/actionTau\ =\ 0.15/actionTau\ =\ 0.15\nchoiceTau\ =\ 0.1/' $file
done
