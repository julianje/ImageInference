#!/bin/bash

TAU=$1

for file in $(find ../stimuli/experiment_1 -maxdepth 1 -type f -name "*.ini"); do
	sed -Ei "s/choiceTau\ =\ [0-9]+.[0-9]+/choiceTau\ =\ $TAU/" $file
done