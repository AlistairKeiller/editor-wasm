#!/bin/bash
set -e

git clone https://github.com/emscripten-core/emsdk
cd emsdk
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh

yay -S clang ninja

bash build.sh