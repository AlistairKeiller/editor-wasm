#!/bin/bash

docker run --rm \
    emscripten/emsdk:latest \
    bash -c "cd $(pwd) && build.sh"