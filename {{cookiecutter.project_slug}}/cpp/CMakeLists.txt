# {{ cookiecutter.project_name }}
# {{ cookiecutter.description }}
# Copyright {{ cookiecutter.year }}, {{ cookiecutter.author }}

cmake_minimum_required(VERSION 3.1)
project({{ cookiecutter.project_slug }} VERSION {{ cookiecutter.version }} LANGUAGES C CXX)
set(PROJECT_DESCRIPTION   "{{ cookiecutter.description }}")
set(PROJECT_AUTHOR        "{{ cookiecutter.author }}")
set(PROJECT_URL           "https://{{ cookiecutter.git_server }}/{{ cookiecutter.username }}/{{ cookiecutter.project_slug }}")


# ------------------------------------------------------------------------------
# Add external cmake modules to project.
# Add find_<package_name> files to cmake-modules directory.
# ------------------------------------------------------------------------------

# Make sure that our modules are captured first.
list(INSERT CMAKE_MODULE_PATH 0 ${CMAKE_SOURCE_DIR}/cmake)

# Installing conan dependencies
if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
   message(STATUS "Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
   file(DOWNLOAD "https://raw.githubusercontent.com/conan-io/cmake-conan/v0.13/conan.cmake"
                 "${CMAKE_BINARY_DIR}/conan.cmake")
endif()

include(${CMAKE_BINARY_DIR}/conan.cmake)

conan_cmake_run(CONANFILE conanfile.txt  # or relative build/conanfile.txt
                BASIC_SETUP CMAKE_TARGETS
                BUILD missing)


# Project directory structure for install
include(CheckCXXCompilerFlag) # TODO: use new way
include(GNUInstallDirs)


include(CMakePackageConfigHelpers) # TODO:


# Build flags
set (CMAKE_CXX_STANDARD {{ cookiecutter.cpp_standard }}) # one of { 03, 11, 14 }
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Don't use non standard compiler extensions, for portability
set(CMAKE_CXX_EXTENSIONS OFF)

# Enable only coverage in Debug mode
if (CMAKE_BUILD_TYPE STREQUAL "Debug")
  include(CodeCoverage)
  append_coverage_compiler_flags()
endif()

# ------------------------------------------------------------------------------
# Setup Compiler Flags/Features
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Add project modules here
# ------------------------------------------------------------------------------
add_subdirectory(src/core)
# add_subdirectory(src/module1)


# ------------------------------------------------------------------------------
# Setup tests and checks
# ------------------------------------------------------------------------------

enable_testing()

# Enable only coverage in Debug mode, avoid adding debug symbols for Release mode.
if (CMAKE_BUILD_TYPE STREQUAL "Debug")
  # TODO: check per test coverage or coverage all tests.
  setup_target_for_coverage_gcovr_html(NAME coverage EXECUTABLE core_test )
  # setup_target_for_coverage_gcovr_html(NAME coverage EXECUTABLE module1_test )
endif()

add_subdirectory(test)

add_subdirectory(doc)


# install previously registered targets
install(EXPORT {{ cookiecutter.project_slug }}-targets
  FILE
    {{ cookiecutter.project_slug }}Targets.cmake
  NAMESPACE
    {{ cookiecutter.project_slug }}::
  DESTINATION
    ${CMAKE_INSTALL_LIBDIR}/cmake/{{ cookiecutter.project_slug }}
)



