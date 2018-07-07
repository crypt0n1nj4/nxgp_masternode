#!/bin/bash
# upgrade.sh
# Make sure sendd is up-to-date
# Add the following to the crontab (i.e. crontab -e)
# 0 0 */1 * * ~/sendnode/upgrade.sh

apt update

if apt list --upgradable | grep -v grep | grep sendd > /dev/null
then
  sendd stop && sleep 10
  rm ~/.send/peers.*
  apt install sendd -y && ./sendd -daemon &
else
  exit
fi
