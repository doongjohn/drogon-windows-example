@echo off

cd vendor

cd drogon
git pull --recurse-submodules
cd ..

cd jsoncpp
git pull
cd ..

cd zlib
git pull
cd ..
