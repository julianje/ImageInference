#!/bin/bash

TAU=$1

for file in $(find ../maps -type f -name "*.ini"); do
	sed -Ei "s/choiceTau\ =\ [0-9]+.[0-9]+/choiceTau\ =\ $TAU/" $file
done