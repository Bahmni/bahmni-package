#!/bin/bash

if [[ $(pip list | grep 'bahmni') != "" ]]
then
    pip uninstall -y bahmni
fi
