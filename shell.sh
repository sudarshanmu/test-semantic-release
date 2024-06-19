#!/bin/bash

release_type=$1

update_version() {
  local file=$1
  local jq_filter=$2
  local new_version=$3
  jq --arg new_version "$new_version" "$jq_filter" "$file" > tmp.json && mv tmp.json "$file"
}

update_build_number() {
  local file=$1
  local new_build_number=$2
  sed -i "s/\"buildNumber\": \".*\"/\"buildNumber\": \"$new_build_number\"/" "$file"
}

increment_version() {
  local version=$1
  local part=$2
  local IFS='.'
  read -r major minor patch extra <<< "$version"
  case $part in
    major)
      echo "$((major + 1)).0.0"
      ;;
    minor)
      echo "$major.$((minor + 1)).$patch"
      ;;
    patch)
      echo "$major.$minor.$((patch + 1))"
      ;;
  esac
}

increment_build_number() {
  local build_number=$1
  local part=$2
  local IFS='.'
  read -r major minor patch extra <<< "$build_number"
  case $part in
    major)
      echo "$((major + 1)).0.0.0"
      ;;
    minor)
      echo "$major.$((minor + 1)).$patch.$extra"
      ;;
    patch)
      echo "$major.$minor.$patch.$((extra + 1))"
      ;;
  esac
}

case $release_type in
  major | minor | patch)
    echo "Performing actions for $release_type release..."

    current_version=$(jq -r '.expo.version' app.json)
    new_version=$(increment_version "$current_version" "$release_type")
    update_version app.json '.expo.version = $new_version' "$new_version"

    current_build_number=$(jq -r '.expo.ios.buildNumber' app.json)
    new_build_number=$(increment_build_number "$current_build_number" "$release_type")
    update_build_number app.json "$new_build_number"

    current_marketing_version=$(jq -r '.build.base.env.MARKETING_VERSION' eas.json)
    new_marketing_version=$(increment_version "$current_marketing_version" "$release_type")
    update_version eas.json '.build.base.env.MARKETING_VERSION = $new_marketing_version' "$new_marketing_version"

    old_version=$(jq -r '.version' package.json)
    latest_version=$(increment_version "$old_version" "$release_type")
    update_version package.json '.version = $new_version' "$latest_version"
    ;;
  *)
    echo "Unknown release type: $release_type"
    ;;
esac

