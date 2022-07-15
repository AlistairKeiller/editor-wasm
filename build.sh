#!/bin/bash
# inspired by https://github.com/soedirgo/llvm-wasm

set -e


# build local llvm
rm -rf llvm-project
git clone https://github.com/llvm/llvm-project
cd llvm-project
cmake -G Ninja -S llvm -B local-build \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_ENABLE_PROJECTS=clang
ninja -C local-build -- clang-tblgen llvm-tblgen


# build wasm llvm
# LDFLAGS="-s LLD_REPORT_UNDEFINED=1 -s ALLOW_MEMORY_GROWTH=1 -s EXPORTED_FUNCTIONS=_main,_free,_malloc -s EXPORTED_RUNTIME_METHODS=FS,PROXYFS,allocateUTF8 -lproxyfs.js" \
CXXFLAGS="-Dwait4=__syscall_wait4" \
emcmake cmake -G Ninja -S llvm -B web-build \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_TARGETS_TO_BUILD=WebAssembly \
        -DLLVM_ENABLE_THREADS=OFF \
        -DLLVM_INCLUDE_TESTS=OFF \
        -DLLVM_TABLEGEN=$PWD/local-build/bin/llvm-tblgen \
        -DCLANG_TABLEGEN=$PWD/local-build/bin/clang-tblgen \
        -DLLVM_ENABLE_PROJECTS="clang;lld" \
        # -DCMAKE_CROSSCOMPILING=True \
        # -DCMAKE_INSTALL_PREFIX=install \
        # -DLLVM_DEFAULT_TARGET_TRIPLE=wasm32-wasi \
        # -DLLVM_TARGET_ARCH=wasm32-emscripten
ninja -C web-build -j1