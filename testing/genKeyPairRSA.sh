#!/bin/bash

function generate(){
	local privateOut="$1"
	local publicOut="$2"
	openssl genrsa -out "$privateOut" 4096
	openssl rsa -in "$privateOut" -out "$publicOut" -outform PEM -pubout
}

function main(){
	generate "$1" "$2"
}
main "$1" "$2"