#!/usr/bin/env sh

mkdir -p out
fpc -O3 -XX -oout/app src/app.pas
