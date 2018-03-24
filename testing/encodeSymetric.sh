#!/bin/bash

function encode(){
	local in="$1"
	local out="$2"
	local key="$3"
	
	openssl aes-256-cbc -a -salt -in "$in" -out "$out" -pass file:"$key"
}

function main(){
	encode "$1" "$2" "$3"
}

main "$1" "$2" "$3"
