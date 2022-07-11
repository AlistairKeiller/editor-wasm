#!/bin/bash
# inspired by https://github.com/soedirgo/llvm-wasm

set -e

# nessesary packages
apt-get install -y cmake clang git ninja-build python3

# install emscription
git clone https://github.com/emscripten-core/emsdk
cd emsdk
./emsdk install 3.1.6
./emsdk activate 3.1.6
source ./emsdk_env.sh
cd ..

# build local llvm
git clone https://github.com/llvm/llvm-project
cd llvm-project
git reset --hard 608161225ef1b8d08973188f3162db9363455486
cmake -G Ninja -S llvm -B local-build \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_ENABLE_PROJECTS=clang
cmake --build local-build -- clang-tblgen llvm-tblgen


# build wasm llvm
# emcmake cmake -G Ninja -S llvm -B web-build \
#         -DCMAKE_BUILD_TYPE=Release \
#         -DCMAKE_CROSSCOMPILING=True \
#         -DCMAKE_INSTALL_PREFIX=install \
#         -DCMAKE_CXX_FLAGS='-O3 -s NO_ASSERTIONS -s NO_INVOKE_RUN -s EXIT_RUNTIME -s ALLOW_MEMORY_GROWTH -s INITIAL_MEMORY=64MB -s MODULARIZE -s EXPORT_ES6 -s EXTRA_EXPORTED_RUNTIME_METHODS=["callMain","FS"]' \
#         -DLLVM_ENABLE_THREADS=OFF \
#         -DLLVM_DEFAULT_TARGET_TRIPLE=wasm32-wasi \
#         -DLLVM_TARGET_ARCH=wasm32-emscripten \
#         -DLLVM_ENABLE_PROJECTS=lld \
#         -DLLVM_TABLEGEN=$PWD/local-build/bin/llvm-tblgen

EMCC_DEBUG=2 emcmake cmake -G Ninja -S llvm -B web-build \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_CROSSCOMPILING=True \
        -DCMAKE_INSTALL_PREFIX=install \
        -DCMAKE_CXX_FLAGS='-g2 -s ASSERTIONS=2 -s SAFE_HEAP -s STACK_OVERFLOW_CHECK=2 -s DEMANGLE_SUPPORT -s MALLOC=emmalloc-debug -s EXCEPTION_DEBUG -s PTHREADS_DEBUG -s ABORT_ON_WASM_EXCEPTIONS -s NO_INVOKE_RUN -s EXIT_RUNTIME -s ALLOW_MEMORY_GROWTH -s INITIAL_MEMORY=64MB -s MODULARIZE -s EXPORT_ES6 -s EXTRA_EXPORTED_RUNTIME_METHODS=["callMain","FS"]' \
        -DLLVM_ENABLE_THREADS=OFF \
        -DLLVM_DEFAULT_TARGET_TRIPLE=wasm32-wasi \
        -DLLVM_TARGET_ARCH=wasm32-emscripten \
        -DLLVM_ENABLE_PROJECTS=lld \
        -DLLVM_TABLEGEN=$PWD/local-build/bin/llvm-tblgen
cmake --build web-build