#!/bin/bash
current_version=$(cat app.json | jq -r '.expo.version')
new_version=$(echo $current_version | awk -F '.' '{print $1"."($2 + 1)"."$3}')
jq --arg new_version "$new_version" '.expo.version = $new_version' app.json > tmp.json && mv tmp.json app.json
#sed -i "s/\"version\": \".*\"/\"version\": \"$new_version\"/" app.json

current_build_number=$(cat app.json | jq -r '.expo.ios.buildNumber')
new_build_number=$(echo $current_build_number | awk -F '.' '{print $1"."($2 + 1)"."$3"."$4}')
sed -i "s/\"buildNumber\": \".*\"/\"buildNumber\": \"$new_build_number\"/" app.json

