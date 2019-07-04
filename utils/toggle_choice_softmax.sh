#!/bin/bash

if [ $1 = "true" ]
then
	for file in $(find ../maps -type f -name "*.ini")
	do
		sed -i 's/SoftmaxChoice\ =\ False/SoftmaxChoice\ =\ True/' $file
	done
elif [ $1 = "false" ]
then
	for file in $(find ../maps -type f -name "*.ini")
	do
		sed -i 's/SoftmaxChoice\ =\ False/SoftmaxChoice\ =\ False/' $file
	done
fi
