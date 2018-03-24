#!/bin/bash

function decode() {
	local hasInputArg=false
	local input=""
	local output="" 
	if [[ $# -ge 1 ]]; then
		output="$1"
		if [[ $# -ge 2 ]]; then
			hasInputArg=true
			input="$2"
		fi
	else
		echo "invalid arguments"
		exit 1
	fi
	if [[ $hasInputArg == true ]]; then #get input from file
		cat "$input" | base64 -d > "$output"
	else # get input from standard in
		cat - | base64 -d > "$output"
	fi 
}
decode "$@"