#!/bin/bash
set -e

# install nessesary pacakges
apt-get install -y ninja-build cmake
rm /bin/cmake
ln -s /bin/cmake /usr/bin/cmake

# install emscripten
source emscripten.sh

# build llvm
source build.sh
