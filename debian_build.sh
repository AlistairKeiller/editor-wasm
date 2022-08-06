#!/bin/bash
set -e

# install nessesary pacakges
apt-get install -y clang ninja-build libstdc++-12-dev

# install emscripten
source emscripten.sh

# build llvm
source build.sh
