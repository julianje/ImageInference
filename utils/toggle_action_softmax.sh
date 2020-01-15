#!/bin/bash

TOGGLE=$1
EXPERIMENT=$2

if [ $TOGGLE = "true" ]
then
	for file in $(find ../stimuli/$EXPERIMENT -maxdepth 1 -type f -name "*.ini")
	do
		sed -i 's/SoftmaxAction\ =\ False/SoftmaxAction\ =\ True/' $file
	done
elif [ $TOGGLE = "false" ]
then
	for file in $(find ../stimuli/$EXPERIMENT -maxdepth 1 -type f -name "*.ini")
	do
		sed -i 's/SoftmaxAction\ =\ True/SoftmaxAction\ =\ False/' $file
	done
fi