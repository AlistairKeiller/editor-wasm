#!/bin/bash
set -e

docker build -t emception_build .

chmod +x build.sh

docker run \
    --rm \
    -v $(pwd):$(pwd) \
    emception_build:latest \
    bash -c "cd $(pwd) && ./build.sh"