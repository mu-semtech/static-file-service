#!/bin/bash

if [ -f "/data/index.html" ]
then
    # Replace Ember environment variables in the build of the frontend
    PREFIX="EMBER_"
    ENV_VARIABLES=$(env | grep "${PREFIX}")

    while IFS= read -r line; do
        ENV_VARIABLE=$(echo "$line" | sed -e "s/^$PREFIX//" | cut -f1 -d"=")
        VALUE=$(echo "$line" | sed -e 's/[\/&]/\\&/g' | cut -d"=" -f2-)
        sed -i "s/%7B%7B$ENV_VARIABLE%7D%7D/$VALUE/g" /data/index.html
        sed -i "s/{{$ENV_VARIABLE}}/$VALUE/g" /data/index.html
    done <<< "$ENV_VARIABLES"
fi

nginx -g "daemon off;"
