#!/bin/bash

set -eu

export DIR=tmp/chuot

# Clone the repo
mkdir -p tmp
if [ ! -d "tmp/chuot" ]; then
  if [ -d "../chuot" ]; then
    export DIR=../chuot
  else
    # Otherwise clone it
    git clone --depth=1 https://github.com/tversteeg/chuot tmp/chuot
  fi
else
  if [ ! -d "../chuot" ]; then
    echo "Directory tmp/chuot already exists, skipping clone"

    (cd $DIR && git pull origin main)
  fi
fi

# Copy the assets
cp -R $DIR/assets static/

export date=$(date +"%Y-%m-%d")

for example in $(ls $DIR/examples | grep -e "\.rs$" | sed "s/\.rs//"); do
  # Generate the page
  export example="$example"
  export title="$(echo $example | sed -r 's/(^|_|-)([a-z])/ \U\2/g')"
  export code="$(cat $DIR/examples/$example.rs | sed '/^\/\/!/d' | sed '/./,$!d')"
  export description="$(cat $DIR/examples/$example.rs | sed -n '/^\/\/!/p' | sed 's/\/\/!/\n/g')"

  cat ./example-template.md | envsubst > content/examples/$example.md

  # Build
  (cd $DIR/ && cargo build --target wasm32-unknown-unknown --release --example "$example" --features embed-assets)
  dir="$(pwd)"
  (cd $DIR/ && wasm-bindgen --out-dir $dir/static/wasm/ --target web "target/wasm32-unknown-unknown/release/examples/$example.wasm")
done
