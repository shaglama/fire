#!/bin/bash

function decode(){
	local in="$1"
	local out="$2"
	local key="$3"
	
	openssl rsautl -decrypt -inkey "$key" -in "$in" -out "$out" 
}

function main(){
	decode "$1" "$2" "$3"
}

main "$1" "$2" "$3"