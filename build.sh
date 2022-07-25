#!/bin/bash
# inspired by https://github.com/soedirgo/llvm-wasm

# build tblgen for host
rm -rf llvm-project
git clone https://github.com/llvm/llvm-project
cd llvm-project
cmake -G Ninja -S llvm -B local-build \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_ENABLE_PROJECTS=clang
ninja -C local-build -- clang-tblgen llvm-tblgen


# build wasm llvm
CXXFLAGS="-Dwait4=__syscall_wait4" \
emcmake cmake -G Ninja -S llvm -B web-build \
        -DCMAKE_BUILD_TYPE=MinSizeRel \
        -DLLVM_TARGETS_TO_BUILD=WebAssembly \
        -DLLVM_INCLUDE_TESTS=OFF \
        -DLLVM_BUILD_TOOLS=OFF \
        -DCMAKE_CXX_FLAGS='-s EXPORT_ES6' \
        -DLLVM_TABLEGEN=$PWD/local-build/bin/llvm-tblgen \
        -DCLANG_TABLEGEN=$PWD/local-build/bin/clang-tblgen \
        -DLLVM_ENABLE_PROJECTS="clang;lld;clang-tools-extra" \
        -DLLVM_PARALLEL_LINK_JOBS=1

ninja -C web-build