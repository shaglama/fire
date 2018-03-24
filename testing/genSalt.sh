#!/bin/bash
script=`readlink -f $0`
scriptDir=`dirname $(readlink -f $0)`

#@@@@ GLOBALS @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
## Testing only
check="/home/randy/test.txt"
passFile="/home/randy/testPass.txt"
out="/home/randy/testResult.txt"
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

#### FUNCTIONS ##############################################################
function replace(){ # $1 string to replace, $2 string to replace with, 
							# $3 string to replace in
	local replace="$1"
	local with="$2"
	local inString="$3"
	echo $inString | sed -e "s%$replace%$with%g"
}
	
function ascii2dec() # $1 string to convert
{
  RES=""
  for i in `echo $1 | sed "s/./& /g"`
  do 
    RES="$RES `printf \"%d\" \"'$i\"`"
  done 
  echo $RES
}

function dec2ascii() ###########################################################
{
  RES=""
  for i in $*
  do 
    RES="$RES`printf \\\\$(printf '%03o' $i)`"
  done 
  echo $RES
}

function xor() #################################################################
{
  KEY=$1
  shift
  RES=""
  for i in $*
  do
    RES="$RES $(($i ^$KEY))"
  done

  echo $RES
}

function gen(){ #################################################################
	local bun="$1"
	local burger="$2"
	local cheese=""
	local ketchup=""
	local mustard=""
	local xor1=`date -r $bun +%s`
	local xor2=`ls -lc $bun`
	local xor3=`id -u $USER`
	local xor4=`id -r -u $USER`
	local sandwich=""
	local delivery="$3"
	
	cheese="$xor1:$xor2@:$xor3:$xor4:rt"
	ketchup=`ascii2dec "$cheese"`
	ketchup=`replace " " "" "$ketchup"`
	burger=`cat $burger` 
	mustard=`ascii2dec "$burger"`
	sandwich=`xor "$ketchup" "$mustard"`
	sandwich=`replace " " "" "$sandwich"`
	
	echo "$sandwich" > "$delivery" 

}

function main(){ # checkFile, passFile, outFile
	gen "$1" "$2" "$3"
}

###############################################################################

#******************************************************************************
#**** Program *****************************************************************

main "$1" "$2" "$3"