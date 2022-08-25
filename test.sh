#!/bin/sh

set -e

# install dependencies
sudo apt-get install -y ninja-build ccache llvm

# install emscripten
git clone https://github.com/emscripten-core/emsdk
cd emsdk
./emsdk install latest
./emsdk activate latest
. ./emsdk_env.sh
cd ..

# build sysroot
git clone https://github.com/WebAssembly/wasi-libc
cd wasi-libc
make
cd ..

# download older version of cmake for emscripten compatibility
wget -qO- https://github.com/Kitware/CMake/releases/download/v3.23.3/cmake-3.23.3-linux-x86_64.tar.gz | tar -xz

# build llvm
git clone https://github.com/llvm/llvm-project
echo 'set_target_properties(clang PROPERTIES LINK_FLAGS --embed-file=lib/clang)' >> llvm-project/llvm/CMakeLists.txt
emcmake ./cmake-3.23.3-linux-x86_64/bin/cmake -G Ninja -S llvm-project/llvm -B web-llvm-build \
        -DCMAKE_BUILD_TYPE=MinSizeRel \
        -DLLVM_ENABLE_PROJECTS="clang" \
        -DLLVM_TARGETS_TO_BUILD=WebAssembly \
        -DLLVM_PARALLEL_LINK_JOBS=1 \
        -DLLVM_INCLUDE_BENCHMARKS=OFF \
        -DLLVM_INCLUDE_EXAMPLES=OFF \
        -DLLVM_INCLUDE_TESTS=OFF \
        -DLLVM_CCACHE_BUILD=ON \
        -DLLVM_CCACHE_DIR=/tmp/ccache \
        -DCMAKE_CXX_FLAGS='-Dwait4=__syscall_wait4 -sEXPORTED_RUNTIME_METHODS=FS,callMain -sALLOW_MEMORY_GROWTH -sEXPORT_ES6 -sMODULARIZE -sINITIAL_MEMORY=32MB'
mv wasi-libc/sysroot web-llvm-build/lib/clang
ninja -C web-llvm-build -- clang
