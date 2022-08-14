#!/bin/bash
set -e

# install nessesary pacakges
apt-get install -y ninja-build clang cmake

# install emscripten
source emscripten.sh

# build llvm
source build.sh
