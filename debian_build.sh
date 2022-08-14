#!/bin/bash
set -e

# install nessesary pacakges
apt-get purge cmake
wget https://apt.kitware.com/kitware-archive.sh
source kitware-archive.sh

apt-get install -y ninja-build cmake

apt-get update
apt-get upgrade

# install emscripten
source emscripten.sh

# build llvm
source build.sh
