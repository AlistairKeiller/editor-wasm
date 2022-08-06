#!/bin/bash

# install nessesary pacakges
apt-get install -y ninja-build

# install emscripten
source emscripten.sh

# build llvm
source build.sh
