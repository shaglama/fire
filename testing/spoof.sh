#!/bin/bash

function spoof () {
	local inFile="$1"
	local outFile="$2"
	local numLinesBefore="$3"
	local numLinesAfter="$4"
	local numPerLine=-1	
	local maxI="$((numLinesBefore - 1))"
	local maxJ=-1
	local maxK="$((numLinesAfter - 1))"
	local maxL=-1
	local nxtRdm=""
	local nextLine=""
	local i=-1
	local j=-1
	local k=-1
	local l=-1
	truncate -s 0 "$outFile"
	for ((i=0;i<=maxI;i++)); do
    numPerLine=`shuf -i 64-256 -n 1`
    nextLine=""
    maxJ="$((numPerLine - 1))"
    for ((j=0;j<=maxJ;j++)); do
     nxtRdm=`shuf -i 0-1 -n 1`
     nextLine="$nextLine$nxtRdm"
    done
    echo "$nextLine" >> "$outFile"
	done
	cat "$inFile" >> "$outFile"
	for ((k=0;k<=maxK;k++)); do
    numPerLine=`shuf -i 64-256 -n 1`
    nextLine=""
    maxL="$((numPerLine - 1))"
    for ((l=0;l<=maxL;l++)); do
     nxtRdm=`shuf -i 0-1 -n 1`
     nextLine="$nextLine$nxtRdm"
    done
    echo "$nextLine" >> "$outFile"
	done
	
}

spoof "$@"