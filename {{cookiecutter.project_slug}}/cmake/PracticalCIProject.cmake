message(WARNING "setting cmake policy CMP0079 NEW, required for the project structure.")

cmake_policy(SET CMP0079 NEW)

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

  # file(RELATIVE_PATH MODULE_INSTALL_PREFIX_ ${PROJECT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}
  # string(REGEX MATCH "\/([0-9A-z]+\/)*(src\/)(([0-9A-z]+\/?)*)" MODULE_PREFIX "/a/b/c/src/p1/p2/m")
  # prefix p1/p2/m in CMAKE_MATCH_3

  string(TOUPPER ${MODULE_NAME} MODULE_NAME_UPPER) # upper case module name
  set(MODULE_OBJECT_LIBRARY_NAME ${MODULE_NAME}-objects)
  set(MODULE_SHARED_LIBRARY_NAME ${MODULE_NAME})
  set(MODULE_STATIC_LIBRARY_NAME ${MODULE_NAME}-static)
  set(MODULE_PYTHON_NAME ${MODULE_NAME})
  set(MODULE_PYTHON_TARGET_NAME ${MODULE_NAME}-python)

  # unset(MODULE_PYTHON_INSTALL_RPATH )
  # TODO: refactor these variables
  set(MODULE_INSTALL_INCLUDEDIR ${PROJECT_INSTALL_INCLUDEDIR}/${MODULE_NAME})
  set(MODULE_INSTALL_PYTHON_SITEARCH ${PROJECT_INSTALL_PYTHON_SITEARCH})

  # Windows does not support rpath, so we will change the library location to
  # match the extension module, when building for pipy.
  # TODO: rename INSTALL_FOR_PYPI by BUILD_FOR_PYTHON.
  if(INSTALL_FOR_PYPI)
    set(MODULE_INSTALL_LIBDIR ${MODULE_INSTALL_PYTHON_SITEARCH})
  else()
    set(MODULE_INSTALL_LIBDIR ${PROJECT_INSTALL_LIBDIR})
  endif()

  set(MODULE_INCLUDEDIR ${PROJECT_INCLUDEDIR}/${MODULE_NAME})

  option(ENABLE_${MODULE_NAME_UPPER}_PYTHON_MODULE_STATIC_LINK
    "Link the python module with the static library." OFF)

  add_library(${MODULE_OBJECT_LIBRARY_NAME} OBJECT ${MODULE_SOURCES})

  target_include_directories(${MODULE_OBJECT_LIBRARY_NAME}
    PUBLIC
      $<INSTALL_INTERFACE:include>
      $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include> # project public includes
    PRIVATE
      ${CMAKE_CURRENT_SOURCE_DIR} # private includes go here
  )

  target_link_libraries(${MODULE_OBJECT_LIBRARY_NAME}
      INTERFACE ${MODULE_INTERFACE_LINK_LIBRARIES}
      PUBLIC ${MODULE_PUBLIC_LINK_LIBRARIES}
      PRIVATE ${MODULE_PRIVATE_LINK_LIBRARIES}
  )

  # shared libraries need PIC, if they are compile from the object files
  set_property(TARGET ${MODULE_OBJECT_LIBRARY_NAME}
    PROPERTY POSITION_INDEPENDENT_CODE ON
  )

  # shared and static libraries built from the same object files
  add_library(${MODULE_SHARED_LIBRARY_NAME} SHARED)

  # in windows, change the C++ library output name, adding "lib" prefix.
  if(WIN32)
    set_target_properties(${MODULE_SHARED_LIBRARY_NAME} PROPERTIES OUTPUT_NAME "lib${MODULE_PYTHON_NAME}")
  endif()

  target_link_libraries(${MODULE_SHARED_LIBRARY_NAME} PUBLIC ${MODULE_OBJECT_LIBRARY_NAME})

  if(BUILD_STATIC OR ENABLE_${MODULE_NAME_UPPER}_PYTHON_MODULE_STATIC_LINK)
    add_library(${MODULE_STATIC_LIBRARY_NAME} STATIC)
    target_link_libraries(${MODULE_STATIC_LIBRARY_NAME} PUBLIC ${MODULE_OBJECT_LIBRARY_NAME})
  endif()


  if (BUILD_PYTHON_PYBIND11)
    pybind11_add_module(${MODULE_PYTHON_TARGET_NAME} ${MODULE_NAME}_python_bindings.cpp)

    # change the name of python modules
    # SEE: https://github.com/pybind/python_example/issues/26
    set_target_properties(${MODULE_PYTHON_TARGET_NAME} PROPERTIES OUTPUT_NAME ${MODULE_PYTHON_NAME})

    if(ENABLE_${MODULE_NAME_UPPER}_PYTHON_MODULE_STATIC_LINK)
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

    endif()

    # requires cmake policy CMP0079, introduced in cmake 3.13.
    # TODO: disabled now target_link_libraries(python_pybind11 INTERFACE ${MODULE_PYTHON_TARGET_NAME}) # TODO: review this target name.

    message("MODULE_INSTALL_PYTHON_SITEARCH: ${MODULE_INSTALL_PYTHON_SITEARCH}")

    install(TARGETS ${MODULE_PYTHON_TARGET_NAME}
      LIBRARY DESTINATION ${MODULE_INSTALL_PYTHON_SITEARCH} COMPONENT python
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

  if(WIN32)
    install(TARGETS ${MODULE_SHARED_LIBRARY_NAME} ${MODULE_OBJECT_LIBRARY_NAME}
#      EXPORT ${PROJECT_NAME}-targets # FIXME: this is causing issues at the moment, comment it
      RUNTIME DESTINATION ${MODULE_INSTALL_LIBDIR} COMPONENT libs
    )
  else()
    install(TARGETS ${MODULE_SHARED_LIBRARY_NAME} ${MODULE_OBJECT_LIBRARY_NAME}
#      EXPORT ${PROJECT_NAME}-targets # FIXME: this is causing issues at the moment, comment it
      LIBRARY DESTINATION ${MODULE_INSTALL_LIBDIR} COMPONENT libs
    )
  endif()

  # install static lib
  if(BUILD_STATIC AND NOT INSTALL_FOR_PYPI)
    install(TARGETS ${MODULE_STATIC_LIBRARY_NAME}
#      EXPORT ${PROJECT_NAME}-targets # FIXME: this is causing issues at the moment, comment it
      ARCHIVE DESTINATION ${MODULE_INSTALL_LIBDIR} COMPONENT dev
    )
  endif()

  list(TRANSFORM MODULE_INTERFACE_HEADERS PREPEND ${MODULE_INCLUDEDIR}/)

  # install module header files
  if(NOT INSTALL_FOR_PYPI)
    install(FILES ${MODULE_INTERFACE_HEADERS}
      DESTINATION ${MODULE_INSTALL_INCLUDEDIR}
      COMPONENT dev
    )
  endif()

endfunction(practci_add_cpp_module)

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

  # link the module to the project test target
  target_link_libraries(${PROJECT_TEST_TARGET} PRIVATE ${MODULE_NAME})

endfunction(practci_add_cpp_test)

