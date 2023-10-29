@echo off

cd vendor

cd jsoncpp
cmake -S . -B build -G "Ninja Multi-Config" -DCMAKE_GNUtoMS=ON
cmake --build build
cd ..

cd zlib
cmake -S . -B build -G "Ninja Multi-Config" -DCMAKE_GNUtoMS=ON
cmake --build build
cd ..
