#!/bin/bash
set -e

# install nessesary pacakges
yay -Syu --noconfirm clang ninja

# install emscripten
source emscripten.sh

# build llvm
source build.sh