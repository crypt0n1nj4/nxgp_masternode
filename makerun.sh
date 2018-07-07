#!/bin/bash
# makerun.sh
# Make sure sendd is always running.
# Add the following to the crontab (i.e. crontab -e)
# */5 * * * * ~/sendnode/makerun.sh

if ps -A | grep sendd > /dev/null
then
  exit
else
  ./sendd -daemon &
fi
