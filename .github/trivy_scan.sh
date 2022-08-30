#!/bin/bash

PATH_TO_DIRECTORY=$1
PATH_TO_WORKFLOW=$2
#Install Trivy Scanner
brew install aquasecurity/trivy/trivy

if [[ -z "$PATH_TO_WORKFLOW"  ]] ; then
   # if PATH_TO_WORKFLOW not provided, scan PATH_TO_DIRECTORY
   trivy fs --severity "MEDIUM,HIGH,CRITICAL" --exit-code 1 $PATH_TO_DIRECTORY
elif [[ -z "$PATH_TO_DIRECTORY" && -z "$PATH_TO_WORKFLOW" ]] ; then
    # if PATH_TO_WORKFLOW & PATH_TO_DIRECTORY not provided, scan the whole filesystem
    trivy fs --severity "MEDIUM,HIGH,CRITICAL" --exit-code 1 .
else
    trivy fs --severity "MEDIUM,HIGH,CRITICAL" --exit-code 1 $PATH_TO_DIRECTORY
    trivy fs --severity "MEDIUM,HIGH,CRITICAL" --exit-code 1 $PATH_TO_WORKFLOW

fi


