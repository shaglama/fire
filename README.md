# fire 0.0.1.23
January 7, 2018
Randy Hoggard
shaglama@gmail.com

Heat Ledger server installer and monitor for Ubuntu


Fire is an installer, monitor, and manager for Heat Ledger nodes.It is built for Ubuntu 16.04 but may work on newer versions. It will probably not work on older versions as it relies on systemd. It is still in very early alpha and a lot of functionality is still missing. Forging is set for next release but as of this time it does not automatically initiate forging and does not provide a method to do it manually either. 

To install Fire, download the install script install_fire.sh :

wget https://raw.githubusercontent.com/shaglama/fire/development/install_fire.sh

Set the execute permissions:

chmod +x install_fire.sh

Edit the installer script and change the options to your liking:
nano install_fire.sh

At a minimum, you must provide 'walletSecret' and 'heatId' . Be sure to enclose your values in double quotes: "val"

heatUser- the user that will run the node. It defaults to the user running the installer. It can be set to an existing user or it will create a new user if you pass it a name that doesn't exist on the system.If creating a new user, be sure to set password

password- the password of the user that will run the node.No needed if the same user running the installer will be running the node
Required if you provide a user name that does not exist to run the node, as the user will be created.

walletSecret- The secret phrase you used to create your wallet account.

heatId- The numeric id of your wallet account

ipAddress- The public ip address of the node. If you have it, place it here. If not, leave blank and Fire will attempt to obtain it for you.

maxPeers- The max number of peers the node should connect to, defaults to 500

hallmark- The hallmark for the node, increases lottery rewards. If you already have it, place here. If not, leave blank and Fire will obtain one for the node

forceScan- if set to true node will be configured to rescan blockchain

forceValidate- if set to true node will be configured to revalidate transactions on the blockchain

useSnapshot- if set to true, a snapshot of the blockchain will be downloaded to speed up syncing

snapshotURL- the location to download snapshots from, defaults to heatledger.net daily backup

installDir- the location to install fire in, defaults to users home directory



After install, move to the fire directory. From there, you can issue commands to fire like so:

./fire --commandName

A list of currently working (at least partially) commands include:

./fire --uninstall
this will remove Fire from your system


./fire --viewFireStatus
this will show the last status update from fire. Fire updates this status once per minute, so no need to check more often

./fire --viewFireLogs
this will show the status of both the fire_builder and fire_watch services used to run the node

./fire --viewNodeLogs
this will connect to the Heat Ledger nodes log file and follow the output. To exit hold Ctrl and press c

./fire --attachToNode
this will open the screen session the node is running in to view its output. To exit (detach) hold CTRL and press A. Then press D. To kill the node, hold CTRL and press K. Then press Y.



Some others that are almost finished include:
./fire --start
this will start Fire if it is not already running. Fire is configured to start at boot and so you generally don't need to use this unless you manually stop fire

./fire --stop
this will stop Fire and kill the node. You will have to manually restart after this unless you reboot

./fire --restart
this will stop the node and then start it back up again

./fire --info
get info about the nodes status including details about the state of the blockchain and forging status

./fire --reinstall --reinstallOptions="options go here"
reinstall fire, or heat, or both

./fire --refresh 
delete the old copy of blockchain, download a new one if desired, and restart the node


Many more features planned soon so check back often. 
Donations appreciated:

HEAT: 18204334369979641558
BTC: 15D9TLNu6FFoLiTJGbdMBpT6TETMsPc2xT
LTC: LfXgenZQC81sQ1kc3G5JwGCdBb8DLVY6LU
DOGE: DE52xxNkGYGxGpFQzy96VKcAki4bC9PKoi
