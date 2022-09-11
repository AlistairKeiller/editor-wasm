#!/bin/sh

set -e

# install emscripten
git clone https://github.com/emscripten-core/emsdk
cd emsdk
./emsdk install latest
./emsdk activate latest
. ./emsdk_env.sh
cd ..

# download sysroot
wget -qO- https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-16/wasi-sysroot-16.0.tar.gz | tar -xz
wget -qO- https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-16/libclang_rt.builtins-wasm32-wasi-16.0.tar.gz | tar -xz

# build llvm
git clone https://github.com/llvm/llvm-project

echo "set_target_properties(clang PROPERTIES LINK_FLAGS --embed-file=lib/clang/16.0.0/include)
set_target_properties(lld PROPERTIES LINK_FLAGS --embed-file=wlib)" >> llvm-project/llvm/CMakeLists.txt
CXXFLAGS="-Dwait4=__syscall_wait4" \
LDFLAGS='-sEXPORTED_RUNTIME_METHODS=FS,callMain -sEXPORT_ES6 -sMODULARIZE -sALLOW_MEMORY_GROWTH -sINITIAL_MEMORY=64MB -sWASM_BIGINT -sENVIRONMENT=web' \
emcmake cmake -G Ninja -S llvm-project/llvm -B web-llvm-build \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_ENABLE_PROJECTS="clang;lld" \
        -DLLVM_TARGETS_TO_BUILD=WebAssembly \
        -DLLVM_DEFAULT_TARGET_TRIPLE=wasm32-wasi \
        -DLLVM_TARGET_ARCH=wasm32-emscripten \
        -DLLVM_PARALLEL_LINK_JOBS=1 \
        -DLLVM_INCLUDE_BENCHMARKS=OFF \
        -DLLVM_INCLUDE_EXAMPLES=OFF \
        -DLLVM_INCLUDE_TESTS=OFF \
        -DLLVM_ENABLE_THREADS=OFF \
        -DLLVM_CCACHE_BUILD=ON \
        -DLLVM_CCACHE_DIR=/tmp/ccache

mkdir -p web-llvm-build/lib/clang/16.0.0
cp -r wasi-sysroot/include web-llvm-build/lib/clang/16.0.0/include
cp -r wasi-sysroot/lib/wasm32-wasi web-llvm-build/wlib
cp lib/wasi/libclang_rt.builtins-wasm32.a web-llvm-build/wlib/libclang_rt.builtins-wasm32.a

ninja -C web-llvm-build -- clang lld
