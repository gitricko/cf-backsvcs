#!/bin/bash

if [ $# -lt 1 ] ; then
	echo "ssh-rabbit cfappname"
	exit
fi
PREFIX=$1

echo "SSH: cf ssh -L 5672:localhost:5672 ${PREFIX}"
cf ssh -L 15672:localhost:15672 ${PREFIX}

#cf remove-network-policy SOURCE_APP --destination-app DESTINATION_APP -s DESTINATION_SPACE_NAME -o DESTINATION_ORG_NAME --protocol PROTOCOL --port RANGE