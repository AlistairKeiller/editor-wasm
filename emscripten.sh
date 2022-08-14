#!/bin/sh
git clone https://github.com/emscripten-core/emsdk
cd emsdk
./emsdk install 3.1.6
./emsdk activate 3.1.6
source ./emsdk_env.sh
cd ..
