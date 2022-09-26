#!/bin/bash

#Make an array of input paths
TARGETS=("$@")
#Count number of inputs
NUMBER_OF_PATHS=${#args[@]} 
#If no input given scan all
if [ -z "$TARGETS" ]; then
    TARGETS=(".")
fi
#Trivy scan the elements of array
for TARGET_PATH in "${TARGETS[@]}";
do
echo "scanning $TARGET_PATH"
trivy fs --severity "MEDIUM,HIGH,CRITICAL" --exit-code 1 $TARGET_PATH
done
