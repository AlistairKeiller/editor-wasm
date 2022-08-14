#!/bin/bash
# inspired by https://github.com/soedirgo/llvm-wasm

set -e

# build binaryen for host
git clone https://github.com/WebAssembly/binaryen
cmake -G Ninja -S binaryen -B binaryen-build \
        -DBUILD_TESTS=OFF
ninja -C binaryen-build
export PATH=$PWD/binaryen-build/bin:$PATH

# build llvm for host
git clone https://github.com/llvm/llvm-project
cmake -G Ninja -S llvm-project/llvm -B host-llvm-build \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_COMPILER=clang \
        -DCMAKE_CXX_COMPILER=clang++ \
        -DLLVM_USE_LINKER=lld \
        -DLLVM_ENABLE_PROJECTS="lld;clang" \
        -DLLVM_TARGETS_TO_BUILD="host;WebAssembly" \
        -DLLVM_INCLUDE_EXAMPLES=OFF \
        -DLLVM_INCLUDE_TESTS=OFF
ninja -C host-llvm-build
export PATH=$PWD/host-llvm-build/bin:$PATH

# install emscripten
git clone https://github.com/AlistairKeiller/emscripten
export PATH=$PWD/emscripten:$PATH
emcc --generate-config
emcc --check
emcc emscripten/test/hello_world.cpp

# build sysroot
# git clone https://github.com/WebAssembly/wasi-libc
# make CC=/bin/clang \
#      AR=/bin/llvm-ar \
#      NM=/bin/llvm-nm

# set_source_files_properties(foo.cpp PROPERTIES COMPILE_FLAGS -Wno-effc++)

# build wasm llvm
# CXXFLAGS="-Dwait4=__syscall_wait4" \
# LDFLAGS='-sEXPORTED_RUNTIME_METHODS=FS,callMain -sALLOW_MEMORY_GROWTH -sEXPORT_ES6 -sMODULARIZE' \
# emcmake cmake -G Ninja -S llvm-project/llvm -B web-build \
#         -DCMAKE_BUILD_TYPE=MinSizeRel \
#         -DLLVM_TARGETS_TO_BUILD=WebAssembly \
#         -DLLVM_INCLUDE_BENCHMARKS=OFF \
#         -DLLVM_INCLUDE_EXAMPLES=OFF \
#         -DLLVM_INCLUDE_TESTS=OFF \
#         -DLLVM_INCLUDE_TOOLS=OFF \
#         -DLLVM_BUILD_TOOLS=OFF \
#         -DLLVM_TABLEGEN=$PWD/host-llvm-build/bin/llvm-tblgen \
#         -DCLANG_TABLEGEN=$PWD/host-llvm-build/bin/clang-tblgen \
#         -DLLVM_ENABLE_PROJECTS="clang" \
#         -DLLVM_PARALLEL_LINK_JOBS=1

# ninja -C web-build