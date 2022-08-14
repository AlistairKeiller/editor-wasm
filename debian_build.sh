#!/bin/bash
set -e

# install nessesary pacakges
apt-get install -y ninja-build cmake=3.16.3

# install emscripten
source emscripten.sh

# build llvm
source build.sh
