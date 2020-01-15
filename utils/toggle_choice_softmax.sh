#!/bin/bash

TOGGLE=$1
EXPERIMENT=$2

if [ $TOGGLE = "true" ]
then
	for file in $(find ../stimuli/$EXPERIMENT -maxdepth 1 -type f -name "*.ini")
	do
		sed -i 's/SoftmaxChoice\ =\ False/SoftmaxChoice\ =\ True/' $file
	done
elif [ $TOGGLE = "false" ]
then
	for file in $(find ../stimuli/$EXPERIMENT -maxdepth 1 -type f -name "*.ini")
	do
		sed -i 's/SoftmaxChoice\ =\ True/SoftmaxChoice\ =\ False/' $file
	done
fi