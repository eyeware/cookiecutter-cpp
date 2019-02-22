# Module:   core
# Type:     Library
# Type:     Python Extensions


set(MODULE_NAME core) # breaking new cmake recomendations to make it simpler
string(TOUPPER ${MODULE_NAME} MODULE_NAME_UPPER) # upper case module name
set(MODULE_OBJECT_LIBRARY_NAME ${MODULE_NAME}-objects)
set(MODULE_SHARED_LIBRARY_NAME ${MODULE_NAME})
set(MODULE_STATIC_LIBRARY_NAME ${MODULE_NAME}-static)
set(MODULE_PYTHON_NAME ${MODULE_NAME})
set(MODULE_PYTHON_TARGET_NAME ${MODULE_NAME}-python)


# unset(MODULE_PYTHON_INSTALL_RPATH )
# TODO: refactor these variables
set(MODULE_INSTALL_LIBDIR ${PROJECT_INSTALL_LIBDIR})
set(MODULE_INSTALL_INCLUDEDIR ${PROJECT_INSTALL_INCLUDEDIR}/${MODULE_NAME})
set(MODULE_INCLUDEDIR ${PROJECT_INCLUDEDIR}/${MODULE_NAME})

option(ENABLE_${MODULE_NAME_UPPER}_MODULE_PYTHON_STATIC_LINK_LIBRARY 
  "Link the python module with the static library." OFF)

add_library(${MODULE_OBJECT_LIBRARY_NAME} OBJECT
A.cpp
B.cpp
C.cpp
D.cpp
E.cpp)

target_include_directories(${MODULE_OBJECT_LIBRARY_NAME}
  PUBLIC 
    $<INSTALL_INTERFACE:include>
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include> # project public includes
  PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR} # private includes go here
)

# shared libraries need PIC, if they are compile from the object files
set_property(TARGET ${MODULE_OBJECT_LIBRARY_NAME}
  PROPERTY POSITION_INDEPENDENT_CODE ON
)

# shared and static libraries built from the same object files
add_library(${MODULE_SHARED_LIBRARY_NAME} SHARED)
target_link_libraries(${MODULE_SHARED_LIBRARY_NAME} PUBLIC ${MODULE_OBJECT_LIBRARY_NAME})

if(BUILD_STATIC OR ENABLE_${MODULE_NAME_UPPER}_MODULE_PYTHON_STATIC_LINK_LIBRARY)
  add_library(${MODULE_STATIC_LIBRARY_NAME} STATIC)
  target_link_libraries(${MODULE_STATIC_LIBRARY_NAME} PUBLIC ${MODULE_OBJECT_LIBRARY_NAME})
endif()


if (BUILD_PYTHON_PYBIND11)
  pybind11_add_module(${MODULE_PYTHON_TARGET_NAME} ${MODULE_NAME}_python_bindings.cpp)

  # change the name of python modules 
  # SEE: https://github.com/pybind/python_example/issues/26
  set_target_properties(${MODULE_PYTHON_TARGET_NAME} PROPERTIES OUTPUT_NAME ${MODULE_PYTHON_NAME})

  if(ENABLE_${MODULE_NAME_UPPER}_MODULE_PYTHON_STATIC_LINK_LIBRARY)
    # NOTE: there is an issue with this aproach, if different python modules share
    # the same libs then it might break static like functionality in the libs, as 
    # each module will be static linked with the python extension module.
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
    if(DEFINED ENV{CONDA_PREFIX})
        message("Computing rpath for conda environment, name: $ENV{CONDA_DEFAULT_ENV}, path:$ENV{CONDA_PREFIX}")
        # ${CMAKE_INSTALL_LIBDIR}/${PROJECT_NAME} # TODO: refactor this and use PROJECT_INSTALL_LIBDIR or ${PROJECT_NAME_UPPER}_INSTALL_LIBDIR

        set(MODULE_PYTHON_INSTALL_RPATH ${CMAKE_INSTALL_PREFIX}/${MODULE_INSTALL_LIBDIR})
        set(MODULE_PYTHON_BUILD_RPATH ${CMAKE_BINARY_DIR}/${MODULE_INSTALL_LIBDIR})
    endif()

    message("MODULE_PYTHON_INSTALL_RPATH ${MODULE_PYTHON_INSTALL_RPATH}")
    message("MODULE_PYTHON_BUILD_RPATH ${MODULE_PYTHON_BUILD_RPATH}")

    set_target_properties(${MODULE_PYTHON_TARGET_NAME} PROPERTIES 
        INSTALL_RPATH ${MODULE_PYTHON_INSTALL_RPATH}
        BUILD_RPATH ${MODULE_PYTHON_BUILD_RPATH}
    )
  endif()

  # requires cmake policy CMP0079, introduced in cmake 3.13.
  # TODO: disabled now target_link_libraries(python_pybind11 INTERFACE ${MODULE_PYTHON_TARGET_NAME}) # TODO: review this target name.

  install(TARGETS ${MODULE_PYTHON_TARGET_NAME}
    LIBRARY DESTINATION ${PYTHON_SITE_PACKAGES}/${PROJECT_NAME} COMPONENT python
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
install(TARGETS ${MODULE_SHARED_LIBRARY_NAME} # ${MODULE_OBJECT_LIBRARY_NAME} # TODO: carify issue https://gitlab.kitware.com/cmake/cmake/issues/18935
  EXPORT ${PROJECT_NAME}-targets
  LIBRARY DESTINATION ${MODULE_INSTALL_LIBDIR} COMPONENT libs
)

# install static lib
if(BUILD_STATIC)
  install(TARGETS ${MODULE_STATIC_LIBRARY_NAME}
    EXPORT ${PROJECT_NAME}-targets
    ARCHIVE DESTINATION ${MODULE_INSTALL_LIBDIR} COMPONENT libs
  )
endif()

# install module header files
install(FILES 
    ${MODULE_INCLUDEDIR}/A.h
    ${MODULE_INCLUDEDIR}/B.h
    ${MODULE_INCLUDEDIR}/C.h
    ${MODULE_INCLUDEDIR}/D.h
  DESTINATION ${MODULE_INSTALL_INCLUDEDIR}
  COMPONENT dev
)



