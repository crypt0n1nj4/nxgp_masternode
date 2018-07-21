# SUB1X Masternode
### Bash installer for SUB1X Masternode on Ubuntu 16.04 LTS x64

#### This shell script comes with 4 cronjobs: 
1. Make sure SUB1X daemon is always running: `makerun.sh`
2. Make sure SUB1X daemon is never stuck: `checkdaemon.sh`
3. Make sure SUB1X daemon is always up-to-date: `upgrade.sh`
4. Clear the log file every other day: `clearlog.sh`


#### To compile the daemon from source code. Login to your vps as root, download the install_sub1x_compile.sh file and then run it. Note: This will reboot the server.
```
wget https://raw.githubusercontent.com/crypt0n1nj4/sub1x_masternode/master/install_sub1x_mn.sh
bash ./install_sub1x_compile.sh
```


#### On the client-side, add the following line to masternode.conf: Masternode Private Key should be aligned between the wallet controller and VPS Wallet
```
node-alias vps-ip:5721	node-key collateral-txid vout
```

#### Run the qt wallet, go to Masternode tab, choose your node and click "start alias" at the bottom.

#### Masternode Setup Guide:
```

```
