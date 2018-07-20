#!/bin/bash
# makerun.sh
# Make sure sendd is always running.
# Add the following to the crontab (i.e. crontab -e)
# */5 * * * * ~/zsub1xnode/makerun.sh

if ps -A | grep zsub1xd > /dev/null
then
  exit
else
  ./zsub1xd -daemon &
fi
