@echo off

cd vendor

cd jsoncpp
rd /s /Q build
cd ..

cd zlib
rd /s /Q build
cd ..
