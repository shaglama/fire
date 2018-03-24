#!/bin/bash

function encode () {
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
	if [[ $hasInputArg == true ]]; then
		cat "$input" | base64 > "$output"
	else
		cat - | base64 > "$output"
	fi 
}

encode "$@"