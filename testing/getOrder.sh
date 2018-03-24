#!/bin/bash

function order(){
	inFileBase="$1"
	outfile="$2"
	done=()
	files="$inFileBase.*"
	notDone="${files[@]}"
	numFiles=${#files[@]}
	numLeft=`echo $notDone | wc -w`
	tmpArray=()
	while [[ $numLeft -gt 0 ]];
	do
		tmpArray=()
		lowestNum="empty"
		lowestFile="empty"
		for file in $notDone
		do
			dline=`strings "$file" | grep -m 1 [1-2][0-9][0-9][0-9]: | tr -d -c 0-9`
			if [[ $lowestNum == "empty" ]]; then
				lowestNum=$dline
				lowestFile=$file
			else
				if [[ $dline -lt $lowestNum ]]; then
					index=${#tmpArray[@]}
					tmpArray[$index]=$lowestFile
					lowestFile=$file
					lowestNum=$dline					
				else
					index=${#tmpArray[@]}
					tmpArray[$index]=$file
				fi
			fi
		done
		notDone="${tmpArray[@]}"
		doneIndex=${#done[@]}
		done[$doneIndex]=$lowestFile
		numLeft=`echo $notDone | wc -w`
		
	done
	for f in ${done[@]}
	do
		echo "$f" >> "$outfile"
	done
	
	
	
}
order "$@"