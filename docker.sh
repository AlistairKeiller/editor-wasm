#!/bin/bash

docker run --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $(pwd):$(pwd) \
    -v $(pwd)/build/emsdk_cache:/emsdk/upstream/emscripten/cache \
    $(id -G | tr ' ' '\n' | xargs -I{} echo --group-add {}) \
    emscripten/emsdk:latest \
    bash -c "cd $(pwd) && ./build.sh"