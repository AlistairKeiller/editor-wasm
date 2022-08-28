#!/bin/sh

set -e

# install dependencies
sudo apt-get install -y ninja-build ccache

# install emscripten
git clone https://github.com/emscripten-core/emsdk
cd emsdk
./emsdk install 3.1.19
./emsdk activate 3.1.19
. ./emsdk_env.sh
cd ..

# download sysroot
wget -qO- https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-16/wasi-sysroot-16.0.tar.gz | tar -xz

# download older version of cmake for emscripten compatibility ( should remove in emscripten 3.1.21 )
wget -qO- https://github.com/Kitware/CMake/releases/download/v3.23.3/cmake-3.23.3-linux-x86_64.tar.gz | tar -xz

# build llvm
git clone https://github.com/llvm/llvm-project
echo 'set_target_properties(clang PROPERTIES LINK_FLAGS --embed-file=lib/clang)' >> llvm-project/llvm/CMakeLists.txt
# CXX_FLAGS='-Dwait4=__syscall_wait4' \
LDFLAGS='-sEXPORTED_RUNTIME_METHODS=FS,callMain -sALLOW_MEMORY_GROWTH -sEXPORT_ES6 -sMODULARIZE -sINITIAL_MEMORY=32MB -sWASM_BIGINT -sWASMFS -sENVIRONMENT=web --closure 1' \
emcmake ./cmake-3.23.3-linux-x86_64/bin/cmake -G Ninja -S llvm-project/llvm -B web-llvm-build \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_ENABLE_PROJECTS="clang;lld" \
        -DLLVM_TARGETS_TO_BUILD=WebAssembly \
        -DLLVM_DEFAULT_TARGET_TRIPLE=wasm32-wasi \
        -DLLVM_TARGET_ARCH=wasm32-emscripten \
        -DLLVM_PARALLEL_LINK_JOBS=1 \
        -DLLVM_INCLUDE_BENCHMARKS=OFF \
        -DLLVM_INCLUDE_EXAMPLES=OFF \
        -DLLVM_INCLUDE_TESTS=OFF \
        -DLLVM_CCACHE_BUILD=ON \
        -DLLVM_CCACHE_DIR=/tmp/ccache
mkdir -p web-llvm-build/lib/clang
mv wasi-sysroot web-llvm-build/lib/clang/wasi
ninja -C web-llvm-build -- clang lld
