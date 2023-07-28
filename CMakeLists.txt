cmake_minimum_required(VERSION 3.27)

# generate `compile_commands.json` (only for make and ninja)
# ln -s build/compile_commands.json compile_commands.json
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

project(
  webserver
  VERSION 0.1.0
  DESCRIPTION ""
  HOMEPAGE_URL ""
  LANGUAGES CXX
)

# OpenSSL: https://kb.firedaemon.com/support/solutions/articles/4000121705#Download-OpenSSL
set(OPENSSL_ROOT_DIR "${PROJECT_SOURCE_DIR}/vendor/openssl/")

# library paths for the `find_package()`
list(APPEND CMAKE_PREFIX_PATH
  "${PROJECT_SOURCE_DIR}/vendor/jsoncpp/"
  "${PROJECT_SOURCE_DIR}/vendor/jsoncpp/build/lib/Debug/"
  "${PROJECT_SOURCE_DIR}/vendor/zlib/"
  "${PROJECT_SOURCE_DIR}/vendor/zlib/build/Debug/")

set(BUILD_EXAMPLES OFF CACHE BOOL "" FORCE) # don't build examples
add_subdirectory(vendor/drogon)

add_executable(webserver "")

set_target_properties(webserver
  PROPERTIES
  OUTPUT_NAME webserver)

target_compile_features(webserver
  PRIVATE cxx_std_20)

file(GLOB SRC_FILES
  src/*.cpp
  src/*.hpp
  src/controller/*.cpp
  src/controller/*.hpp
  src/view/*.cc
  src/view/*.h)
target_sources(webserver
  PRIVATE ${SRC_FILES})

target_link_libraries(webserver
  drogon)

if (CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
  target_compile_options(webserver
    PRIVATE
      # use colored output
      $<$<C_COMPILER_ID:GNU>:-fdiagnostics-color>
      $<$<C_COMPILER_ID:Clang>:-fcolor-diagnostics>
      $<$<CXX_COMPILER_ID:GNU>:-fdiagnostics-color>
      $<$<CXX_COMPILER_ID:Clang>:-fcolor-diagnostics>
      # more warnings
      -Wall -Wextra)

  if (NOT WIN32)
    # use sanitizers
    set(SANITIZER_OPTIONS
      $<$<CONFIG:Debug>:-fno-omit-frame-pointer>
      $<$<CONFIG:Debug>:-fno-sanitize-recover=all>
      $<$<CONFIG:Debug>:-fsanitize=address,undefined>)
    target_compile_options(webserver
      PRIVATE ${SANITIZER_OPTIONS})
    target_link_options(webserver
      PRIVATE ${SANITIZER_OPTIONS})
  endif()
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
  target_compile_options(webserver
    PRIVATE
      # more warnings
      /W4 /sdl)

  # target_link_options(webserver
  #   PRIVATE
  #     /VERBOSE)
endif()
