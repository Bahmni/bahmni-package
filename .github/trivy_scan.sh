#!/bin/bash

#Install Trivy Scanner
brew install aquasecurity/trivy/trivy

#Run Trivy Scan
trivy fs --severity "MEDIUM,HIGH,CRITICAL" --exit-code 1 .