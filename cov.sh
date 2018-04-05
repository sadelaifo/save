#! /bin/bash
# Usage: Convert all labeled image files in the subfolder
#	 to video files for anomaly detection project, CMPSC 483
#
# Input Parameters:
#	1. input: current directory by default
#	2. desti: output directory
#	3. formt: .mp4 file by default
#	4. signa: anomaly identifier. The program will look at 
#		  a status file (.csv file) to know whether there is 
#		  anomalies in recorded frames. If $signa is 
#		  found in the status file, then the video will be 
#		  identified as containing anomaly
#	5. anofi: the name of your .csv file
# 	6. nlabl: the output sub-directory you want to put non-anomaly videos
#	7. alabl: the output sub-directory you want to put anomaly videos
#
# Additional Requirements:
#	1. Each classified image folder should contain a .csv file indicating 
#	   whether there is anomaly 
#	2. No white space in all file path.
#
# Output;
#	Videos generated from images. Those videos will be placed in 2 folders:
#	Anomaly/ or Non_Anomaly/, based on the anomaly status file (.csv file).
#
# Author: Yi Zheng. 04/04/2018
#



signa=",1"				# anomaly identifier
input=$(pwd)				# input file directory
desti="$input" 				# output file directory
formt="mp4"				# output file format
anofi="anomalies.csv"			# anomaly status file
nlabl="Non_ano_out"			# output non-anomaly video directory
alabl="ano_out"				# output anomaly video directory

a=1					# anomaly file counter
n=1					# non-anomaly file counter
subdi=$(find "$input" -type d)

# program start

# create output sub-directory if not available
if [ ! -d "$desti/$nlabl" ] ; then
	mkdir "$desti/$nlabl"
fi

if [ ! -d "$desti/$alabl" ] ; then
	mkdir "$desti/$alabl"
fi

# loop through all 
for d in $subdi
do
	if [ -f "$d/$anofi" ] ; then
		cat "$d/$anofi" | grep -q $signa
		if [ $? -eq 0 ] ; then	# exit status returns 0 (true) if a match is found
			ffmpeg -r 2 -start_number 1 -i "$d/%d.jpg" -vcodec libx264 "$desti/$alabl/$a.$formt" 
			((a++))
		else
			ffmpeg -r 2 -start_number 1 -i "$d/%d.jpg" -vcodec libx264 "$desti/$nlabl/$n.$formt"
			((n++))
		fi
	fi
done
