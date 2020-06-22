#!/bin/bash

if [ $# -lt 1 ] ; then
	echo "ssh-postgres cfappname"
	exit
fi
PREFIX=$1

echo "SSH: cf ssh -L 5432:localhost:5432 ${PREFIX}"
cf ssh -L 5432:localhost:5432 ${PREFIX}

#cf remove-network-policy SOURCE_APP --destination-app DESTINATION_APP -s DESTINATION_SPACE_NAME -o DESTINATION_ORG_NAME --protocol PROTOCOL --port RANGE