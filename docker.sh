#!/bin/bash
set -e

chmod +x build.sh

docker run \
    --rm \
    -v $(pwd):$(pwd) \
    emscripten/emsdk:latest \
    bash -c "cd $(pwd) && ./build.sh"