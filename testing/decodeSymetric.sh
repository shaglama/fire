#!/bin/bash

function decode(){
	local in="$1"
	local out="$2"
	local key="$3"
	
	openssl aes-256-cbc -a -d -salt -in "$in" -out "$out" -pass file:"$key" 
}

function main(){
	decode "$1" "$2" "$3"
}

main "$1" "$2" "$3"