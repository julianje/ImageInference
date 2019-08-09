#!/bin/bash

TAU=$1

for file in $(find ../maps -type f -name "*.ini"); do
	sed -Ei "s/actionTau\ =\ [0-9]+.[0-9]+/actionTau\ =\ $TAU/" $file
done