# SEND Masternode
### Bash installer for SEND Masternode on Ubuntu 16.04 LTS x64

#### This shell script comes with 4 cronjobs: 
1. Make sure SEND daemon is always running: `makerun.sh`
2. Make sure SEND daemon is never stuck: `checkdaemon.sh`
3. Make sure SEND daemon is always up-to-date: `upgrade.sh`
4. Clear the log file every other day: `clearlog.sh`

#### Login to your vps as root, download the install_sendmn.sh file and then run it:
```
wget https://raw.githubusercontent.com/crypt0n1nj4/send_masternode/master/install_sendmn.sh
bash ./install_sendmn.sh
```

#### If you just want to install without dependencies, Login to your vps as root, download the install_sendmn_nodeps.sh file and then run it:
```
wget https://raw.githubusercontent.com/crypt0n1nj4/send_masternode/master/install_sendmn_nodeps.sh
bash ./install_sendmn_nodeps.sh
```


#### On the client-side, add the following line to masternode.conf: Masternode Private Key should be aligned between the wallet controller and VPS Wallet
```
node-alias vps-ip:50050	node-key collateral-txid vout
```

#### Run the qt wallet, go to Masternode tab, choose your node and click "start alias" at the bottom.

#### Masternode Setup Guide:
```

```
