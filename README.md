# Build drogon on windows without conan

- drogon (HTTP web application framework): <https://github.com/drogonframework/drogon>

```powershell
# download openssl 1.1.1
pwsh .\download-openssl.ps1

# download and build vendor libraries
.\vendor-clone.cmd
.\vendor-build-msvc.cmd

# build the project
cmake -S . -B build
cmake --build build

# run the web server
.\build\Debug\webserver.exe

# open localhost:8848
```
