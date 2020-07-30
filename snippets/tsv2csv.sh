#!/bin/bash

# Last edited: 28 July 2020
# By: Rachel Unna Park

# Change the WADOH County COVID Data file into csv. 

# Usage
# sh $path/raw_csv.sh $path/datafile.tsv -flag
# -flag takes -o or nothing. If given -o, raw_csv will rewrite any existing
# files with its default filename, which is datafile.csv . Otherwise it will
# cancel the process.

# Assumed File Format
# The file should be tsv with exactly 9 columns and no empty cells.
# The file can have an arbitrary number of rows, but the first row
# must be header titles.

writeFileError=false;
isTab="	"; # this is a tab so I can see more easily what is being
		  # passed to sed commands.

echo "Here is a snippet of the data you've given me:";
head -3 $1;
numLines=`wc -l < $1`;
echo "The word count is: $numLines";

# Append .csv to the filename.
newFileName=`echo $1 | cut -f 1 -d '.'`;
newFileName=`echo $newFileName.csv`;
echo "The new file name will be $newFileName";

function writeFile {
	while read line; do

		# Allow splitting of the long header string
		# over multiple lines for readabilty. This introduces
		# unpredictable new lines and tabs.
		# `sed` here removes tabs and new lines.
		expHeaderText="County WeekStartDate NewPos_All Age 0-19 
						Age 20-39 Age 40-59 Age 60-79 Age 80+ 
						Positive UnkAge dtm_updated"
		expHeaderText=`echo $expHeaderText | sed "s/ / /g"`

		#Confirm the data header is correct. 
		if [[ "$expHeaderText" != `head -1 $1 | sed "s/$isTab/ /g"` ]]; then
			echo "ERROR. UNEXPECTED HEADER TEXT.";
			writeFileError=true
			break
		fi
		# Get rid of unexpected spacing from the tsv file.
		testLine=`echo $line | sed "s/ / /g"`

		if [ "$testLine" == "$expHeaderText" ]; then
			# `sed` here should be taking a tab. `sed` currently
			# does not accept a \value for tab so it is 
			# typed here.
			head -1 $1 | sed "s/$isTab/,/g" > "$newFileName"
		else
			echo "$line" | sed "s/$isTab/,/g" >> "$newFileName"
		fi
	done < $1
}



if [ -f "$newFileName" ] && [ "$2" == "-o" ]; then
	echo "Overwite specified. Removing existing file $newFileName..."
	rm $newFileName
	echo "Existing file removed. Writing to new file..."
	writeFile $1
	if [ $writeFileError == true ]; then
		echo "Process terminated."
	else
		echo "File written!"
	fi
elif [ -f "$newFileName" ]  && [ "$2" != "-o" ]; then
	echo "Error. File $newFileName exists, but overwrite is not specified."
	echo "No file changes made."
elif [ ! -f "$newFileName" ]; then
	echo "Creating new file $newFileName..."
	writeFile $1
	if [[ $writeFileError == true ]]; then
		echo "Process terminated."
	else
		echo "File written!"
	fi
else
	echo "Error. It should be logically impossible for you to be here... D:"
fi





