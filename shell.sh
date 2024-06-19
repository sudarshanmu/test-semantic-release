#!/bin/bash

release_type=$1

if [ "$release_type" = "minor" ]; then
  echo "Performing actions for patch release..."
  current_version=$(cat app.json | jq -r '.expo.version')
  new_version=$(echo $current_version | awk -F '.' '{print $1"."$2"."($3 + 1)}')
  jq --arg new_version "$new_version" '.expo.version = $new_version' app.json > tmp.json && mv tmp.json app.json

  current_build_number=$(cat app.json | jq -r '.expo.ios.buildNumber')
  new_build_number=$(echo $current_build_number | awk -F '.' '{print $1"."$2"."$3"."($4 + 1)}')
  sed -i "s/\"buildNumber\": \".*\"/\"buildNumber\": \"$new_build_number\"/" app.json

  current_marketing_version=$(cat eas.json | jq -r '.build.base.env.MARKETING_VERSION')
  new_marketing_version=$(echo $current_marketing_version | awk -F '.' '{print $1"."$2"."($3 + 1)}')
  jq --arg new_marketing_version "$new_marketing_version" '.build.base.env.MARKETING_VERSION = $new_marketing_version' eas.json > tmp.json && mv tmp.json eas.json

  old_version=$(cat package.json | jq -r '.version')
  latest_version=$(echo $old_version | awk -F '.' '{print $1"."$2"."($3 + 1)}')
  sed -i "s/\"version\": \".*\"/\"version\": \"$latest_version\"/" package.json
else
  echo "Unknown release type: $release_type"
fi
