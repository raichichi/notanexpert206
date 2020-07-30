#!/bin/bash

# Last edited: 28 July 2020
# By: Rachel Unna Park

# This program removes the updated timestamps form a csv 
# file of wadoh cases by county data and returns it to lines for exporting
# to google sheets.

# $1 is the file to be changed.

newFileName= $1

for line in `cat $1`; do
	echo $line
done
