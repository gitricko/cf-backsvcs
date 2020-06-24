#!/bin/bash

if [ $# -lt 1 ] ; then
	echo "ssh-redis cfappname"
	exit
fi
PREFIX=$1

echo "SSH: cf ssh -L 6379:localhost:6379 ${PREFIX}"
cf ssh -L 6379:localhost:6379 ${PREFIX}

# cf add-network-policy namekoexample --destination-app cfredis --protocol tcp --port 6379