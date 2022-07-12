#!/bin/bash
chmod +x $SRC/build.sh

docker run \
    --rm \
    -v $(pwd):$(pwd) \
    emscripten/emsdk:latest \
    bash -c "cd $(pwd) && ./build.sh"