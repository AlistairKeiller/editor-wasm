#!/bin/bash
set -e

git clone https://github.com/jprendes/emception
cd emception
bash build-with-docker.sh
