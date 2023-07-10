#!/bin/bash
FIRST_NAME=$1
LAST_NAME=$2
SHOW=$3
if [ "$3" = true ]; then
echo "Hello $FIRST_NAME $LAST_NAME, Today's date & time is $(date)"
else
echo "If you want to see the greeting, select the show checkbox"
fi