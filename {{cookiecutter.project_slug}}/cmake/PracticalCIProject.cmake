message(WARNING "setting cmake policy CMP0079 NEW, required for the project structure.")

cmake_policy(SET CMP0079 NEW)

#
# This adds a module to the project. A module has two build modes, one for python and another 
# for C++ libraries.
#
# At the moment, the python module is build for pypi like modules, and are statically linked
# with the C++ libraries.
#
# Another option shall be provided (not suppored yet), to allow building python modules linking with project 
# shared C++ library, to install in conda environments.
#

#
# \param: SOURCES <list of source files in the module>
# \param: INTERFACE <list of public API includes>
#
# practci_add_cpp_module(SOURCES <source files>
#                        INTERFACE_HEADERS <public header files>
#                        [PRIVATE_LINK_LIBRARIES <lib>+]
#                        [PUBLIC_LINK_LIBRARIES <lib>+]
#                        [INTERFACE_LINK_LIBRARIES> <lib>+])
#
function(practci_add_cpp_module)
  set(MULTI_VALUE_ARGS SOURCES INTERFACE_HEADERS
      PUBLIC_LINK_LIBRARIES INTERFACE_LINK_LIBRARIES PRIVATE_LINK_LIBRARIES
  )

  cmake_parse_arguments(MODULE "" "" "${MULTI_VALUE_ARGS}" ${ARGN})

  # the module name is assumed to be the current directory name
  # the module must be under src/<module_name>
  get_filename_component(MODULE_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)

  file(RELATIVE_PATH MODULE_INSTALL_PREFIX_ ${PROJECT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR})
  string(REGEX MATCH "\/?([0-9A-z]+\/)*(cpp\/)(([0-9A-z]+\/?)*)" MODULE_PREFIX "${MODULE_INSTALL_PREFIX_}")
  # prefix sdk/core/m in CMAKE_MATCH_3
  set(MODULE_PREFIX ${CMAKE_MATCH_3})

  message("MODULE_PREFIX: ${MODULE_PREFIX}")

  # TODO: this was meant to be used with multiple level packages, but its not working
  # due to python import conflict between __init__.py and the root module...
  get_filename_component(MODULE_PYTHON_PREFIX "${MODULE_PREFIX}" DIRECTORY)

  message("MODULE_PYTHON_PREFIX: ${MODULE_PREFIX}")

  string(TOUPPER ${MODULE_NAME} MODULE_NAME_UPPER) # upper case module name
  set(MODULE_OBJECT_LIBRARY_NAME ${MODULE_NAME}-objects)
  set(MODULE_SHARED_LIBRARY_NAME ${MODULE_NAME})
  set(MODULE_STATIC_LIBRARY_NAME ${MODULE_NAME}-static)
  set(MODULE_PYTHON_NAME ${MODULE_NAME})
  set(MODULE_PYTHON_TARGET_NAME ${MODULE_NAME}-python)
  
  set(MODULE_INSTALL_INCLUDEDIR ${PROJECT_INSTALL_INCLUDEDIR}/${MODULE_PREFIX})
  message("MODULE_INSTALL_INCLUDEDIR: ${MODULE_INSTALL_INCLUDEDIR}")

  set(MODULE_INSTALL_PYTHON_SITEARCH ${PROJECT_INSTALL_PYTHON_SITEARCH}/${MODULE_PYTHON_PREFIX})

  # Windows does not support rpath, so we will change the library location to
  # match the extension module, when building for pipy.
  if(INSTALL_FOR_PYPI)
    set(MODULE_INSTALL_LIBDIR ${MODULE_INSTALL_PYTHON_SITEARCH})
  else()
    set(MODULE_INSTALL_LIBDIR ${PROJECT_INSTALL_LIBDIR})
  endif()

  set(MODULE_PUBLIC_INCLUDEDIR ${PROJECT_PUBLIC_INCLUDEDIR}/${PROJECT_PREFIX}/${MODULE_PREFIX})
  set(MODULE_PRIVATE_INCLUDEDIR ${PROJECT_PRIVATE_INCLUDEDIR}/${PROJECT_PREFIX}/${MODULE_PREFIX})

  add_library(${MODULE_OBJECT_LIBRARY_NAME} OBJECT ${MODULE_SOURCES})
  message("PROJECT_PUBLIC_INCLUDEDIR: ${PROJECT_PUBLIC_INCLUDEDIR}")

  target_include_directories(${MODULE_OBJECT_LIBRARY_NAME}
    PUBLIC
      $<INSTALL_INTERFACE:include>
      $<BUILD_INTERFACE:${PROJECT_PUBLIC_INCLUDEDIR}> # project public includes
    PRIVATE
      ${CMAKE_CURRENT_SOURCE_DIR}                     # module private includes go here
      $<BUILD_INTERFACE:${PROJECT_PRIVATE_INCLUDEDIR} # project private includes go here
  )

  list(TRANSFORM MODULE_INTERFACE_HEADERS PREPEND ${MODULE_PUBLIC_INCLUDEDIR}/)

  set_property(TARGET ${MODULE_OBJECT_LIBRARY_NAME} PROPERTY PUBLIC_HEADER ${MODULE_INTERFACE_HEADERS})

  target_link_libraries(${MODULE_OBJECT_LIBRARY_NAME}
      INTERFACE ${MODULE_INTERFACE_LINK_LIBRARIES}
      PUBLIC    ${MODULE_PUBLIC_LINK_LIBRARIES}
      PRIVATE   ${MODULE_PRIVATE_LINK_LIBRARIES}
  )

  # shared libraries need PIC, if they are compile from the object files
  set_property(TARGET ${MODULE_OBJECT_LIBRARY_NAME}
    PROPERTY POSITION_INDEPENDENT_CODE ON
  )

  # if building for python with static link do not create share libraries. 
  if((BUILD_PYTHON_PYBIND11 OR BUILD_PYTHON_SWIG) AND ENABLE_STATIC_LINK_PYTHON_MODULES)
    add_library(${MODULE_STATIC_LIBRARY_NAME} STATIC)
    target_link_libraries(${MODULE_STATIC_LIBRARY_NAME} PUBLIC ${MODULE_OBJECT_LIBRARY_NAME})
  else()
    # add shared libraries and static libraries
    add_library(${MODULE_STATIC_LIBRARY_NAME} STATIC)
    target_link_libraries(${MODULE_STATIC_LIBRARY_NAME} PUBLIC ${MODULE_OBJECT_LIBRARY_NAME})  

    add_library(${MODULE_SHARED_LIBRARY_NAME} SHARED)
    # in windows, change the C++ library output name, adding "lib" prefix.
    if(WIN32)
      set_target_properties(${MODULE_SHARED_LIBRARY_NAME} PROPERTIES OUTPUT_NAME "lib${MODULE_PYTHON_NAME}")
    endif()

    target_link_libraries(${MODULE_SHARED_LIBRARY_NAME} PUBLIC ${MODULE_OBJECT_LIBRARY_NAME})
  endif()


  if (BUILD_PYTHON_PYBIND11)
    pybind11_add_module(${MODULE_PYTHON_TARGET_NAME} ${MODULE_NAME}_python_bindings.cpp)

    # change the name of python modules
    # SEE: https://github.com/pybind/python_example/issues/26
    set_target_properties(${MODULE_PYTHON_TARGET_NAME} PROPERTIES OUTPUT_NAME ${MODULE_PYTHON_NAME})

    if(ENABLE_STATIC_LINK_PYTHON_MODULES)
      # NOTE: there is an issue with this aproach, if different python modules share
      # the same libs then it might break static like functionality in the libs, as
      # each module will be static linked with the python extension module, and
      # some symbols might be undefined.
      target_link_libraries(${MODULE_PYTHON_TARGET_NAME} PRIVATE ${MODULE_STATIC_LIBRARY_NAME})
    else()
      target_link_libraries(${MODULE_PYTHON_TARGET_NAME} PRIVATE ${MODULE_SHARED_LIBRARY_NAME})

      # python extension modules are installed in the same location of the lib
      # module, set the rpath, so that the lib searchs first in the same location.
      # SEE: https://gitlab.kitware.com/cmake/community/wikis/doc/cmake/RPATH-handling#different-rpath-settings-within-one-project

      # NOTE: for conda packages conda-build alreadu performs some
      # modules, by the conda install or build.
      # SEE: point 8 of
      # https://docs.conda.io/projects/conda-build/en/latest/source/concepts/recipe.html#conda-build-process
      # SEE:
      # https://news.ycombinator.com/item?id=16745892

      # 1- When on the conda environment, we need to set the rpath of the python
      # module such that the libraries for which the module links get found by the
      # linker at runtime.

      # 2 - when on the system python, then we can set an abslute rpath to the
      # library

      file(RELATIVE_PATH MODULE_PYTHON_INSTALL_RPATH
        ${CMAKE_INSTALL_PREFIX}/${MODULE_INSTALL_PYTHON_SITEARCH}
        ${CMAKE_INSTALL_PREFIX}/${MODULE_INSTALL_LIBDIR}
      )

      set(MODULE_PYTHON_INSTALL_RPATH $ORIGIN/${MODULE_PYTHON_INSTALL_RPATH})

      file(RELATIVE_PATH MODULE_PYTHON_BUILD_RPATH
        ${CMAKE_BINARY_DIR}/${MODULE_INSTALL_PYTHON_SITEARCH}
        ${CMAKE_BINARY_DIR}/${MODULE_INSTALL_LIBDIR}
      )

      # TODO: build path might be wrong, need to check with tests!!
      set(MODULE_PYTHON_BUILD_RPATH $ORIGIN/${MODULE_PYTHON_BUILD_RPATH})

      message("MODULE_PYTHON_INSTALL_RPATH ${MODULE_PYTHON_INSTALL_RPATH}")
      message("MODULE_PYTHON_BUILD_RPATH ${MODULE_PYTHON_BUILD_RPATH}")

      set_target_properties(${MODULE_PYTHON_TARGET_NAME} PROPERTIES
          INSTALL_RPATH ${MODULE_PYTHON_INSTALL_RPATH}
          BUILD_RPATH ${MODULE_PYTHON_BUILD_RPATH}
      )
    endif()

    # requires cmake policy CMP0079, introduced in cmake 3.13.
    # TODO: disabled now target_link_libraries(python_pybind11 INTERFACE ${MODULE_PYTHON_TARGET_NAME}) # TODO: review this target name.

    message("MODULE_INSTALL_PYTHON_SITEARCH: ${MODULE_INSTALL_PYTHON_SITEARCH}")

    install(TARGETS ${MODULE_PYTHON_TARGET_NAME}
      LIBRARY DESTINATION ${MODULE_INSTALL_PYTHON_SITEARCH} COMPONENT Python
    )
  endif()

  if(BUILD_PYTHON_SWIG)
  # TODO:
  endif()

  # Add library to the export install target
  # TODO: this ${MODULE_NAME}_obj gets exported, it make no sense, check for a
  # better solution, that might include droping the obj library ...
  # it seems to be described here, but I dont understand very well the solution
  # https://gitlab.kitware.com/cmake/cmake/issues/14778
  # https://gitlab.kitware.com/cmake/cmake/issues/17357
  # https://gitlab.kitware.com/cmake/community/wikis/doc/tutorials/Object-Library

  # install shared lib
  # TODO: clarify issue about object libs https://gitlab.kitware.com/cmake/cmake/issues/18935


  # Install exports, only if not compiling for python and if option 
  # INSTALL_DEVELOPMENT is ON.
  if(NOT BUILD_PYTHON_PYBIND11 AND NOT BUILD_PYTHON_SWIG AND INSTALL_DEVELOPMENT)

    install(TARGETS ${MODULE_OBJECT_LIBRARY_NAME}
      EXPORT ${PROJECT_NAME}-targets COMPONENT Development
      PUBLIC_HEADER DESTINATION ${MODULE_INSTALL_INCLUDEDIR} COMPONENT Development
    )
    
    install(TARGETS ${MODULE_STATIC_LIBRARY_NAME}
      EXPORT ${PROJECT_NAME}-targets
      ARCHIVE DESTINATION ${MODULE_INSTALL_LIBDIR} COMPONENT Development
    )

    if(WIN32)
      install(TARGETS ${MODULE_SHARED_LIBRARY_NAME}
        EXPORT ${PROJECT_NAME}-targets
        RUNTIME DESTINATION ${MODULE_INSTALL_LIBDIR} COMPONENT Runtime
      )
    else()
      install(TARGETS ${MODULE_SHARED_LIBRARY_NAME}
        EXPORT ${PROJECT_NAME}-targets
        LIBRARY DESTINATION ${MODULE_INSTALL_LIBDIR} COMPONENT Runtime
      )
    endif()
  endif()

endfunction(practci_add_cpp_module)

function(print_target_properties tgt)
  if(NOT TARGET ${tgt})
    message("There is no target named '${tgt}'")
    return()
  endif()

  foreach (prop ${CMAKE_PROPERTY_LIST})
    string(REPLACE "<CONFIG>" "${CMAKE_BUILD_TYPE}" prop ${prop})
    # Fix https://stackoverflow.com/questions/32197663/how-can-i-remove-the-the-location-property-may-not-be-read-from-target-error-i
    #if(prop STREQUAL "LOCATION" OR prop MATCHES "^LOCATION_" OR prop MATCHES "_LOCATION$")
    #  continue()
    #endif()
    # message ("Checking ${prop}")
    get_property(propval TARGET ${tgt} PROPERTY ${prop} SET)
    if (propval)
      get_target_property(propval ${tgt} ${prop})
      message ("${tgt} ${prop} = ${propval}")
    endif()
  endforeach(prop)
endfunction(print_target_properties)

# Add module tests here

# practci_add_cpp_test() no additional test files for the module.
# practci_add_cpp_test(SOURCES <source file>...)
function(practci_add_cpp_test)
  set(MULTI_VALUE_ARGS SOURCES)

  cmake_parse_arguments(MODULE "" "" "${MULTI_VALUE_ARGS}" ${ARGN})

  # the module name is assumed to be the current directory name
  # the module must be under src/<module_name>
  get_filename_component(MODULE_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)

  list(INSERT MODULE_SOURCES 0 "test_${MODULE_NAME}.cpp")

  list(TRANSFORM MODULE_SOURCES PREPEND ${CMAKE_CURRENT_SOURCE_DIR}/)

  # NOTE: use the prefix ${CMAKE_CURRENT_SOURCE_DIR} when adding source files
  # otherwise they might not be found where you include the target.
  target_sources(${PROJECT_TEST_TARGET} PRIVATE ${MODULE_SOURCES})

  set(MODULE_STATIC_LIBRARY_NAME ${MODULE_NAME}-static)

  # link the module to the project test target
  target_link_libraries(${PROJECT_TEST_TARGET} PUBLIC ${MODULE_STATIC_LIBRARY_NAME})

endfunction(practci_add_cpp_test)
