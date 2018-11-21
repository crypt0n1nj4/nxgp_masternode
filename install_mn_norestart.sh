#!/bin/bash
# install_mn.sh
# Installs NXGP masternode on Ubuntu 16.04 LTS x64
# ATTENTION: The anti-ddos part will disable http, https and dns ports.

if [ "$(whoami)" != "root" ]; then
  echo "Script must be run as user: root"
  exit -1
fi

while true; do
 if [ -d ~/.NexTGenPay ]; then
   printf "~/.NexTGenPay/ already exists! The installer will delete this folder. Continue anyway?(Y/n)"
   read REPLY
   if [ ${REPLY} == "Y" ]; then
      pID=$(ps -ef | grep NexTGenPayd | awk '{print $2}')
      kill ${pID}
      rm -rf ~/.NexTGenPay/
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

cd

# Get a new privatekey by going to console >> debug and typing masternode genkey
printf "NXGP MN GenKey: "
read _nodePrivateKey

# The RPC node will only accept connections from your localhost
_rpcUserName=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12 ; echo '')

# Choose a random and secure password for the RPC
_rpcPassword=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo '')

# Get the IP address of your vps which will be hosting the NXGP Masternode
_nodeIpAddress=$(ip route get 1 | awk '{print $NF;exit}')

# Make a new directory for NXGP daemon
mkdir ~/.NexTGenPay/
touch ~/.NexTGenPay/NexTGenPay.conf

# Change the directory to ~/.NexTGenPay
cd ~/.NexTGenPay/

# Create the initial NexTGenPay.conf file
echo "rpcuser=${_rpcUserName}
rpcpassword=${_rpcPassword}
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
logtimestamps=1
maxconnections=256
txindex=1
masternode=1
externalip=${_nodeIpAddress}:27101
masternodeprivkey=${_nodePrivateKey}
" > NexTGenPay.conf
cd

# Increase swap space
fallocate -l 3G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo -e "/swapfile none swap sw 0 0 \n" >> /etc/fstab

# Install NexTGenPayd dependencies using apt-get
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

cd

# get the latest LINUX version of the wallet
wget https://github.com/crypt0n1nj4/nxgp_masternode/raw/master/NexTGenPayd
wget https://github.com/crypt0n1nj4/nxgp_masternode/raw/master/NexTGenPay-cli

# make the daemons executable
chmod +x NexTGenPayd
chmod +x NexTGenPay-cli

# copy to usr/bin
cp NexTGenPayd /usr/bin
cp NexTGenPay-cli /usr/bin



# Create a cronjob for making sure NexTGenPayd runs after reboot
if ! crontab -l | grep "@reboot ./NexTGenPayd -daemon -txindex"; then
  (crontab -l ; echo "@reboot ./NexTGenPayd -daemon -txindex") | crontab -
fi


# Firewall security measures
apt install ufw -y
ufw disable
ufw allow 27101
ufw allow 22/tcp
ufw limit 22/tcp
ufw logging on
ufw default deny incoming
ufw default allow outgoing
ufw --force enable
