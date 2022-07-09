#!/bin/bash
set -e


# nessesary packages
apt-get install -y python3 cmake ninja-build

# install emscription
git clone https://github.com/emscripten-core/emsdk
cd emsdk
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh
cd ..

git clone https://github.com/jprendes/emception
cd emception
SRC=$(dirname $0)
BUILD="$1"

if [ "$BUILD" == "" ]; then
    BUILD=$(pwd)/build
fi

SRC=$(realpath "$SRC")
BUILD=$(realpath "$BUILD")

$SRC/build-tooling.sh "$BUILD"

$SRC/build-llvm.sh "$BUILD" "$LLVM_SRC"