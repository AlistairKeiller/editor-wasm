#!/bin/bash
set -e

# install nessesary pacakges
apt-get install -y clang ninja

# install emscripten
source emscripten.sh

# build llvm
source build.sh