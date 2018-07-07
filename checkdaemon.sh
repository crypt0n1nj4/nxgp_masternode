#!/bin/bash
# checkdaemon.sh
# Make sure the daemon is not stuck.
# Add the following to the crontab (i.e. crontab -e)
# */30 * * * * ~/sendnode/checkdaemon.sh

previousBlock=$(cat ~/sendnode/blockcount)
currentBlock=$(sendd getblockcount)

send-cli getblockcount > ~/wirenode/blockcount

if [ "$previousBlock" == "$currentBlock" ]; then
  sendd stop
  sleep 10
  ./sendd -daemon
fi
