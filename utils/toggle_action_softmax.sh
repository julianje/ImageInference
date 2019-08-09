#!/bin/bash

if [ $1 = "true" ]
then
	for file in $(find ../stimuli/experiment_1 -maxdepth 1 -type f -name "*.ini")
	do
		sed -i 's/SoftmaxAction\ =\ False/SoftmaxAction\ =\ True/' $file
	done
elif [ $1 = "false" ]
then
	for file in $(find ../stimuli/experiment_1 -maxdepth 1 -type f -name "*.ini")
	do
		sed -i 's/SoftmaxAction\ =\ False/SoftmaxAction\ =\ False/' $file
	done
fi