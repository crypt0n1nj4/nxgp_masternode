#!/bin/bash
# upgrade.sh
# Make sure sendd is up-to-date
# Add the following to the crontab (i.e. crontab -e)
# 0 0 */1 * * ~/zsub1xnode/upgrade.sh

apt update

if apt list --upgradable | grep -v grep | grep zsub1xd > /dev/null
then
  zsub1x-cli stop && sleep 10
  rm ~/.send/peers.*
  apt install zsub1xd -y && ./zsub1xd -daemon &
else
  exit
fi
