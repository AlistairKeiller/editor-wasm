#!/bin/bash
set -e

# nessesary packages
apt-get install -y python3 cmake ninja-build

# install emscription
git clone https://github.com/emscripten-core/emsdk
cd emsdk
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh
cd ..

# build local llvm
git clone https://github.com/llvm/llvm-project
cd llvm-project
cmake -G Ninja \
        -S llvm \
        -B local_build \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_TARGETS_TO_BUILD=WebAssembly \
        -DLLVM_ENABLE_PROJECTS="clang"
cmake --build local_build -- llvm-tblgen clang-tblgen


# build wasm llvm
emcmake cmake -G Ninja \
        -S llvm \
        -B web_build \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_TARGETS_TO_BUILD=WebAssembly \
        -DLLVM_ENABLE_PROJECTS="clang;lld;clang-tools-extra" \
        -DLLVM_ENABLE_DUMP=OFF \
        -DLLVM_ENABLE_ASSERTIONS=OFF \
        -DLLVM_ENABLE_EXPENSIVE_CHECKS=OFF \
        -DLLVM_ENABLE_BACKTRACES=OFF \
        -DLLVM_BUILD_TOOLS=OFF \
        -DLLVM_ENABLE_THREADS=OFF \
        -DLLVM_BUILD_LLVM_DYLIB=OFF \
        -DLLVM_INCLUDE_TESTS=OFF \
        -DLLVM_TABLEGEN=$(pwd)/local_build/bin/llvm-tblgen \
        -DCLANG_TABLEGEN=$(pwd)/local_build/bin/clang-tblgen

# patches
sed -i -E 's/\.(m?)js-([0-9]+)/-\2.\1js/g' $(pwd)/web_build/build.ninja
sed -i -E 's/\.js/.mjs/g' $(pwd)/web_build/build.ninja
sed -i -E 's/proxyfs\.mjs/proxyfs.js/g' $(pwd)/web_build/build.ninja

emmake cmake --build web_build