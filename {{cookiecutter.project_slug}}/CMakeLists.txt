# Project: {{ cookiecutter.project_name }}
# {{ cookiecutter.description }}
# Copyright (c) {% now 'local', '%Y' %}, {% if cookiecutter.organization %}{{ cookiecutter.organization }}{% else %}{{ cookiecutter.author }} <{{ cookiecutter.email.split('@')[0] }} at {{ cookiecutter.email.split('@')[1]|replace('.', ' dot ') }}>{% endif %}

cmake_minimum_required(VERSION 3.12)
project({{ cookiecutter.project_slug }} VERSION {{ cookiecutter.version }} LANGUAGES C CXX)
set(PROJECT_DESCRIPTION "{{ cookiecutter.description }}")
set(PROJECT_AUTHOR      "{{ cookiecutter.author }}")
set(PROJECT_URL         "https://{{ cookiecutter.git_server }}/{{ cookiecutter.username }}/{{ cookiecutter.project_slug }}")
set(PROJECT_NAMESPACE   "{{ cookiecutter.project_namespace }}")
set(PROJECT_PREFIX ${PROJECT_NAMESPACE}/${PROJECT_NAME})
set(PROJECT_PUBLIC_INCLUDEDIR ${PROJECT_SOURCE_DIR}/include/public)
set(PROJECT_PRIVATE_INCLUDEDIR ${PROJECT_SOURCE_DIR}/include/private)
set(PROJECT_OBJECT_LIBRARY_MODULE_LIST "") # TODO: used to link with single project lib ??
set(PROJECT_SHARED_LIBRARY_MODULE_LIST "") # TODO: used to export components for the find_package
set(PROJECT_STATIC_LIBRARY_MODULE_LIST "") # TODO: used to export components for the find_package
set(PROJECT_SHARED_LIBRARY_NAME ${PROJECT_NAME}) # TODO: rename to avoid clash with the project module with same name.
set(PROJECT_STATIC_LIBRARY_NAME ${PROJECT_NAME}-static) # TODO: rename to avoid clash with the project module with same name.

set(PROJECT_TEST_TARGET test_main)
set(PROJECT_TARGETS_EXPORT_NAME "${PROJECT_NAME}Modules")
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)
string(TOUPPER ${PROJECT_NAMESPACE} PROJECT_NAMESPACE_UPPER)

option(BUILD_PYTHON_PYBIND11 "Build pybind11 python bindings." OFF)

option(BUILD_PYTHON_SWIG "Build swig python bindings." OFF)

option(BUILD_DOC "Build code documentation using Doxygen." OFF)
option(BUILD_TESTS "Build project tests" ON)

option(INSTALL_DEVELOPMENT "Install API header files, static libs and cmake export targets." OFF)

option(BUILD_SINGLE_PROJECT_LIB "Compile all the project into a single library" OFF)

if(MSVC)
  option(ENABLE_COVERAGE "Enable coverage for the project." OFF)
else()
  option(ENABLE_COVERAGE "Enable coverage for the project." ON)
endif()

# INSTALL_FOR_PYPI means that the libs go under the package
option(INSTALL_FOR_PYPI "Install libraries and python bindings inside the python package." OFF)

option(ENABLE_STATIC_LINK_PYTHON_MODULES "Python extension modules are static linked with the module library." OFF)

# ------------------------------------------------------------------------------
# Add external cmake modules to project.
# Add find_<package_name> files to cmake-modules directory.
# ------------------------------------------------------------------------------

include(GNUInstallDirs)

set(PROJECT_INSTALL_CMAKE_PACKAGEDIR ${CMAKE_INSTALL_PREFIX}/share/cmake/${PROJECT_NAMESPACE})

# Make sure that our modules are captured first.
list(INSERT CMAKE_MODULE_PATH 0 ${CMAKE_SOURCE_DIR}/cmake)


include(CheckCXXCompilerFlag) # TODO: use new way

include(CMakePackageConfigHelpers)

message("CMAKE_CXX_COMPILE_FEATURES: ${CMAKE_CXX_COMPILE_FEATURES}")

# Build flags
set (CMAKE_CXX_STANDARD {{ cookiecutter.cpp_standard }}) # one of { 98, 11, 14 }
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Don't use non standard compiler extensions, for portability
set(CMAKE_CXX_EXTENSIONS OFF)

# add target for all modules of the project.
# NOTE: add target_link_libraries(${PROJECT_NAME} <module name>) in each
# module CMakeLists.

# default setup of the project instalation folders
set(PROJECT_INSTALL_INCLUDEDIR ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_PREFIX})

message("PROJECT_INSTALL_INCLUDEDIR: ${PROJECT_INSTALL_INCLUDEDIR}")

set(PROJECT_INSTALL_LIBDIR ${CMAKE_INSTALL_LIBDIR}/${PROJECT_PREFIX})

# if building a single library for the project define libraries here
# to link in each module
if(BUILD_SINGLE_PROJECT_LIB)
  add_library(${PROJECT_SHARED_LIBRARY_NAME} SHARED src/null.cpp)
  add_library(${PROJECT_STATIC_LIBRARY_NAME} STATIC src/null.cpp)
endif()

if(BUILD_PYTHON_PYBIND11 OR BUILD_PYTHON_SWIG)

  # multi value options, see https://stackoverflow.com/a/47612735
  # NOTE: if using anaconda python environment, define environment variable
  # Python_ROOT_DIR to match the activated conda environment
  if(DEFINED ENV{CONDA_PREFIX})
    set(ENV{Python_ROOT_DIR} $ENV{CONDA_PREFIX})
  endif()

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

  if(Python_FOUND)
    if(NOT CMAKE_INSTALL_PYTHON_STDLIB)
      set(CMAKE_INSTALL_PYTHON_STDLIB ${Python_STDLIB})
      message("CMAKE_INSTALL_PYTHON_STDLIB: ${CMAKE_INSTALL_PYTHON_STDLIB}")
    endif()

    if(NOT CMAKE_INSTALL_PYTHON_STDARCH)
      set(CMAKE_INSTALL_PYTHON_STDARCH ${Python_STDARCH})
      message("CMAKE_INSTALL_PYTHON_STDARCH: ${CMAKE_INSTALL_PYTHON_STDARCH}")
    endif()

    if(NOT CMAKE_INSTALL_PYTHON_SITELIB)
      set(CMAKE_INSTALL_PYTHON_SITELIB ${Python_SITELIB})
      message("CMAKE_INSTALL_PYTHON_SITELIB: ${CMAKE_INSTALL_PYTHON_SITELIB}")
    endif()

    if(NOT CMAKE_INSTALL_PYTHON_SITEARCH)
      set(REGEX MATCH "python([0-9]|\.)+.*$" CMAKE_INSTALL_PYTHON_SITEARCH ${Python_SITEARCH})
      message("CMAKE_INSTALL_PYTHON_SITEARCH: ${CMAKE_INSTALL_PYTHON_SITEARCH}")
    endif()
  endif()

  set(PROJECT_INSTALL_PYTHON_SITEARCH ${CMAKE_INSTALL_LIBDIR}/${CMAKE_INSTALL_PYTHON_SITEARCH}/${PROJECT_NAMESPACE})

  if(INSTALL_FOR_PYPI)
    # if Pypi, then python packages go under
    # <package_name>
    # and libs go under
    # <package_name>/lib

    if(SKBUILD) # build by python integrating with scikit-build
      set(PROJECT_INSTALL_PYTHON_SITEARCH ${PROJECT_NAMESPACE})
    else() # install in current python environment
      set(PROJECT_INSTALL_PYTHON_SITEARCH ${CMAKE_INSTALL_PYTHON_SITEARCH}/${PROJECT_NAMESPACE})
    endif()

    set(PROJECT_INSTALL_LIBDIR ${PROJECT_INSTALL_PYTHON_SITEARCH}/${CMAKE_INSTALL_LIBDIR}/${PROJECT_PREFIX})
  endif()

  message("PROJECT_INSTALL_PYTHON_SITEARCH:${PROJECT_INSTALL_PYTHON_SITEARCH}")
  message("PROJECT_INSTALL_LIBDIR:${PROJECT_INSTALL_LIBDIR}")

  if (BUILD_PYTHON_PYBIND11)
    find_package(pybind11 REQUIRED)
  endif()

  if(BUILD_PYTHON_SWIG)
    find_package(Swig REQUIRED)
  endif()
endif()

# Enable only coverage in Debug mode and tests are enabled
if (CMAKE_BUILD_TYPE STREQUAL "Debug" AND BUILD_TESTS AND ENABLE_COVERAGE)
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

add_subdirectory(src/cpp/{{ cookiecutter.project_slug }})
add_subdirectory(src/cpp/{{ cookiecutter.project_slug }}/core)

# ------------------------------------------------------------------------------
# Setup tests and checks
# ------------------------------------------------------------------------------

include(static-checks) # add clang format targets.
include(clang-tidy) # add clang format targets.
#include(iwyu) # include what you use checks, this bloats the dev environment
# with all the clang toolchain.

if(BUILD_TESTS)
  find_package(Catch2 2.6 REQUIRED)

  enable_testing()

  # Add here additional source files
  add_executable(${PROJECT_TEST_TARGET}
    ${CMAKE_CURRENT_SOURCE_DIR}/tests/cpp/${PROJECT_TEST_TARGET}.cpp
  )

  # make sure you execute "conan install .." in the build directory
  target_link_libraries(${PROJECT_TEST_TARGET} PRIVATE Catch2::Catch2)

  # Enable only coverage in Debug mode, avoid adding debug symbols for Release mode.
  if (CMAKE_BUILD_TYPE STREQUAL "Debug" AND BUILD_TESTS AND ENABLE_COVERAGE)

      setup_target_for_coverage_gcovr_html(NAME coverage_gcovr_html
        EXECUTABLE $<TARGET_FILE:${PROJECT_TEST_TARGET}>
        DEPENDENCIES ${PROJECT_TEST_TARGET}
      )

      setup_target_for_coverage_gcovr_xml(NAME coverage_gcovr_cobertura_xml
        EXECUTABLE $<TARGET_FILE:${PROJECT_TEST_TARGET}>
        DEPENDENCIES ${PROJECT_TEST_TARGET}
      )

  endif()

  # there is no way for ctest to display test output on failure from whithim cmake
  # so add this custom command.
  # SEE:
  # https://stackoverflow.com/a/36729074
  # https://stackoverflow.com/a/31124523
  add_custom_target(check_tests
    COMMAND ${CMAKE_COMMAND} -E echo CWD=${CMAKE_BINARY_DIR}
    COMMAND ${CMAKE_COMMAND} -E echo CMD=${CMAKE_CTEST_COMMAND} -C $<CONFIG>
    COMMAND ${CMAKE_COMMAND} -E echo ----------------------------------
    COMMAND ${CMAKE_COMMAND} -E env CTEST_OUTPUT_ON_FAILURE=1
      ${CMAKE_CTEST_COMMAND} -C $<CONFIG>
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
      DEPENDS ${PROJECT_TEST_TARGET}
  )

  # Adding test target to report junit xml test results.
  set(PROJECT_TEST_JUNIT_REPORT_TARGET test_junit_report)
  set(PROJECT_TEST_JUNIT_REPORT ${PROJECT_TEST_JUNIT_REPORT_TARGET}.xml)

  add_custom_target(${PROJECT_TEST_JUNIT_REPORT_TARGET}
    COMMAND ${CMAKE_COMMAND} -E echo CWD=${CMAKE_BINARY_DIR}
    COMMAND ${CMAKE_COMMAND} -E echo Creating junit report in: ${CMAKE_BINARY_DIR}/${PROJECT_TEST_JUNIT_REPORT}
    COMMAND ${CMAKE_COMMAND} -E echo ----------------------------------
    COMMAND $<TARGET_FILE:${PROJECT_TEST_TARGET}> -r junit -o ${PROJECT_TEST_JUNIT_REPORT}
    DEPENDS ${PROJECT_TEST_TARGET}
  )

  # catch2 --list-* in the exit code returns the number of elements
  # causing cmake to fail, this hack is to avoid the fail.
  # this feature will be deprecated in catch2
  # see https://github.com/catchorg/Catch2/blob/master/docs/deprecations.md
  if (WIN32)
    set(CUSTOM_COMMAND_SUCCESS "|| exit /b 0")
  elseif(UNIX)
    set(CUSTOM_COMMAND_SUCCESS "|| true")
  else()
    set(CUSTOM_COMMAND_SUCCESS "")
  endif ()

  # list catch2 tests and labels.
  add_custom_target(list_tests
    COMMAND $<TARGET_FILE:${PROJECT_TEST_TARGET}>  ${CUSTOM_COMMAND_SUCCESS} --list-tests
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

if(BUILD_DOC AND INSTALL_DEVELOPMENT)
  add_subdirectory(doc)
endif()

if(INSTALL_DEVELOPMENT)

  write_basic_package_version_file(
      "${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
      VERSION ${PROJECT_VERSION}
      COMPATIBILITY SameMajorVersion
  )

  configure_package_config_file(
    "${PROJECT_SOURCE_DIR}/cmake-package/${PROJECT_NAME}Config.cmake.in"
    "${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
    INSTALL_DESTINATION ${PROJECT_INSTALL_CMAKE_PACKAGEDIR}
  )

  install(FILES "${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
                "${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
    DESTINATION ${PROJECT_INSTALL_CMAKE_PACKAGEDIR}
  )

  install(EXPORT ${PROJECT_NAME}-targets
    FILE
      ${PROJECT_TARGETS_EXPORT_NAME}.cmake
    NAMESPACE
      ${PROJECT_NAMESPACE}-${PROJECT_NAME}::
    DESTINATION
      ${PROJECT_INSTALL_CMAKE_PACKAGEDIR}
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
