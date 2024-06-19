#!/bin/bash

release_type=$1

increment_version() {
  local version=$1
  local part=$2
  IFS='.' read -r major minor patch <<< "$version"
  case $part in
    major) echo "$((major + 1)).0.0" ;;
    minor) echo "$major.$((minor + 1)).$patch" ;;
    patch) echo "$major.$minor.$((patch + 1))" ;;
  esac
}

increment_build_number() {
  local build_number=$1
  local part=$2
  IFS='.' read -r major minor patch extra <<< "$build_number"
  case $part in
    major) echo "$((major + 1)).0.0.0" ;;
    minor) echo "$major.$((minor + 1)).$patch.$extra" ;;
    patch) echo "$major.$minor.$patch.$((extra + 1))" ;;
  esac
}

update_version() {
  local file=$1
  local new_version=$2
  local key=$3
  sed -i -E "s/\"$key\": \"[0-9]+\.[0-9]+\.[0-9]+\"/\"$key\": \"$new_version\"/" "$file"
}

update_build_number() {
  local file=$1
  local new_build_number=$2
  sed -i -E "s/\"buildNumber\": \"[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+\"/\"buildNumber\": \"$new_build_number\"/" "$file"
}

case $release_type in
  major | minor | patch)
    echo "Performing actions for $release_type release..."

    # Update version in app.json
    current_version=$(awk -F'"' '/"version":/ {print $4}' app.json | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$')
    new_version=$(increment_version "$current_version" "$release_type")
    update_version app.json "$new_version" "version"

    # Update build number in app.json
    current_build_number=$(awk -F'"' '/"buildNumber":/ {print $4}' app.json)
    new_build_number=$(increment_build_number "$current_build_number" "$release_type")
    update_build_number app.json "$new_build_number"

    # Update marketing version in eas.json
    current_marketing_version=$(awk -F'"' '/"MARKETING_VERSION":/ {print $4}' eas.json)
    new_marketing_version=$(increment_version "$current_marketing_version" "$release_type")
    update_version eas.json "$new_marketing_version" "MARKETING_VERSION"

    # Update version in package.json
    old_version=$(awk -F'"' '/"version":/ {print $4}' package.json | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$')
    latest_version=$(increment_version "$old_version" "$release_type")
    update_version package.json "$latest_version" "version"
    ;;
  *)
    echo "Unknown release type: $release_type"
    ;;
esac

