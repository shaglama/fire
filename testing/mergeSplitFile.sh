#!/bin/bash

function merge(){
	for line in "$1".*
	do
		cat $line >> "$2"
	done
}

function main(){
	merge "$1" "$2"
}
main "$1" "$2"