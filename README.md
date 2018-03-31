# fire 0.0.3.43
March 31, 2018
Randy Hoggard
shaglama@gmail.com

Heat Ledger server installer and monitor for Ubuntu


Fire is an installer, monitor, and manager for Heat Ledger nodes.It is built for Ubuntu 16.04 or newer versions. It will probably not work on older versions as it relies on systemd. It is still in very early alpha and a lot of functionality is still missing. However, it now performs its core tasks well. It currently will download the newest version of Heat Ledger, install  it, set up a service to monitor it, and initiate forging after the node has synced. It automatically enables the node to come up after reboots as well. It also provides basic information about the state of the node.

#####     Whats new     ######################################################

** Increased the length of time between attempts to get hallmark to allow the node more time to start and become capable of repsonding to requests. The hallmark function was timing out before the node was ready with new version

** Implmented timing system for log clearing so it doesn't run every iteration

** Fixed typo in fire_watch where pid file was specified

** Added script to clean fire_watch log to keep its size from growing out of control

** Fixed typo that prevented stop and restart functions from running

** Added testing folders to the github repository that include scripts being worked on for future releases

** Fixed problem with screens not being killed when service stops

** Hallmark generation moved to local node for added security

** Added more verification for some variables

** Updated some comments and removed some debug logging

** Ability to refresh blockchain added

** Fire now has a text mode GUI for the installer

** Cli install script now supports option 'optionString'

** Cli install script now supports passing install options via argument --options=

** Upgrade funcatioality implmented. Now includes option for auto upgrading

** Finished stop and start functions

##     Installation With text mode GUI     ###################################

### Step 1
Download the GUI install script:


wget https://raw.githubusercontent.com/shaglama/fire/development/install_fire_0.0.3.43_gui.sh


### Step 2
Set the execute permission:

chmod +x install_fire_0.0.3.43_gui.sh

### Step 3
Run the installer

./install_fire_0.0.3.43_gui.sh

##     Installation With Cli Script     ######################################
### Step 1
Download the install script:

wget https://raw.githubusercontent.com/shaglama/fire/development/install_fire_0.0.3.43.sh

### Step 2
Set the execute permissions:

chmod +x install_fire_0.0.3.43.sh

### Step 3
Choose whether you would like set the options by editing the script or set the options by passing arguments to the command
If you choose to edit the script, proceed to step 3a. If you would rather pass the options as arguments, proceed to step 4b.

#### Step 3a
Edit the installer script and change the options to your liking (Available options described later in this document):

nano install_fire_0.0.3.43.sh
After editing, hold control and press 'o' to save.Then hold control and press 'x' to close

### Step 4
If you set the options by editing the script in step 3, proceed to step 4a. If you decided to pass the options as arguments in step 3, proceed to step 4b

#### Step 4a
Run the installer script

./install_fire_0.0.3.43.sh

#### Step 4b
Pass the options as argument to the installer and run installer script

./install_fire_0.0.3.43.sh --options="opition1Name=option1Val;option2Name=option2Val"

Note:  see 'options' option below

##     Options     ############################################################
At a minimum, you must provide 'walletSecret' and 'heatId' .When editing values in the script file, be sure to enclose your values in double quotes: "val"

options- a ';' delimited string composed of the rest of the available options. The string should be in the form of:
  "option1=value;option2=value;option3=value"

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

autoUpgrade- enable automatic upgrading


##     Usage     ###########################################################################

After install, move to the fire directory. From there, you can issue commands to fire like so:

./fire --commandName


A list of currently working (at least partially) commands include:

./fire --info
this show the state of the blockchain and whether the node is synced. Also shows forging status.

./fire --uninstall

this will remove Fire from your system

./fire --viewFireStatus

this will show the last status update from fire. Fire updates this status once per minute, so no need to check more often

./fire --viewFireLogs

this will show the status of both the fire_builder and fire_watch services used to run the node

./fire --viewNodeLogs

this will connect to the Heat Ledger nodes log file and follow the output. To exit hold Ctrl and press c

./fire --attachToNode

this will open the screen session the node is running in to view its output. To exit (detach) hold CTRL and press A. Then press D. To kill the node, hold CTRL and press K. Then press Y. Note; the node will be automatically restarted by the service. To stop the node without restart use the stop command.

./fire --start
this will start Fire and the Heat Ledger node if it is not already running. Fire is configured to start at boot so you generally don't need to use this unless you manually stop the node

./fire --stop
this will stop Fire and the Heat Ledger  node if it is running

./fire --restart
this will stop Fire and the Heat Ledger node and then start both

./fire --upgrade
this will check for a new version of Heat Ledger and install it if found

./fire --refreshBlockchain
this will delete the current blockchain and restart the node. If the useSnapshot setting is set to true, a snapshot will be downloaded and installed before restarting the node. 
**************************************************************************************************

Some others that are almost finished include:

this will stop the node and then start it back up again

./fire --reinstall --reinstallOptions="options go here"

reinstall fire, or heat, or both

**************************************************************************************************

## Coming Soon

Some of the features planned for upcoming releases include:

Encryption of sensitive settings

Option to load installer options from config file (this will make it very easy to mass install)

Text-mode UI

Web Based UI

And many more!!!! Check back soon to see the progress.



## Get Involved
If you have any questions about the script or problems running it or would like to help with the development of this script please contact shaglama@gmail.com

Donations appreciated:

HEAT: 18204334369979641558

BTC: 15D9TLNu6FFoLiTJGbdMBpT6TETMsPc2xT

LTC: LfXgenZQC81sQ1kc3G5JwGCdBb8DLVY6LU

DOGE: DE52xxNkGYGxGpFQzy96VKcAki4bC9PKoi

