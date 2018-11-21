# NXGP Masternode
### Bash installer for NXGP Masternode on Ubuntu 16.04 LTS x64

#### To get the daemon from github, login to your vps as root, download the install_mn.sh file and then run it. Note: This will reboot the server.
```
wget https://raw.githubusercontent.com/crypt0n1nj4/nxgp_masternode/master/install_mn.sh
bash ./install_mn.sh
```


#### On the client-side, add the following line to masternode.conf: Masternode Private Key should be aligned between the wallet controller and VPS Wallet
```
node-alias vps-ip:27101	node-key collateral-txid vout
```

#### Run the qt wallet, go to Masternode tab, choose your node and click "start alias" at the bottom.

#### Masternode Setup Guide:
```
