#!/bin/sh
set -e

echo "[INFO] Substituting Environment Variables"
envsubst < application.yml.template > application.yml
echo "[INFO] Starting Application"
java -jar *.jar --spring.config.location=appilcation.yml