#!/bin/bash

if [ $1 = "true" ]
then
	for file in $(find ../maps | grep -E "*.ini")
	do
		sed -i 's/DiagonalTravel:\ False/DiagonalTravel:\ True/' $file
	done
elif [ $1 = "false" ]
then
	for file in $(find ../maps | grep -E "*.ini")
	do
		sed -i 's/DiagonalTravel:\ True/DiagonalTravel:\ False/' $file
	done
fi
