#!/usr/bin/env bash

echo "Starting installation process!"
echo "The current user is $(whoami)"
files="$AIRFLOW_HOME/scripts/cli_scripts/*"
# files="../cli_scripts/*"

for file in $files
do
    source $file
done

echo "The cli tools have been installed. Have an amazing day!"
