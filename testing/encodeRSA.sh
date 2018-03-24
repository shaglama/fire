#!/bin/bash

function encode(){
	local in="$1"
	local out="$2"
	local key="$3"
	
	openssl rsautl -encrypt -inkey "$key" -pubin -in "$in" -out "$out" 
}

function main(){
	encode "$1" "$2" "$3"
}

main "$1" "$2" "$3"