#!/bin/bash

release_type=$1

if [ "$release_type" = "major" ]; then
    echo "Performing actions for major release..."
elif [ "$release_type" = "minor" ]; then
    echo "Performing actions for minor release..."
elif [ "$release_type" = "patch" ]; then
    echo "Performing actions for patch release..."
else
    echo "Unknown release type: $release_type"
fi

