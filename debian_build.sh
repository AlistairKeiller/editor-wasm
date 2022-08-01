#!/bin/bash
set -e

# install nessesary pacakges
apt-get install -y clang ninja-build libc++-dev

# install emscripten
source emscripten.sh

# build llvm
source build.sh
