# {{ cookiecutter.project_name }}
# {{ cookiecutter.description }}
# Copyright {{ cookiecutter.year }}, {{ cookiecutter.author }}

cmake_minimum_required(VERSION 3.12)
project({{ cookiecutter.project_slug }} VERSION {{ cookiecutter.version }} LANGUAGES C CXX)
set(PROJECT_DESCRIPTION "{{ cookiecutter.description }}")
set(PROJECT_AUTHOR      "{{ cookiecutter.author }}")
set(PROJECT_URL         "https://{{ cookiecutter.git_server }}/{{ cookiecutter.username }}/{{ cookiecutter.project_slug }}")
set(PROJECT_NAMESPACE   "{{ cookiecutter.project_namespace }}")

option(BUILD_STATIC "Build static libraries." OFF)

option(BUILD_PYTHON_PYBIND11 "Build pybind11 python bindings." ON)
option(BUILD_PYTHON_SWIG "Build pybind11 python bindings." OFF)

option(BUILD_DOC "Build code documentation using Doxygen." OFF)
option(BUILD_TESTS "Build project tests" ON)

# INSTALL_FOR_PYPI means that the libs go under the package
option(INSTALL_FOR_PYPI "Install libraries and python bindings inside the python package." OFF)

# ------------------------------------------------------------------------------
# Add external cmake modules to project.
# Add find_<package_name> files to cmake-modules directory.
# ------------------------------------------------------------------------------

# Make sure that our modules are captured first.
list(INSERT CMAKE_MODULE_PATH 0 ${CMAKE_SOURCE_DIR}/cmake)

include(GNUInstallDirs)


string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)
set(PROJECT_PREFIX ${PROJECT_NAMESPACE}/${PROJECT_NAME})
set(PROJECT_INCLUDEDIR ${PROJECT_SOURCE_DIR}/include/${PROJECT_PREFIX})


set(PROJECT_TEST_TARGET test_${PROJECT_NAME})


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

  # multi value options, see https://stackoverflow.com/a/47612735/3978614


  find_package(Python REQUIRED COMPONENTS Interpreter Development)
  # Python_STDLIB # Standard platform independent installation directory.
  # Python_STDARCH # Standard platform dependent installation directory.
  # Python_SITELIB # Third-party platform independent installation directory.
  # Python_SITEARCH # Third-party platform dependent installation directory. 

  # conda environment python
  # Python_STDLIB: $CONDA_PREFIX/lib/python3.6
  # Python_STDARCH: $CONDA_PREFIX/lib/python3.6
  # Python_SITELIB: $CONDA_PREFIX/lib/python3.6/site-packages
  # Python_SITEARCH: $CONDA_PREFIX/lib/python3.6/site-packages

  # ubuntu 16.04 system python
  # Python_STDLIB: /usr/lib/python3.5
  # Python_STDARCH: /usr/lib/python3.5
  # Python_SITELIB: /usr/lib/python3/dist-packages
  # Python_SITEARCH: /usr/lib/python3/dist-packages

  # compute the python instalation prefix.
  if(Python_FOUND)
    if(NOT CMAKE_INSTALL_PYTHON_STDLIB)
      string(REGEX MATCH "python([0-9]|\.)+.*$" CMAKE_INSTALL_PYTHON_STDLIB ${Python_STDLIB})
      message("CMAKE_INSTALL_PYTHON_STDLIB: ${CMAKE_INSTALL_PYTHON_STDLIB}")
    endif()

    if(NOT CMAKE_INSTALL_PYTHON_STDARCH)
      string(REGEX MATCH "python([0-9]|\.)+.*$" CMAKE_INSTALL_PYTHON_STDARCH ${Python_STDARCH})
      message("CMAKE_INSTALL_PYTHON_STDARCH: ${CMAKE_INSTALL_PYTHON_STDARCH}")
    endif()

    if(NOT CMAKE_INSTALL_PYTHON_SITELIB)
      string(REGEX MATCH "python([0-9]|\.)+.*$" CMAKE_INSTALL_PYTHON_SITELIB ${Python_SITELIB})
      message("CMAKE_INSTALL_PYTHON_SITELIB: ${CMAKE_INSTALL_PYTHON_SITELIB}")
    endif()

    if(NOT CMAKE_INSTALL_PYTHON_SITEARCH)
      string(REGEX MATCH "python([0-9]|\.)+.*$" CMAKE_INSTALL_PYTHON_SITEARCH ${Python_SITEARCH})
      message("CMAKE_INSTALL_PYTHON_SITEARCH: ${CMAKE_INSTALL_PYTHON_SITEARCH}")
    endif()
  endif()

  # default setup of the project instalation folders
  set(PROJECT_INSTALL_INCLUDEDIR ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_PREFIX})
  set(PROJECT_INSTALL_LIBDIR ${CMAKE_INSTALL_LIBDIR}/${PROJECT_PREFIX})
  set(PROJECT_INSTALL_PYTHON_SITEARCH ${CMAKE_INSTALL_LIBDIR}/${CMAKE_INSTALL_PYTHON_SITEARCH}/${PROJECT_PREFIX})

  if(INSTALL_FOR_PYPI)
    # if Pypi, then python packages go under 
    # <package_name>
    # and libs go under 
    # <package_name>/lib

    if(SKBUILD) # build by python integrating with scikit-build
      set(PROJECT_INSTALL_PYTHON_SITEARCH ${PROJECT_PREFIX})
    else() # install in current python environment
      set(PROJECT_INSTALL_PYTHON_SITEARCH ${CMAKE_INSTALL_PYTHON_SITEARCH}/${PROJECT_PREFIX})
    endif()

    set(PROJECT_INSTALL_LIBDIR ${PROJECT_INSTALL_PYTHON_SITEARCH}/${CMAKE_INSTALL_LIBDIR}/${PROJECT_PREFIX})
  endif()

  message("PROJECT_INSTALL_PYTHON_PACKAGE_MODE:${PROJECT_INSTALL_PYTHON_PACKAGE_MODE}")
  message("PROJECT_INSTALL_PYTHON_SITEARCH:${PROJECT_INSTALL_PYTHON_SITEARCH}")
  message("PROJECT_INSTALL_LIBDIR:${PROJECT_INSTALL_LIBDIR}")

  if (BUILD_PYTHON_PYBIND11)
    find_package(pybind11 REQUIRED)

    add_library(python_pybind11 INTERFACE)
  endif()

  if(BUILD_PYTHON_SWIG)
    find_package(Swig REQUIRED)
  endif()
endif()

# Enable only coverage in Debug mode and tests are enabled
if (CMAKE_BUILD_TYPE STREQUAL "Debug" AND BUILD_TESTS)
  include(CodeCoverage)
  append_coverage_compiler_flags()
endif()


# ------------------------------------------------------------------------------
# Setup Compiler Flags/Features
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Add project modules here
# ------------------------------------------------------------------------------

# functions to add modules and just invoking a function
include(PracticalCIProject)

add_subdirectory(src/cpp/core)


# ------------------------------------------------------------------------------
# Setup tests and checks
# ------------------------------------------------------------------------------

if(BUILD_TESTS)
 
  find_package(Catch2 2.6 REQUIRED)

  enable_testing()

  # Enable only coverage in Debug mode, avoid adding debug symbols for Release mode.
  if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    # TODO: check per test coverage or coverage all tests.
    setup_target_for_coverage_gcovr_html(NAME coverage EXECUTABLE ${PROJECT_TEST_TARGET})
    # setup_target_for_coverage_gcovr_html(NAME coverage EXECUTABLE module1_test )
  endif()


  # Add here additional source files
  add_executable(${PROJECT_TEST_TARGET} 
    ${CMAKE_CURRENT_SOURCE_DIR}/tests/cpp/${PROJECT_TEST_TARGET}.cpp
  )

  # make sure you execute "conan install .." in the build directory
  target_link_libraries(${PROJECT_TEST_TARGET} PRIVATE Catch2::Catch2)

  # Register the tests
  # TODO: check about registering test names to filter the tests
  # check CTest
  # add_test(NAME ${PROJECT_NAME}_test COMMAND ${PROJECT_NAME}_test)

  # there is no way for ctest to display test output on failure from whithim cmake
  # so add this custom command.
  # SEE: 
  # https://stackoverflow.com/a/36729074/3978614
  # https://stackoverflow.com/a/31124523/3978614
  add_custom_target(check_tests 
      ${CMAKE_COMMAND} -E echo CWD=${CMAKE_BINARY_DIR}
      COMMAND ${CMAKE_COMMAND} -E echo CMD=${CMAKE_CTEST_COMMAND} -C $<CONFIG>
      COMMAND ${CMAKE_COMMAND} -E echo ----------------------------------
      COMMAND ${CMAKE_COMMAND} -E env CTEST_OUTPUT_ON_FAILURE=1
          ${CMAKE_CTEST_COMMAND} -C $<CONFIG> 
          WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
          DEPENDS ${PROJECT_TEST_TARGET}
  )

  # ----------------------------------------------------------------------------
  # Add project module tests
  # ----------------------------------------------------------------------------
  
  add_subdirectory(tests/cpp/core)

  include(ParseAndAddCatchTests)
  ParseAndAddCatchTests(${PROJECT_TEST_TARGET})
 
endif()

if(BUILD_DOC AND NOT INSTALL_FOR_PYPI)
  add_subdirectory(doc)
endif()

if(NOT INSTALL_FOR_PYPI)
  # install targets cmake file, previously registered targets in each module.
  install(EXPORT ${PROJECT_NAME}-targets
    FILE
      ${PROJECT_NAME}Targets.cmake
    NAMESPACE
      ${PROJECT_NAMESPACE}_${PROJECT_NAME}::
    DESTINATION
      ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAMESPACE}
    COMPONENT dev
  )


  # TODO: Install component targets, needs to be executed after the cmake build
  add_custom_target(install-lib
  #    DEPENDS # TODO: add interface libraries for targets ?
    COMMAND 
      "${CMAKE_COMMAND}" -DCMAKE_INSTALL_COMPONENT=lib
      -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
    WORKING_DIRECTORY
      ${CMAKE_BINARY_DIR}
  )

  add_custom_target(install-dev
  #    DEPENDS docs # TODO: add interface libraries for targets ?
    COMMAND 
      "${CMAKE_COMMAND}" -DCMAKE_INSTALL_COMPONENT=dev
      -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
    WORKING_DIRECTORY
      ${CMAKE_BINARY_DIR}
  )
  add_custom_target(install-python
  #    DEPENDS # TODO: add interface libraries for targets ?
    COMMAND 
      "${CMAKE_COMMAND}" -DCMAKE_INSTALL_COMPONENT=python
      -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
    WORKING_DIRECTORY
      ${CMAKE_BINARY_DIR}
  )
endif()
