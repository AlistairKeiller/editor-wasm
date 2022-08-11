#!/bin/bash
set -e

# install nessesary pacakges
apt-get install -y ninja-build
apt-get update
apt-get upgrade

# install emscripten
source emscripten.sh

# build llvm
source build.sh
