#!/bin/bash
set -e

# install nessesary pacakges
apt-get install -y ninja-build

# build llvm
source build.sh
