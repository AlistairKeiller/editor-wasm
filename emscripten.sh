#!/bin/bash
git clone https://github.com/emscripten-core/emsdk
cd emsdk
./emsdk install 3.1.15
./emsdk activate 3.1.15
source ./emsdk_env.sh
cd ..
