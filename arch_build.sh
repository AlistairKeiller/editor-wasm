#!/bin/bash
set -e

# install nessesary pacakges
yay -Syu --noconfirm clang ninja

# install emscripten
if [ ! -d emscripten ]; then
    git clone https://github.com/emscripten-core/emsdk
fi
cd emsdk
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh
cd ..

# run build script
. build.sh