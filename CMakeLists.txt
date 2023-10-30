cmake_minimum_required(VERSION 3.27)

if (NOT WIN32)
  message(FATAL_ERROR "This project only works on windows!")
endif()

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_COLOR_DIAGNOSTICS ON)
set(CMAKE_GNUtoMS ON) # this is for mingw

project(
  WindowsDrogonWebServer
  VERSION 0.1.0
  DESCRIPTION ""
  HOMEPAGE_URL ""
  LANGUAGES CXX
)

# set openssl path
set(OPENSSL_ROOT_DIR "${PROJECT_SOURCE_DIR}/vendor/openssl-1.1/x64")

# library paths for the `find_package()`
list(APPEND CMAKE_PREFIX_PATH
  "${PROJECT_SOURCE_DIR}/vendor/jsoncpp"
  "${PROJECT_SOURCE_DIR}/vendor/jsoncpp/build/lib/Debug"
  "${PROJECT_SOURCE_DIR}/vendor/jsoncpp/build/lib/Release"
  "${PROJECT_SOURCE_DIR}/vendor/jsoncpp/build/lib/RelWithDebInfo"
  "${PROJECT_SOURCE_DIR}/vendor/jsoncpp/build/lib/MinSizeRel")
list(APPEND CMAKE_PREFIX_PATH
  "${PROJECT_SOURCE_DIR}/vendor/zlib"
  "${PROJECT_SOURCE_DIR}/vendor/zlib/build/Debug"
  "${PROJECT_SOURCE_DIR}/vendor/zlib/build/Release"
  "${PROJECT_SOURCE_DIR}/vendor/zlib/build/RelWithDebInfo"
  "${PROJECT_SOURCE_DIR}/vendor/zlib/build/MinSizeRel")

set(BUILD_EXAMPLES OFF CACHE BOOL "" FORCE) # don't build examples
include_directories("${PROJECT_SOURCE_DIR}/vendor/zlib/build") # this is for zconf.h
add_subdirectory(vendor/drogon)

add_executable(webserver "")

set_target_properties(webserver
  PROPERTIES
  OUTPUT_NAME webserver)

target_compile_features(webserver
  PRIVATE cxx_std_20)

file(GLOB SOURCES
  src/*.cpp
  src/*.hpp
  src/controller/*.cpp
  src/controller/*.hpp)

# generate c++ files from src/views/*.csp files
file(GLOB CSP_FILES src/views/*.csp)
foreach(csp_file ${CSP_FILES})
  get_filename_component(classname ${csp_file} NAME_WE)
  message(STATUS "[drogon_ctl] processing csp file: ${csp_file}")
  add_custom_command(
    OUTPUT
      views/${classname}.h
      views/${classname}.cc
    COMMAND $<TARGET_FILE:_drogon_ctl> ARGS create view ${csp_file} -o ./views
    DEPENDS ${csp_file}
    VERBATIM)
  message(STATUS "[drogon_ctl] generated: ${CMAKE_BINARY_DIR}/views/${classname}.cc ${CMAKE_BINARY_DIR}/views/${classname}.h")
  list(APPEND CSP_GEN_SOURCES views/${classname}.cc)
endforeach()

target_sources(webserver
  PRIVATE ${SOURCES} ${CSP_GEN_SOURCES})

target_link_libraries(webserver
  drogon)

if (CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
  target_compile_options(webserver
    PRIVATE
      # more warnings
      -Wall -Wextra)

elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
  # for parallel build: https://stackoverflow.com/a/70102570
  target_compile_options(webserver
    PRIVATE
      # more warnings
      /Wall /sdl)

  # target_link_options(webserver
  #   PRIVATE
  #     /VERBOSE)
endif()

add_custom_target(vendor_drogon_ctl)
add_dependencies(vendor_drogon_ctl drogon_ctl)
add_dependencies(webserver vendor_drogon_ctl)

if (CMAKE_CXX_COMPILER_ID MATCHES "GNU")
  add_custom_command(TARGET webserver POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${PROJECT_SOURCE_DIR}/vendor/jsoncpp/build/bin/$<CONFIGURATION>/libjsoncpp.dll"
    "${PROJECT_SOURCE_DIR}/vendor/zlib/build/$<CONFIGURATION>/libzlib.dll"
    "${PROJECT_SOURCE_DIR}/vendor/openssl-1.1/x64/bin/libcrypto-1_1-x64.dll"
    "${PROJECT_SOURCE_DIR}/vendor/openssl-1.1/x64/bin/libssl-1_1-x64.dll"
    $<TARGET_FILE_DIR:webserver>)

  add_custom_command(TARGET vendor_drogon_ctl POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${PROJECT_SOURCE_DIR}/vendor/jsoncpp/build/bin/$<CONFIGURATION>/libjsoncpp.dll"
    "${PROJECT_SOURCE_DIR}/vendor/zlib/build/$<CONFIGURATION>/libzlib.dll"
    "${PROJECT_SOURCE_DIR}/vendor/openssl-1.1/x64/bin/libcrypto-1_1-x64.dll"
    "${PROJECT_SOURCE_DIR}/vendor/openssl-1.1/x64/bin/libssl-1_1-x64.dll"
    $<TARGET_FILE_DIR:drogon_ctl>)

elseif (CMAKE_CXX_COMPILER_ID MATCHES "MSVC|Clang")
  add_custom_command(TARGET webserver POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${PROJECT_SOURCE_DIR}/vendor/jsoncpp/build/bin/$<CONFIGURATION>/jsoncpp.dll"
    "${PROJECT_SOURCE_DIR}/vendor/zlib/build/$<CONFIGURATION>/zlibd.dll"
    "${PROJECT_SOURCE_DIR}/vendor/openssl-1.1/x64/bin/libcrypto-1_1-x64.dll"
    "${PROJECT_SOURCE_DIR}/vendor/openssl-1.1/x64/bin/libssl-1_1-x64.dll"
    $<TARGET_FILE_DIR:webserver>)

  add_custom_command(TARGET vendor_drogon_ctl POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${PROJECT_SOURCE_DIR}/vendor/jsoncpp/build/bin/$<CONFIGURATION>/jsoncpp.dll"
    "${PROJECT_SOURCE_DIR}/vendor/zlib/build/$<CONFIGURATION>/zlibd.dll"
    "${PROJECT_SOURCE_DIR}/vendor/openssl-1.1/x64/bin/libcrypto-1_1-x64.dll"
    "${PROJECT_SOURCE_DIR}/vendor/openssl-1.1/x64/bin/libssl-1_1-x64.dll"
    $<TARGET_FILE_DIR:drogon_ctl>)
endif()
