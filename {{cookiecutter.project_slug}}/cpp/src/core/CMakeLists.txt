# Target:   core
# Type:     Library


# use object libraries

set(MODULE_NAME core) # breacking new cmake recomendations to make it simpler

set(MODULE_OBJECT_LIBRARY_NAME lib${MODULE_NAME}-objects)
set(MODULE_SHARED_LIBRARY_NAME lib${MODULE_NAME})
set(MODULE_STATIC_LIBRARY_NAME lib${MODULE_NAME}-static)
set(MODULE_PYTHON_NAME ${MODULE_NAME})
set(MODULE_PYTHON_TARGET_NAME ${MODULE_NAME}-python)


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

# shared libraries need PIC, if they are compile from the obj files, they also 
# neet
set_property(TARGET ${MODULE_OBJECT_LIBRARY_NAME}
  PROPERTY POSITION_INDEPENDENT_CODE ON
)

# shared and static libraries built from the same object files
add_library(${MODULE_SHARED_LIBRARY_NAME} SHARED)
target_link_libraries(${MODULE_SHARED_LIBRARY_NAME} PUBLIC ${MODULE_OBJECT_LIBRARY_NAME})

# the static lib is used to link with the python bindings
if(${BUILD_STATIC} OR ${BUILD_PYBIND11_BINDINGS})
  add_library(${MODULE_STATIC_LIBRARY_NAME} STATIC)
  target_link_libraries(${MODULE_STATIC_LIBRARY_NAME} PUBLIC ${MODULE_OBJECT_LIBRARY_NAME})
endif()

# add a dependency for all libraries of the project
# target_link_libraries(${PROJECT_NAME} INTERFACE ${MODULE_SHARED_LIBRARY_NAME})

if (BUILD_PYBIND11_BINDINGS)
  pybind11_add_module(${MODULE_PYTHON_TARGET_NAME} ${MODULE_NAME}_python_bindings.cpp)

  # change the name of python modules: https://github.com/pybind/python_example/issues/26
  set_target_properties(${MODULE_PYTHON_TARGET_NAME} PROPERTIES OUTPUT_NAME ${MODULE_PYTHON_NAME})

  target_link_libraries(${MODULE_PYTHON_TARGET_NAME} PRIVATE ${MODULE_STATIC_LIBRARY_NAME})

  target_link_libraries(python_bindings INTERFACE ${MODULE_PYTHON_TARGET_NAME}) # TODO: review this target name.

  install(TARGETS ${MODULE_PYTHON_TARGET_NAME}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/${PROJECT_NAME} COMPONENT python
  )
endif()

# Add library to the export install target
# TODO: this ${MODULE_NAME}_obj gets exported, it make no sense, check for a 
# better solution, that might include droping the obj library ...
# it seems to be described here, but I dont understand very well the solution
# https://gitlab.kitware.com/cmake/cmake/issues/14778
# https://gitlab.kitware.com/cmake/cmake/issues/17357
# https://gitlab.kitware.com/cmake/community/wikis/doc/tutorials/Object-Library

# install shared lib
install(TARGETS ${MODULE_SHARED_LIBRARY_NAME} ${MODULE_OBJECT_LIBRARY_NAME}
  EXPORT ${PROJECT_NAME}-targets
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/${PROJECT_NAME} COMPONENT libs
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}/${PROJECT_NAME} COMPONENT libs # ?? what is this ??
)

# install static lib
if(BUILD_STATIC)
  install(TARGETS ${MODULE_STATIC_LIBRARY_NAME}
    EXPORT ${PROJECT_NAME}-targets
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/${PROJECT_NAME} COMPONENT libs
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}/${PROJECT_NAME} COMPONENT libs # ?? what is this ??
  )
endif()

# install module header files
install(FILES 
    ${PROJECT_SOURCE_DIR}/include/${PROJECT_NAME}/${MODULE_NAME}/A.h
    ${PROJECT_SOURCE_DIR}/include/${PROJECT_NAME}/${MODULE_NAME}/B.h
    ${PROJECT_SOURCE_DIR}/include/${PROJECT_NAME}/${MODULE_NAME}/C.h
    ${PROJECT_SOURCE_DIR}/include/${PROJECT_NAME}/${MODULE_NAME}/D.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}/${MODULE_NAME} 
  COMPONENT dev
)



