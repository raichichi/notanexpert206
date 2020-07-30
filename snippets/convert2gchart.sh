#!/bin/bash

# Last edited: 28 July 2020
# By: Rachel Unna Park

# This program changes the data into a useable form for my gcharts.

# $1 should be the data file in csv format to be changes.

rawDataFile=$1;
headerIndex=$2;


prevDate="1000-01-01";
prevCounty="";
let count=1;

cases=0;
dates="";
newCountyFile="./county_data/";


while read line; do
	if [[ $count != 1 ]]; then
		currentCounty=`echo $line | cut -f 1 -d "," | sed "s/ //g"`;
		currentDate=`echo $line | cut -f 2 -d ","`;
		casesThisWeek=`echo $line | cut -f 3 -d ","`;

		if [[ $count == 2 ]]; then # first line of data
			newCountyFile=`echo $newCountyFile$currentCounty.csv`;
			dates=`echo "$currentDate,"`;
			cases=`echo "$casesThisWeek,"`;
			prevDate=$currentDate;

			echo first if entered; # HINT

		elif [[ $prevDate > $currentDate ]]; then # checks if a new county section has started.

			# Write the collected data.
			echo "County Name, ${dates%?}" >> $newCountyFile; # Removes final comma from `$dates`
			echo "$prevCounty, ${cases%?}" >> $newCountyFile;  

			# Reset variables.
			cases=`echo "$casesThisWeek,"`;
			dates=`echo "$currentDate,"`;
			newCountyFile="./county_data/";
			newCountyFile="$newCountyFile$currentCounty.csv";

			echo first elif entered; # HINT


		elif [[ $prevDate < $currentDate ]]; then # continue writing to current county
			dates=`echo "$dates $currentDate,"`;
			cases=`echo "$cases $casesThisWeek,"`;
			echo second elif entered; # HINT
		fi
	fi

	let count=$count+1;
	prevDate=$currentDate;
	prevCounty=$currentCounty;
done < $1;

# Handle the last entry.
newCountyFile="./county_data/";
newCountyFile="$newCountyFile$currentCounty.csv";
echo "County Name, ${dates%?}" >> $newCountyFile; # Removes final comma from `$dates`
echo "$currentCounty, ${cases%?}" >> $newCountyFile;

