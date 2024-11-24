#!/bin/bash

# Tags that should get a badge when chuot compiles for it
declare -a tags=("0.3.0" "0.3.1")

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

# Clone the repo with the released tags
for tag in "${tags[@]}"; do
  export VERSION_DIR="tmp/chuot-$tag"

  if [ ! -d "$VERSION_DIR" ]; then
    git clone --depth=1 https://github.com/tversteeg/chuot $VERSION_DIR --branch v$tag
    (cd $VERSION_DIR && rm examples -rf)
  else
    (cd $VERSION_DIR && rm examples -rf && git checkout -- . && git pull && rm examples -rf)
  fi
done

# Copy the assets
cp -R $DIR/assets static/

export date=$(date +"%Y-%m-%d")

for example in $(ls $DIR/examples | grep -e "\.rs$" | sed "s/\.rs//"); do
  # Generate the page
  export example="$example"
  export title="$(echo $example | sed -r 's/(^|_|-)([a-z])/ \U\2/g')"
  export code="$(cat $DIR/examples/$example.rs | sed '/^\/\/!/d' | sed '/./,$!d')"
  export description="$(cat $DIR/examples/$example.rs | sed -n '/^\/\/!/p' | sed 's/\/\/!/\n/g')"
  export versions=""

  # Check versions
  for tag in "${tags[@]}"; do
    export VERSION_DIR="tmp/chuot-$tag"

    mkdir -p "$VERSION_DIR/examples"
    cp "$DIR/examples/${example}.rs" "$VERSION_DIR/examples/"

    export versions="${versions}| [$tag](https://github.com/tversteeg/chuot/releases/tag/v$tag) | "

    # Try to build the example to create a badge
    if (cd "$VERSION_DIR" && cargo check --target wasm32-unknown-unknown --release --example "$example" 2> /dev/null); then
      export versions="$versions ✅"
    else
      export versions="$versions 🚫"
    fi

    export versions="$versions |**NEWLINE**"
  done

  cat ./example-template.md | envsubst > content/examples/$example.md
  sed -i -e 's/\*\*NEWLINE\*\*/\n/g' content/examples/$example.md

  # Build
  (cd $DIR/ && cargo build --target wasm32-unknown-unknown --release --example "$example" --features embed-assets)
  dir="$(pwd)"
  (cd $DIR/ && wasm-bindgen --out-dir $dir/static/wasm/ --target web "target/wasm32-unknown-unknown/release/examples/$example.wasm")
done
