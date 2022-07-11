FROM emscripten/emsdk:latest

RUN apt update && apt install -y docker.io clang ninja-build