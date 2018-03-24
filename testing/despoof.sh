#!/bin/bash

function despoof() {
	local inFile="$1"
	local outFile="$2"
	local spoofedLinesBefore="$3"
	local spoofedLinesAfter="$4"
	local tmpFile="deSpoofTmp.tmp"
	local command=""
	local delC="d"
	cp "$inFile" "$outFile"
	command="1,$spoofedLinesBefore$delC"
	sed -i "$command" "$outFile"
	command="1,$spoofedLinesAfter$delC"
	tac "$outFile" > "$tmpFile"
	sed -i "$command" "$tmpFile"
	tac "$tmpFile" > "$outFile"
		
}

despoof "$@"