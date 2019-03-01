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

option(USE_PYTHON_INTEPERTER_SITE_PACKAGES 
  "set PYTHON_SITE_PACKAGES using cmake Python package interperter Python_SITEARCH" ON)

include(GNUInstallDirs)

string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)
set(PROJECT_SUFFIX ${PROJECT_NAMESPACE}/${PROJECT_NAME})
set(PROJECT_INSTALL_INCLUDEDIR ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_SUFFIX})
set(PROJECT_INCLUDEDIR ${PROJECT_SOURCE_DIR}/include/${PROJECT_SUFFIX})

set(PROJECT_INSTALL_LIBDIR ${CMAKE_INSTALL_LIBDIR}/${PROJECT_SUFFIX})

set(PROJECT_TEST_TARGET test_${PROJECT_NAME})

# ------------------------------------------------------------------------------
# Add external cmake modules to project.
# Add find_<package_name> files to cmake-modules directory.
# ------------------------------------------------------------------------------

# Make sure that our modules are captured first.
list(INSERT CMAKE_MODULE_PATH 0 ${CMAKE_SOURCE_DIR}/cmake)


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
  if(USE_PYTHON_INTEPERTER_SITE_PACKAGES) # if not defined at build time, find it now
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

  # TODO: an __init__.py file needs to be installed into ${PROJECT_NAMESPACE}.
  if(PYTHON_SITE_PACKAGES)
    set(PROJECT_PYTHON_PACKAGE_INSTALL_DIR ${PYTHON_SITE_PACKAGES}/${PROJECT_NAMESPACE}/${PROJECT_NAME})
  else()
    set(PROJECT_PYTHON_PACKAGE_INSTALL_DIR ${PROJECT_NAMESPACE}/${PROJECT_NAME})
  endif()

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

add_subdirectory(src/core)

# add_subdirectory(src/module1)


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
    ${CMAKE_CURRENT_SOURCE_DIR}/tests/${PROJECT_TEST_TARGET}.cpp
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

# ------------------------------------------------------------------------------
# Add project module tests
# ------------------------------------------------------------------------------
  
  add_subdirectory(tests/core)

  include(ParseAndAddCatchTests)
  ParseAndAddCatchTests(${PROJECT_TEST_TARGET})

  
endif()

if(BUILD_DOC)
  add_subdirectory(doc)
endif()

# install targets cmake file, previously registered targets in each module.
install(EXPORT {{ cookiecutter.project_slug }}-targets
  FILE
    {{ cookiecutter.project_slug }}Targets.cmake
  NAMESPACE
    {{ cookiecutter.project_slug }}::
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
)

add_custom_target(install-dev
#    DEPENDS docs # TODO: add interface libraries for targets ?
    COMMAND 
    "${CMAKE_COMMAND}" -DCMAKE_INSTALL_COMPONENT=dev
    -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
)
add_custom_target(install-python
#    DEPENDS # TODO: add interface libraries for targets ?
    COMMAND 
    "${CMAKE_COMMAND}" -DCMAKE_INSTALL_COMPONENT=python
    -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
)

