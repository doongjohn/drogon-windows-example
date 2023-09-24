@echo off

cd vendor

cd jsoncpp
cmake -S . -B build
cmake --build build
cd ..

cd zlib
cmake -S . -B build
cmake --build build
cd ..
