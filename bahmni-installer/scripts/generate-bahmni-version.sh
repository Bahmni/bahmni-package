#!bin/bash
for file in rpms/*; do
  name=${file##*/}
  echo ${name%.noarch.rpm} | sed 's/-/_/g'| rev | sed 's/_/ :noisrev_/2' |  sed 's/_/-/1' | rev >> rpm_versions.yml
done
