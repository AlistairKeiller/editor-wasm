FROM emscripten/emsdk:latest

RUN apt update && apt install -y clang ninja-build