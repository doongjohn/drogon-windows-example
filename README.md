# Build drogon on windows without conan

drogon: <https://github.com/drogonframework/drogon>
onenssl: <https://kb.firedaemon.com/support/solutions/articles/4000121705#Download-OpenSSL>

```pwsh
mkdir vendor
cd vendor
git clone --depth=1 --recurse-submodules https://github.com/drogonframework/drogon.git
git clone --depth=1 https://github.com/open-source-parsers/jsoncpp.git
git clone --depth=1 https://github.com/madler/zlib.git

cd jsoncpp
cmake -S . -B build
cmake --build build
cd ..

cd zlib
cmake -S . -B build
cmake --build build
cd ..

mkdir openssl
# download openssl 1.1.1u from https://kb.firedaemon.com/support/solutions/articles/4000121705#Download-OpenSSL

cd ..
cmake -S . -B build

cmake --build build -t drogon_ctl
cp vendor/jsoncpp/build/bin/Debug/jsoncpp.dll build/vendor/drogon/drogon_ctl/Debug/
cp vendor/zlib/build/Debug/zlibd.dll build/vendor/drogon/drogon_ctl/Debug/
cp vendor/openssl/x64/bin/libcrypto-1_1-x64.dll build/vendor/drogon/drogon_ctl/Debug/
cp vendor/openssl/x64/bin/libssl-1_1-x64.dll build/vendor/drogon/drogon_ctl/Debug/

cd src/view
..\..\build\vendor\drogon\drogon_ctl\Debug\drogon_ctl.exe create view HelloView.csp

cmake --build build
cp vendor/jsoncpp/build/bin/Debug/jsoncpp.dll build/Debug/
cp vendor/zlib/build/Debug/zlibd.dll build/Debug/
cp vendor/openssl/x64/bin/libcrypto-1_1-x64.dll build/Debug/
cp vendor/openssl/x64/bin/libssl-1_1-x64.dll build/Debug/

.\build\Debug\webserver.exe
```
