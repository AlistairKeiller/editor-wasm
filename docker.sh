#!/bin/bash

docker run --rm \
    -v $(pwd):$(pwd) \
    emscripten/emsdk:latest \
    bash -c "cd $(pwd) && build.sh"