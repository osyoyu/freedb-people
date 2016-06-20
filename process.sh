#!/bin/bash

mkdir -p data

if [ ! -f data/freedb.json ]; then
  find $1 -mindepth 1 -maxdepth 1 -type d | xargs ruby freedb_to_json.rb > data/freedb.json
fi
ruby generate_metadata.rb data/freedb.json $2 > data/metadata.json
