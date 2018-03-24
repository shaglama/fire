#!/bin/bash

function extract() {
	local inFile="$1"
	local outFile="$2"
	local pass="$3"
	steghide --extract -sf "$inFile" -xf "$outFile" -p "$pass" -f > /dev/null 2>&1>/dev/null
	if (( $? )); then
		return 0
	else
		return 1
	fi
}

function main(){
	extract "$1" "$2" "$3" "$4"
}

main "$1" "$2" "$3"
