@echo off

mkdir vendor
cd vendor
git clone --depth=1 --recurse-submodules https://github.com/drogonframework/drogon.git
git clone --depth=1 https://github.com/open-source-parsers/jsoncpp.git
git clone --depth=1 https://github.com/madler/zlib.git
cd ..
