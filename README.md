# Build drogon on windows without conan

- drogon (HTTP web application framework): <https://github.com/drogonframework/drogon>

```powershell
# download and build vendor libraries
.\vendor-clone.cmd
.\vendor-build.cmd

# download openssl 1.1.1
pwsh .\download-openssl.ps1

# build the project
cmake -S . -B build
cmake --build build

# run web server
.\build\Debug\webserver.exe
# open localhost:8848
```
