#!/bin/bash
git clone https://github.com/emscripten-core/emsdk
cd emsdk
./emsdk install 3.1.13
./emsdk activate 3.1.13
source ./emsdk_env.sh
cd ..
