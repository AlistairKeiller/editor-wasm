FROM emscripten/emsdk:latest

RUN apt update && apt install -y docker.io clang-12 ninja-build jq brotliRUN apt update && apt install -y docker.io clang-12 ninja-build jq brotli

RUN ls /usr/bin/ | grep "\-12" | sed -E 's/(.*)-12/\1/' | xargs -I{} ln -s /usr/bin/{}-12 /usr/bin/{}

RUN mkdir -p /.npm && chmod a+rwx /.npm