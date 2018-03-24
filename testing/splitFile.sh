#!/bin/bash

function splitOnLine(){ # inputFile, outputFile, outputFileExtension
	extLength=`echo -n "$3" | wc -c`
	split -l 1 -a 3 "$1" "$2.$3."
}
function main(){
	splitOnLine "$1" "$2" "$3"
}
main "$1" "$2" "$3"