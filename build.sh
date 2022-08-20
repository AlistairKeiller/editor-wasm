#!/bin/sh
# inspired by https://github.com/soedirgo/llvm-wasm

set -e

# build llvm for host
git clone https://github.com/llvm/llvm-project
cmake -G Ninja -S llvm-project/llvm -B host-llvm-build \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_ENABLE_PROJECTS="lld;clang" \
        -DLLVM_TARGETS_TO_BUILD="host;WebAssembly" \
        -DLLVM_INCLUDE_BENCHMARKS=OFF \
        -DLLVM_INCLUDE_EXAMPLES=OFF \
        -DLLVM_INCLUDE_TESTS=OFF \
        -DLLVM_CCACHE_BUILD=ON \
        -DLLVM_CCACHE_DIR=/tmp/ccache
ninja -C host-llvm-build
export PATH=$PWD/host-llvm-build/bin:$PATH

# build binaryen for host
git clone https://github.com/WebAssembly/binaryen
cmake -G Ninja -S binaryen -B binaryen-build \
        -DCMAKE_C_COMPILER=clang \
        -DCMAKE_CXX_COMPILER=clang++ \
        -DBUILD_TESTS=OFF
ninja -C binaryen-build
export PATH=$PWD/binaryen-build/bin:$PATH

# install emscripten
git clone https://github.com/AlistairKeiller/emscripten
cd emscripten
npm i
export PATH=$PWD:$PATH
cd ..
emcc --generate-config

# build sysroot
git clone https://github.com/WebAssembly/wasi-libc
cd wasi-libc
make
cd ..

sed -i '5i set_target_properties(clang PROPERTIES LINK_FLAGS --preload-file=wasi-libc/sysroot)' llvm-project/clang/tools/CMakeLists.txt

# build wasm llvm
emcmake cmake -G Ninja -S llvm-project/llvm -B web-llvm-build \
        -DCMAKE_BUILD_TYPE=MinSizeRel \
        -DLLVM_ENABLE_PROJECTS="clang" \
        -DLLVM_TARGETS_TO_BUILD=WebAssembly \
        -DLLVM_TABLEGEN=$PWD/host-llvm-build/bin/llvm-tblgen \
        -DCLANG_TABLEGEN=$PWD/host-llvm-build/bin/clang-tblgen \
        -DLLVM_PARALLEL_LINK_JOBS=1 \
        -DLLVM_INCLUDE_BENCHMARKS=OFF \
        -DLLVM_INCLUDE_EXAMPLES=OFF \
        -DLLVM_INCLUDE_TESTS=OFF \
        -DCMAKE_CXX_FLAGS='-Dwait4=__syscall_wait4 -sEXPORTED_RUNTIME_METHODS=FS,callMain -sALLOW_MEMORY_GROWTH -sEXPORT_ES6 -sMODULARIZE' \
        -DLLVM_CCACHE_BUILD=ON \
        -DLLVM_CCACHE_DIR=/tmp/ccache
ninja -C web-llvm-build -- clang
