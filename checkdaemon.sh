#!/bin/bash
# checkdaemon.sh
# Make sure the daemon is not stuck.
# Add the following to the crontab (i.e. crontab -e)
# */30 * * * * ~/zsub1xd/checkdaemon.sh

previousBlock=$(cat ~/zsub1xnode/blockcount)
currentBlock=$(zsub1x-cli getblockcount)

zsub1x-cli getblockcount > ~/zsub1xnode/blockcount

if [ "$previousBlock" == "$currentBlock" ]; then
  zsub1xd stop
  sleep 10
  ./zsub1xd -daemon
fi
