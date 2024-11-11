cmake_minimum_required(VERSION 3.29.20240416 FATAL_ERROR)

set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "0e5b6991-d74f-4b3d-a41c-cf096e0b2508")

project(import_std LANGUAGES CXX)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_MODULE_STD 1)

add_executable(main)
target_compile_features(main PRIVATE cxx_std_23)
target_sources(main PRIVATE main.cc)