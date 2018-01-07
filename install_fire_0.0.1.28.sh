#!/bin/bash
#fire install scrip
#version 0.0.1.28
#Janurary 7, 2018
#Randy Hoggard

##########      *****     FIRE INSTALL SCRIPT     *****     ###################
#	This script will download and install the Heat Ledger installation and
#	monitoring script called fire.
###############################################################################

#@@@@@@@@@     OPTIONS     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#	PLEASE SET THE FOLLOWING VALUES TO YOUR OPTIONS BEFORE RUNNING THIS
#	SCRIPT!

#^^^^^^^^ Required ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
walletSecret="" #the secret passphrase for the wallet running the node, set here or pass as argument
heatId="" #the account id of the wallet running the node, set here or pass in as argument

#<<<<<<<< Optional <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
 
heatUser="$USER" #user to run the node with, defaults to user that runs the script. to set a different user change here or pass in as argument, if user does not exist it will be created
password="" #password for creating a new user, if new user is created without changing the password here or passing in as argument you will need to set the password yourself after running this script
apiKey="changeMePlease" #Default api key, please change or pass in as argument
ipAddress="" #public ip address or host, set here or pass as argument. if no value is set, the script will attempt to obtain it from a public provider (dynDNS)
maxPeers=500 #number of peers node should connect to,set here or pass as argument, defaults to 500
hallmark="" #the node hallmark, increases forging profits, set here or pass in as argument, if not set script will attempt to create a new hallmark for the node
forceScan="false" #if set to true node will be configured to rescan blockchain
forceValidate="false" #if set to true node will be configured to revalidate transactions on the blockchain
useSnapshot="true" #if set to true, a snapshot of the blockchain will be downloaded from heatbrowser.com
snapshotURL="http://heatledger.net/snapshots/blockchain.zip" #the location to download snapshots from, defaults to heatledger.net daily backup
installDir="" #the location to install fire in, defaults to directory script is located in

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

# WARNING: DO NOT CHANGE ANYTHING BELOW UNLESS YOU KNOW WHAT YOU ARE DOING!!!!


#********  Functions *********************************************************
urlencode() {
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



#%%%%%%%% Install fire %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SCRIPT=`readlink -f $0`
SCRIPT_DIR=`dirname $(readlink -f $0)`

if [[ $installDir == "" ]]; then
	installDir="$SCRIPT_DIR"
fi
encoded=`urlencode "$walletSecret"`
echo $encoded
optionsString="heatUser=$heatUser;password=$password;apiKey=$apiKey;ipAddress=$ipAddress;walletSecret=$encoded;heatId=$heatId;maxPeers=$maxPeers;hallmark=$hallmark;forceScan=$forceScan;forceValidate=$forceValidate;useSnapshot=$useSnapshot;snapshotURL=$snapshotURL"
if [[ ! -d $installDir ]]; then
	mkdir $installDir
fi
cd $installDir/
wget "https://github.com/shaglama/fire/raw/development/fire_0.0.1.28.tar.gz"
tar -xzvf fire_0.0.1.28.tar.gz
cd fire
/bin/bash fire --install --installOptions="$optionsString"

