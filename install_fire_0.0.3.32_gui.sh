#!/bin/bash


function getSudo(){
	#gain sudo privileges for this session if not root
	if [[ $EUID -ne 0 ]]; then
		echo "This installer requires root privileges for some functions. Please enter your sudo password. As a security measure, no output will be shown while typing. This is normal. Press enter when finished typing your password."
	  touch $ans
	  sudo cat $ans
	  sudoFinished=$?  
	  if [[ $sudoFinished -gt 0 ]]; then
	  		echo "The installer was unable to gain super user privileges. Exiting."
	  		exit 1
	  	else
	  		return 0 
	  fi
	fi
}
function trim(){
	local out=`echo "$1" | sed 's/^[ \t]*//;s/[ \t]*$//'`
	echo $out
}
function removeExtraWhiteSpace(){
	echo -e "$1" | awk '{$1=$1};1'
}
function removeAllWhiteSpace(){
	echo "$1" | tr -d "[:blank:]"
}
function numbersOnly(){
	echo "$1" | tr -dc '0-9'
}
function tryAgain() {
	whiptail --backtitle "Fire Installer" --title "$1" --msgbox "$2" 0 0
}
function cleanup(){
	rm -r -f $ans
}
function cancel(){
	echo "installation was cancelled"
	return -1
}
function welcome(){
	whiptail --backtitle "Fire Installer" --yes-button "Continue" --no-button "Exit" --title "Install Fire" --yesno "This installer will set up the Heat Ledger node manager 'Fire'. Press continue to get started " 10 30
	continue=$?
	if [[ $continue == 1 ]]; then
		return 1
	else
		return 0
	fi
}

function getWalletAccountNumber(){
	whiptail --backtitle "Fire Installer" --yes-button "Continue" --no-button "Exit" --title "Wallet Account Number" --inputbox "Please enter the numeric account number for your Heat wallet:" 0 0 2> $ans
	continue=$?
	if [[ $continue == 1 ]]; then
		return 1
	fi
	walletAccountNumber=`cat $ans`
	rm $ans
	walletAccountNumber=`numbersOnly "$walletAccountNumber"`
	walNumSize=${#walletAccountNumber}
	if [[ $walNumSize -ge 18 ]]; then
		echo "wallet account number: $walletAccountNumber"
		return 0
	else
		return 2
	fi
	
}

function getWalletSecret(){
	whiptail --backtitle "Fire Installer" --yes-button "Continue" --no-button "Exit" --title "Wallet Secret" --inputbox "Please enter the secret used when creating your Heat wallet. This is required to set up forging and to send some commands to the node" 0 0 2> $ans
	continue=$?
	if [[ $continue == 1 ]]; then
		return 1
	fi
	walletSecret=`cat $ans`
	rm $ans
	walletSecret=`removeExtraWhiteSpace "$walletSecret"`
	secNumSize=${#walletSecret}
	if [[ secNumSize -ge 1 ]]; then
		echo "wallet secret: $walletSecret"
		return 0
	else
		return 2
	fi
}
function getApiKey(){
	whiptail --backtitle "Fire Installer" --yes-button "Continue" --no-button "Exit" --title "API Key" --inputbox "Please enter a key to be used when communicating with node api." 0 0 "changeMePlease" 2> $ans
	continue=$?
	if [[ $continue == 1 ]]; then
		return 1
	fi
	apiKey=`cat $ans | trim`
	rm $ans
	apiKey=`removeExtraWhiteSpace "$apiKey"`
	apiSize=${#apiKey}
	if [[ $apiSize -ge 1 ]]; then
		echo "Api Key: $apiKey"
		return 0
	else
		return 2
	fi
	
}
function getMaxPeers(){
	whiptail --backtitle "Fire Installer" --yes-button "Continue" --no-button "Exit" --title "Max Peers" --inputbox "Please enter the max number of peers node should connect to." 0 0 500 2> $ans
	continue=$?
	if [[ $continue == 1 ]]; then
		return 1
	fi
	maxPeers=`cat $ans`
	rm $ans
	maxPeers=`removeExtraWhiteSpace "$maxPeers"`
	echo "Max Peers: $maxPeers"
	return 0
}
function getForceScan(){
	whiptail --backtitle "Fire Installer" --yes-button "Continue" --no-button "Exit" --title "Force Scan" --radiolist "Enabling the 'Force Scan' setting causes the node to rescan the blockchain. Use arrows to move between options. Use spacebar to select option.Use tab to move between controls" 0 0 2 "Enabled" "Enable the 'force scan' setting" "off" "Disabled" "Disable the 'force scan' setting" "on" 2> $ans
	continue=$?
	if [[ $continue == 1 ]]; then
		return 1
	fi
	forceScan=`cat $ans`
	if [[ $forceScan == "Enabled" ]]; then
		forceScan="true"
	else
		forceScan="false"
	fi
	rm $ans
	echo "force scan: $forceScan"
	return 0
	
}
function getForceValidate(){
	whiptail --backtitle "Fire Installer" --yes-button "Continue" --no-button "Exit" --title "Force Validate" --radiolist "Enabling the 'Force Validate' setting causes the node to validate all transactions . Use arrows to move between options. Use spacebar to select option.Use tab to move between controls" 0 0 2 "Enabled" "Enable the 'force validate' setting" "off" "Disabled" "Disable the 'force validate' setting" "on" 2> $ans
	continue=$?
	if [[ $continue == 1 ]]; then
		return 1
	fi
	forceValidate=`cat $ans`
	if [[ $forceValidate == "Enabled" ]]; then
		forceValidate="true"
	else
		forceValidate="false"
	fi
	rm $ans
	echo "force validate: $forceValidate"
	return 0
}
function getUseSnapshot(){
	whiptail --backtitle "Fire Installer" --yes-button "Continue" --no-button "Exit" --title "Download Blockchain Snapshot" --radiolist "Enabling the 'Download Snapshot' setting will download a snapshot of the blockchain and install it. This can speed of the process of getting the node synced with the network. Use arrows to move between options. Use spacebar to select option.Use tab to move between controls" 0 0 2 "Enabled" "Download a snapshot of the blockchain" "on" "Disabled" "Do not use a snapshot. Blocks will be obtained from peers" "off" 2> $ans
	continue=$?
	if [[ $continue == 1 ]]; then
		return 1
	fi
	useSnapshot=`cat $ans`
	if [[ $useSnapshot == "Enabled" ]]; then
		useSnapshot="true"
	else
		useSnapshot="false"
	fi
	rm $ans
	echo "use snapshot: $useSnapshot"
	return 0
}
function getSnapshotUrl(){
	whiptail --backtitle "Fire Installer" --yes-button "Continue" --no-button "Exit" --title "Blockchain Snapshot URL" --inputbox "Enter the URL to download the blockchain snapshot from below. Defaults to Heat Ledger's daily backup." 0 0 "http://heatledger.net/snapshots/blockchain.zip" 2> $ans
	continue=$?
	if [[ $continue == 1 ]]; then
		return 1
	fi
	snapshotUrl=`cat $ans`
	rm $ans
	snapshotUrl=`removeExtraWhiteSpace "$snapshotUrl"`
	echo "snapshot url: $snapshotUrl"
	return 0
}
function getAutoUpgrade(){
	whiptail --backtitle "Fire Installer" --yes-button "Continue" --no-button "Exit" --title "Auto Upgrade" --radiolist "Enabling the 'Auto Upgrade' setting enables automatic installation of Heat Ledger upgrades. Use arrows to move between options. Use spacebar to select option.Use tab to move between controls" 0 0 2 "Enabled" "Enable the 'auto upgrade' setting" "on" "Disabled" "Disable the 'auto upgrade' setting" "off" 2> $ans
	continue=$?
	if [[ $continue == 1 ]]; then
		return 1
	fi
	autoUpgrade=`cat $ans`
	if [[ $autoUpgrade == "Enabled" ]]; then
		autoUpgrade="true"
	else
		autoUpgrade="false"
	fi
	rm $ans
	echo "auto upgrade: $autoUpgrade"
	return 0
}
function confirm(){
	snapshotString="Download Snapshot: $useSnapshot"
	if [[  $useSnapshot == "true" ]]; then
		snapshotString="$snapshotString \n Snapshot Url: $snapshotUrl"
	fi
	
	whiptail --backtitle "Fire Installer" --yes-button "Continue" --no-button "Exit" --title "Confirm Install Settings" --yesno "Fire will be installed with the following settings: \n Wallet Account Number: $walletAccountNumber \n Wallet Secret: $walletSecret \n Api Key: $apiKey \n Max Peers: $maxPeers \n Force Scan: $forceScan \n Force Validate: $forceValidate \n $snapshotString \n Auto Upgrade: $autoUpgrade " 0 0 2> $ans
	continue=$?
	if [[ $continue == 1 ]]; then
		return 1
	fi
	return 0
}
function installFire(){
	echo "$walletAccountNumber"
	installer="install_fire_$fireVersion.sh"
	wget "https://raw.githubusercontent.com/shaglama/fire/development/$installer"
	chmod +x "$installer"
	/bin/bash "$installer" --options="heatId=$walletAccountNumber;apiKey=$apiKey;walletSecret=$walletSecret;forceScan=$forceScan;forceValidate=$forceValidate;useSnapshot=$useSnapshot;snapshotUrl=$snapshotUrl;autoUpgrade=$autoUpgrade"
	rm $installer
}
########## PROGRAM ##################################################
fireVersion="0.0.3.32"
fireDir=$(mktemp -d -t fireTemp.XXXXXXXXXX ) #####security versiontmp.XXXXXXXXXX)
ans=$fireDir/gui
step="welcome"
heatUser=$USER
walletAccountNumber=
walletSecret=
apiKey=
maxPeers=
forceScan=
forceValidate=
useSnapshot=
snapshotUrl=
autoUpgrade=


getSudo

while [[ ! "$step" == "finished" ]];
	do
		case $step in 
		
			"canceled")
				cancel
				exit 1
				;;
			"welcome")
				welcome
				continue=$?
				if [[ $continue == 0 ]]; then
					step="getWalletAccountNumber"
				else
					step="canceled"
				fi
				;;
			"getWalletAccountNumber")
				getWalletAccountNumber
				continue=$?
				if [[ $continue == 0 ]]; then
					step="getWalletSecret"
				else
					if [[ $continue == 1 ]]; then
						step="canceled"
					else
						tryAgain "Wallet Account Number Error" "The value provided is not a valid account number. Please try again."
						step="getWalletAccountNumber"
					fi
				fi
				;;
			"getWalletSecret")
				getWalletSecret
				continue=$?
				if [[ $continue == 0 ]]; then
					step="getApiKey"
				else
					if [[ $continue == 1 ]]; then
						step="canceled"
					else
						tryAgain "Wallet Secret Error" "The value provided is not a valid wallet secret. Please try again."
						step="getWalletSecret"
					fi
				fi			
				;;
			"getApiKey")
				getApiKey
				continue=$?
				if [[ $continue == 0 ]]; then
					step="getMaxPeers"
				else
					if [[ $continue == 1 ]]; then
						step="canceled"
					else
						tryAgain "Api Key Error" "The value proivded is not a valid api key. Please try again."
						step="getApiKey"
					fi
				fi 
				;;
			"getMaxPeers")
				getMaxPeers
				continue=$?
				if [[ $continue == 0 ]]; then
					step="getForceScan"
				else
					step="canceled"
				fi
				;;
			"getForceScan")
				getForceScan
				continue=$?
				if [[ $continue == 0 ]]; then
					step="getForceValidate"
				else
					step="canceled"
				fi
				;;
			"getForceValidate")
				getForceValidate
				continue=$?
				if [[ $continue == 0 ]]; then
					step="getUseSnapshot"
				else
					step="canceled"
				fi
				;;
			"getUseSnapshot")
				getUseSnapshot
				continue=$?
				if [[ $continue == 0 ]]; then
					if [[ $useSnapshot == "true" ]]; then
						step="getSnapshotUrl"
					else				
						step="getAutoUpgrade"
					fi
				else
					step="canceled"
				fi
				;;
			"getSnapshotUrl")
				getSnapshotUrl
				continue=$?
				if [[ $continue == 0 ]]; then
					step="getAutoUpgrade"
				else
					step="canceled"
				fi
				;;
			"getAutoUpgrade")
				getAutoUpgrade
				echo $autoUpgrade
				continue=$?
				if [[ $continue == 0 ]]; then
					step="confirm"
				else
					step="canceled"
				fi
				;;
			"confirm")
				confirm
				continue=$?
				if [[ $continue == 0 ]]; then
					step="installFire"
				else
					step="canceled"
				fi
				;;
			"installFire")
				installFire
				continue=$?
				if [[ $continue == 0 ]]; then
					step="finished"
				else
					step="canceled"
				fi
				;;
			*)
				echo "invalid step: $step"
				exit 1
				;;
		esac
	
	done

#clean up temp files when script exits
trap cleanup EXIT