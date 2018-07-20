#!/bin/bash
# install_sub1x_compile.sh
# Installs SUB1X masternode on Ubuntu 16.04 LTS x64
# ATTENTION: The anti-ddos part will disable http, https and dns ports.

if [ "$(whoami)" != "root" ]; then
  echo "Script must be run as user: root"
  exit -1
fi

while true; do
 if [ -d ~/.send ]; then
   printf "~/.send/ already exists! The installer will delete this folder. Continue anyway?(Y/n)"
   read REPLY
   if [ ${REPLY} == "Y" ]; then
      pID=$(ps -ef | grep sendd | awk '{print $2}')
      kill ${pID}
      rm -rf ~/.send/
      break
   else
      if [ ${REPLY} == "n" ]; then
        exit
      fi
   fi
 else
   break
 fi
done

# Warning that the script will reboot the server
echo "WARNING: This script will reboot the server when it's finished."
printf "Press Ctrl+C to cancel or Enter to continue: "
read IGNORE

cd

# Get a new privatekey by going to console >> debug and typing masternode genkey
printf "SUB1X MN GenKey: "
read _nodePrivateKey

# The RPC node will only accept connections from your localhost
_rpcUserName=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12 ; echo '')

# Choose a random and secure password for the RPC
_rpcPassword=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo '')

# Get the IP address of your vps which will be hosting the SUB1X Masternode
_nodeIpAddress=$(ip route get 1 | awk '{print $NF;exit}')

# Make a new directory for SUB1X daemon
mkdir ~/.zsub1x/
touch ~/.zsub1x/zsub1x.conf

# Change the directory to ~/.send
cd ~/.zsub1x/

# Create the initial send.conf file
echo "rpcuser=${_rpcUserName}
rpcpassword=${_rpcPassword}
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
logtimestamps=1
maxconnections=64
txindex=1
masternode=1
externalip=${_nodeIpAddress}:5721
masternodeprivkey=${_nodePrivateKey}
" > send.conf
cd

# Increase swap space
fallocate -l 3G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo -e "/swapfile none swap sw 0 0 \n" >> /etc/fstab

# Install sendd dependencies using apt-get
apt-get update -y 
apt-get upgrade -y 
apt-get install -y pkg-config
apt-get -y install build-essential autoconf automake libtool libboost-all-dev libgmp-dev libssl-dev libcurl4-openssl-dev git
apt install software-properties-common
add-apt-repository ppa:bitcoin/bitcoin -y
apt-get -y update 
apt-get install libdb4.8-dev libdb4.8++-dev -y
apt-get install libzmq3-dev -y
apt-get -y install libdb++-dev libboost-all-dev libcrypto++-dev libqrencode-dev libminiupnpc-dev libgmp-dev libgmp3-dev autogen
apt-get install libevent-dev -y


# Compile from source code
cd
sudo git clone https://github.com/SuB1X-Coin/zSub1x.git 
cd zSuB1X 
sudo chmod +x share/genbuild.sh 
sudo chmod +x autogen.sh 
sudo chmod 755 src/leveldb/build_detect_platform
sudo ./autogen.sh 
sudo ./configure
sudo make
sudo make install

cd ~/zSuB1X/src
strip zsub1xd
strip send-cli

# copy to root directory
cp zsub1xd ../../
cp zsub1x-cli ../../

# copy to usr/bin
cp zsub1xd /usr/bin
cp zsub1x-cli /usr/bin

cd

# Create a directory for sendnode's cronjobs and the anti-ddos script
rm -r zsub1xnode
mkdir zsub1xnode

# Change the directory to ~/sendnode/
cd ~/zsub1xnode/

# Download the appropriate scripts
wget https://raw.githubusercontent.com/crypt0n1nj4/sub1x_masternode/master/makerun.sh
wget https://raw.githubusercontent.com/crypt0n1nj4/sub1x_masternode/master/checkdaemon.sh
wget https://raw.githubusercontent.com/crypt0n1nj4/sub1x_masternode/master/upgrade.sh
wget https://raw.githubusercontent.com/crypt0n1nj4/sub1x_masternode/master/clearlog.sh


# Create a cronjob for making sure sendd runs after reboot
if ! crontab -l | grep "@reboot ./zsub1xd -daemon -txindex"; then
  (crontab -l ; echo "@reboot ./zsub1xd -daemon -txindex") | crontab -
fi

# Create a cronjob for making sure sendd is always running
if ! crontab -l | grep "~/zsub1xnode/makerun.sh"; then
  (crontab -l ; echo "*/5 * * * * ~/zsub1xnode/makerun.sh") | crontab -
fi

# Create a cronjob for making sure sendd is always up-to-date
if ! crontab -l | grep "~/zsub1xnode/upgrade.sh"; then
  (crontab -l ; echo "0 0 */1 * * ~/zsub1xnode/upgrade.sh") | crontab -
fi

# Create a cronjob for making sure the daemon is never stuck
if ! crontab -l | grep "~/zsub1xnode/checkdaemon.sh"; then
  (crontab -l ; echo "*/30 * * * * ~/zsub1xnode/checkdaemon.sh") | crontab -
fi

# Create a cronjob for clearing the log file
if ! crontab -l | grep "~/zsub1xnode/clearlog.sh"; then
  (crontab -l ; echo "0 0 */2 * * ~/zsub1xnode/clearlog.sh") | crontab -
fi

# Give execute permission to the cron scripts
chmod 0700 ./makerun.sh
chmod 0700 ./checkdaemon.sh
chmod 0700 ./upgrade.sh
chmod 0700 ./clearlog.sh

# Firewall security measures
apt install ufw -y
ufw disable
ufw allow 5721
ufw allow 22/tcp
ufw limit 22/tcp
ufw logging on
ufw default deny incoming
ufw default allow outgoing
ufw --force enable

# Reboot the server
reboot
