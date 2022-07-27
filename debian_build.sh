#!/bin/bash
set -e

# install nessesary pacakges
apt-get install -y clang ninja-build libc++
apt-get update
apt-get upgrade -y

# install emscripten
source emscripten.sh

# build llvm
source build.sh