#!/bin/bash
function embed() {
	local toEmbed="$1"
	local embedIn="$2"
	local output="$3"
	local pass=`cat "$4"`
	/bin/bash -c "steghide --embed -cf \"$embedIn\" -ef \"$toEmbed\" -sf \"$output\" -p \"$pass\" -f -q > /dev/null 2>&1>/dev/null"	
	if (( $? )); then
		return 0
	else 
		return 1
	fi
}

function main(){# fileToEmbed, fileToEmbedIn, outputFile, passwordFile
	embed "$1" "$2" "$3" "$4"
}

main "$1" "$2" "$3" "$4"