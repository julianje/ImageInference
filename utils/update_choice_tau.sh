#!/bin/bash

TAU=$1
EXPERIMENT=$2

for FILE in $(find ../stimuli/$EXPERIMENT/ -maxdepth 1 -type f -name "*.ini"); do
	sed -Ei "s/choiceTau\ =\ [0-9]+.[0-9]+/choiceTau\ =\ $TAU/" $FILE
done
