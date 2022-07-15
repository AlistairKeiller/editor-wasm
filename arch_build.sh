#!/bin/bash
set -e

# install nessesary pacakges
yay -Syu --noconfirm clang ninja

# install emscripten
rm -rf emsdk
git clone https://github.com/emscripten-core/emsdk
cd emsdk
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh
cd ..

# run build script
source build.sh