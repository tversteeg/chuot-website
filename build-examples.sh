#!/bin/bash

set -eu

mkdir -p tmp
if [ ! -d "tmp/chuot" ]; then
  git clone --depth=1 https://github.com/tversteeg/chuot tmp/chuot
else
  echo "Directory tmp/chuot already exists, skipping clone."
fi

(cd tmp/chuot && git pull origin main)

export date=$(date +"%Y-%m-%d")

for example in $(ls tmp/chuot/examples | grep -e "\.rs$" | sed "s/\.rs//"); do
  export example="$example"
  export code="$(cat tmp/chuot/examples/$example.rs | sed '/^\/\/!/d' | sed '/./,$!d')"
  export description="$(cat tmp/chuot/examples/$example.rs | sed -n '/^\/\/!/p' | sed 's/\/\/!/\n/g')"

  cat ./example-template.md | envsubst > content/examples/$example.md
  
done
