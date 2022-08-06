#!/bin/bash
# inspired by https://github.com/soedirgo/llvm-wasm

# build tblgen for host
git clone https://github.com/llvm/llvm-project
cd llvm-project
cmake -G Ninja -S llvm -B local-build \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_ENABLE_PROJECTS=clang
ninja -C local-build -- clang-tblgen llvm-tblgen

# download sysroot
wget -qO- https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-16/wasi-sysroot-16.0.tar.gz | tar -xz
mv wasi-sysroot wsysroot

echo 'target_link_options(clang PUBLIC "--preload-file=wsysroot")' | tee -a CMakeLists.txt 

# build wasm llvm
CXXFLAGS="-Dwait4=__syscall_wait4" \
LDFLAGS='-sEXPORTED_RUNTIME_METHODS=FS,callMain -sALLOW_MEMORY_GROWTH -sEXPORT_ES6 -sMODULARIZE' \
emcmake cmake -G Ninja -S llvm -B web-build \
        -DCMAKE_BUILD_TYPE=MinSizeRel \
        -DLLVM_TARGETS_TO_BUILD=WebAssembly \
        -DLLVM_INCLUDE_TESTS=OFF \
        -DLLVM_BUILD_TOOLS=OFF \
        -DLLVM_TABLEGEN=$PWD/local-build/bin/llvm-tblgen \
        -DCLANG_TABLEGEN=$PWD/local-build/bin/clang-tblgen \
        -DLLVM_ENABLE_PROJECTS="clang;lld;clang-tools-extra" \
        -DLLVM_PARALLEL_LINK_JOBS=1 \
        -DLLVM_ENABLE_LIBCXX=ON




ninja -C web-build
