#!/bin/bash

docker build \
    -t emception_build \
    .

docker run \
    --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $(pwd):$(pwd) \
    -v $(pwd)/build/emsdk_cache:/emsdk/upstream/emscripten/cache \
    -u $(id -u):$(id -g) \
    $(id -G | tr ' ' '\n' | xargs -I{} echo --group-add {}) \
    emception_build:latest \
    bash -c "cd $(pwd) && ./build-llvm.sh"