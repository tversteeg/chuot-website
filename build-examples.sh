#!/bin/bash

set -eu

# Clone the repo
mkdir -p tmp
if [ ! -d "tmp/chuot" ]; then
  git clone --depth=1 https://github.com/tversteeg/chuot tmp/chuot
else
  echo "Directory tmp/chuot already exists, skipping clone."
  (cd tmp/chuot && git pull origin main)
fi

export date=$(date +"%Y-%m-%d")

for example in $(ls tmp/chuot/examples | grep -e "\.rs$" | sed "s/\.rs//"); do
  # Generate the page
  export example="$example"
  export title="$(echo $example | sed -r 's/(^|_|-)([a-z])/ \U\2/g')"
  export code="$(cat tmp/chuot/examples/$example.rs | sed '/^\/\/!/d' | sed '/./,$!d')"
  export description="$(cat tmp/chuot/examples/$example.rs | sed -n '/^\/\/!/p' | sed 's/\/\/!/\n/g')"

  cat ./example-template.md | envsubst > content/examples/$example.md

  # Build
  (cd tmp/chuot/ && cargo build --target wasm32-unknown-unknown --release --example "$example" --features embed-assets)
  dir="$(pwd)"
  (cd tmp/chuot/ && wasm-bindgen --out-dir $dir/static/wasm/ --target web "target/wasm32-unknown-unknown/release/examples/$example.wasm")
done
