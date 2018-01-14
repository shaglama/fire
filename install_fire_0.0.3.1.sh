#!/bin/bash
#fire install scrip
#version 0.0.3.1
#Janurary 14, 2018
#Randy Hoggard

##########      *****     FIRE INSTALL SCRIPT     *****     ##################
#	This script will download and install the Heat Ledger installation and		
#	monitoring script called fire.															
##############################################################################
#																										
##########     OPTIONS		###################################################
#	PLEASE SET THE FOLLOWING VALUES TO YOUR OPTIONS BEFORE RUNNING THIS			
#	SCRIPT!																							
#																										
#	|		|		| 		Required 	|		!		!		!		!		!		!		!	
#	V		V		V						V		V		V		V		V		V		V		V	
walletSecret="" 		
							# the secret passphrase for the wallet running the node,	
							# set here or pass as argument									
																												
heatId="" 				
							# the account id of the wallet running the node, 			
							# set here or pass in as argument								
																											
#?????????		Optional		???????????????????????????????????????????????????

options=""
							# a ';' delimited string of options to pass to the			
							# installer, options in the form of								
							# optionName=optionVal												
							# options set here take precedent over options set
							# individually in this file
							# passing this via argument to installer i.e.
							# '--options="option1Name=option1Val;option2Name=...'
							# takes precedent above all.
heatUser="$USER" 		
							# user to run the node with, defaults to user that runs	
							# the script. to set a different user change here or 		
							# pass in as argument, if user does not exist it will		
							# be created															
																										
password="" 			
							# password for creating a new user, if new user is 		
							# created without changing the password here or passing	
							# in as argument you will need to set the password 		
							# yourself after running this script							
																												
apiKey="change" 																					
							#Default api key, please change or pass in as argument	
																										
ipAddress="" 			
							# public ip address or host, set here or pass as 			
							#argument. if no value is set, the script will attempt	
							# to obtain it from a public provider (dynDNS)				
																										
maxPeers=500 			
							# number of peers node should connect to,set here or		
							# pass as argument, defaults to 500								
																										
hallmark="" 			
							# the node hallmark, increases forging profits,				
							# set here or pass in as argument, if not set script		
							# will attempt to create a new hallmark for the node		
																										
forceScan="false" 		
							# if set to true node will be configured to rescan			
							# blockchain																	
																											
forceValidate="false"
							#if set to true node will be configured to revalidate		
							# transactions on the blockchain									
																										
useSnapshot="true" 	
							# if set to true, a snapshot of the blockchain will be	
							# downloaded from the URL specified below 					
																										
snapshotURL="http://heatledger.net/snapshots/blockchain.zip" 
							#the location to download snapshots from, defaults to		
							# heatledger.net daily backup										
																										
installDir="" 			
							# the location to install fire in, defaults to directory	
							# script is located in												
																											
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#																										
# WARNING: DO NOT CHANGE ANYTHING BELOW !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#	|			|			|			|			|			|			|			|			|	
#	V			V			V			V			V			V			V			V			V	
#********  Functions *********************************************************
function urlencode() {
    # urlencode <string>
    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C
    
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done
    
    LC_COLLATE=$old_lc_collate
}
function urlEncodeSpace(){
	local out=`echo "$1" | tr -s ' ' '%20'`
	echo "$out"
}
function urlDecodeSpace(){
	local out=`echo "$1" | tr -s '%20' ' '`
	echo "$out"
}
function trim(){
	echo "$1" | sed 's/^[ \t]*//;s/[ \t]*$//'
}
function split() {
 
        IFS="$2" read -r -a "$3" -d '' < <(printf %s "$1");
}
#%%%%%%%% Install fire %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
script=`readlink -f $0`
scriptDir=`dirname $(readlink -f $0)`
version="0.0.3.1"
file="fire_$version.tar.gz"
##get any arguments for installer
while [[ $# -gt 0 ]]; do
	key="$1"
	case "$key" in
		--options=*)
			options="${key#*=}"
			echo "$options"
			;;
		*)
			echo "unknown option $key"
			;;
	esac
	shift
done	
#options=`trim "$options"`
options=`urlEncodeSpace "$options"`
echo "$options"
if [[ ! $options = "" ]]; then
	echo "processing options...."
		split "$options" ";" o_array
		#echo "${o_array[*]}" 
      for opt in ${o_array[*]};
		do
			optArr=
			split "$opt" "=" optArr
			optName="${optArr[0]}"
			optVal="${optArr[1]}"
			echo "before decode : $optVal"
			optVal=`urlDecodeSpace "$optVal"`
			echo "option name $optName"
			echo "option value $optVal"

			case $optName in
				
				heatUser)
					heatUser="$optVal"
					;;
				password)
					password="$optVal"
					;;
				apiKey)
					apiKey="$optVal"
					;;
				ipAddress)
					ipAddress="$optVal"
					;;

				walletSecret)
					walletSecret="$optVal"
					;;
				heatId)
					heatId="$optVal"
					;;
				maxPeers)
					maxPeers="$optVal"
					;;
				hallmark)
					hallmark="$optVal"					
					;;
				forceScan)
					forceScan="$optVal"
					;;
				forceValidate)
					forceValidate="$optVal"
					;;
				useSnapshot)
					useSnapshot="$optVal"
					;;

				snapshotUrl)
					snapshotUrl="$optVal"
					;;
				*)
					echo "invalid option: $optName:"
					;;
			esac


		done	
	echo "options exist"
else
	echo "no options exist"
fi

if [[ $installDir == "" ]]; then
	installDir="$scriptDir"
fi
if [[ ! -d $installDir ]]; then
	mkdir $installDir
fi
cd $installDir/
wget "https://github.com/shaglama/fire/raw/development/$file"
tar -xzvf $file
rm $file
cd fire/
echo "$version" > "fire_wood/shared/dat/fire_version"
cd fire_builder
/bin/bash -c "./fire_builder --mode=install --user=$heatUser --password=$password --accountNumber=$heatId --walletSecret=\"$walletSecret\" --key=$apiKey --ipAddress=$ipAddress --maxPeers=$maxPeers --hallmark=$hallmark --forceScan=$forceScan --forceValidate=$forceValidate --downloadSnapshot=$useSnapshot --snapshotUrl=$snapshotUrl"
#echo "heatUser $heatUser; password $password; heatId $heatId; walletSecret $walletSecret; ipAddress $ipAddress; maxPeers $maxPeers; hallmark $hallmark; forceScan $forceScan; forceValidate $forceValidate; useSnapshot $useSnapshot; snapshotURL snapshotUrl"	
