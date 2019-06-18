cmake_minimum_required(VERSION 3.12)

project(test-rock)

find_package(rock 1.0.0 REQUIRED)

add_library(test-rock test.cpp)

target_link_librarieso(test-rock org-rock::core)

# use cmake .. -DCMAKE_PREFIX_PATH=$(pwd)/../../rock/build/install/lib/cmake/org/
