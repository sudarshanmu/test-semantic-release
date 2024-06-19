#!/bin/bash
sed -i -E 's/("buildNumber": ")([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)"/echo "\1\2."$((${3} + 1))."\4.\5"/e' app.json

#current_build_number=$(cat app.json | jq -r '.expo.ios.buildNumber')
#new_build_number=$(echo $current_build_number | awk -F '.' '{print $1"."($2 + 1)"."$3"."$4}')
#sed -i "s/\"buildNumber\": \".*\"/\"buildNumber\": \"$new_build_number\"/" app.json
