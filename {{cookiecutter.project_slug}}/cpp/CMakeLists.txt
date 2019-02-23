# {{ cookiecutter.project_name }}
# {{ cookiecutter.description }}
# Copyright {{ cookiecutter.year }}, {{ cookiecutter.author }}

cmake_minimum_required(VERSION 3.12)
project({{ cookiecutter.project_slug }} VERSION {{ cookiecutter.version }} LANGUAGES C CXX)
set(PROJECT_DESCRIPTION   "{{ cookiecutter.description }}")
set(PROJECT_AUTHOR        "{{ cookiecutter.author }}")
set(PROJECT_URL           "https://{{ cookiecutter.git_server }}/{{ cookiecutter.username }}/{{ cookiecutter.project_slug }}")


option(BUILD_STATIC "Build static libraries." OFF)

option(BUILD_PYTHON_PYBIND11 "Build pybind11 python bindings." ON)
option(BUILD_PYTHON_SWIG "Build pybind11 python bindings." OFF)

option(BUILD_DOC "Build code documentation using Doxygen." OFF)
option(BUILD_TESTS "Build project tests" ON) # TODO

include(GNUInstallDirs)

string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)
set(PROJECT_INCLUDEDIR ${PROJECT_SOURCE_DIR}/include/${PROJECT_NAME})
set(PROJECT_INSTALL_LIBDIR ${CMAKE_INSTALL_LIBDIR}/${PROJECT_NAME})
set(PROJECT_INSTALL_INCLUDEDIR ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME})

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


include(CheckCXXCompilerFlag) # TODO: use new way
include(CMakePackageConfigHelpers) # TODO:


# Build flags
set (CMAKE_CXX_STANDARD {{ cookiecutter.cpp_standard }}) # one of { 98, 11, 14 }
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Don't use non standard compiler extensions, for portability
set(CMAKE_CXX_EXTENSIONS OFF)

# add target for all modules of the project.
# NOTE: add target_link_libraries(${PROJECCT_NAME} <module name>) in each
# module CMakeLists.
add_library(${PROJECT_NAME} INTERFACE)

if(BUILD_PYTHON_PYBIND11 OR BUILD_PYTHON_SWIG)
  if(SKBUILD) # building with scikit-build
    set(PYTHON_SITE_PACKAGES "")
    message("Building for scikit-build.")
  elseif(NOT PYTHON_SITE_PACKAGES) # if not defined at build time, find it now
    # https://cmake.org/cmake/help/v3.12/module/FindPython.html#module:FindPython
    find_package(Python REQUIRED COMPONENTS Interpreter Development)

    # Python_STDLIB # lib/python3.6 # Standard platform independent installation directory.
    # Python_STDARCH # lib/python3.6 # Standard platform dependent installation directory.
    # Python_SITELIB # lib/python3.6/site-packages # Third-party platform independent installation directory.
    # Python_SITEARCH # lib/python3.6/site-packages # Third-party platform dependent installation directory. 

    if(Python_SITEARCH)
      set(PYTHON_SITE_PACKAGES ${Python_SITEARCH})
    else()
      message(WARNING 
        "Could not detect Python packages installation directory and none was defined."
      )
    endif()
  endif()

  if(PYTHON_SITE_PACKAGES)
    set(PROJECT_PYTHON_PACKAGE_INSTALL_DIR ${PYTHON_SITE_PACKAGES}/${PROJECT_NAME})
  else()
    set(PROJECT_PYTHON_PACKAGE_INSTALL_DIR ${PROJECT_NAME})
  endif()

  if (BUILD_PYTHON_PYBIND11)
    find_package(pybind11 REQUIRED)

    add_library(python_pybind11 INTERFACE)
  endif()

  if(BUILD_PYTHON_SWIG)
    find_package(Swig REQUIRED)
    
  endif()
endif()

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


# install targets cmake file, previously registered targets in each module.
install(EXPORT {{ cookiecutter.project_slug }}-targets
  FILE
    {{ cookiecutter.project_slug }}Targets.cmake
  NAMESPACE
    {{ cookiecutter.project_slug }}::
  DESTINATION
    ${CMAKE_INSTALL_LIBDIR}/cmake/{{ cookiecutter.project_slug }}
)



