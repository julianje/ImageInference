#!/bin/bash

EXPERIMENT=$1
TOGGLE=$2

if [ $TOGGLE = "true" ]; then
	for FILE in $(find ../stimuli/$EXPERIMENT/ -maxdepth 1 -type f -name "*.ini"); do
		sed -i 's/SoftmaxChoice\ =\ False/SoftmaxChoice\ =\ True/' $FILE
	done
elif [ $TOGGLE = "false" ]; then
	for FILE in $(find ../stimuli/$EXPERIMENT/ -maxdepth 1 -type f -name "*.ini"); do
		sed -i 's/SoftmaxChoice\ =\ True/SoftmaxChoice\ =\ False/' $FILE
	done
fi
