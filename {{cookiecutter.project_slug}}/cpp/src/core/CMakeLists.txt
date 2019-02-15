# Target:   core
# Type:     Library


# use object libraries

set(MODULE_NAME core) # breacking new cmake recomendations to make it simpler

add_library(${MODULE_NAME}_obj OBJECT
A.cpp
B.cpp
C.cpp
D.cpp
E.cpp)

target_include_directories(${MODULE_NAME}_obj
  PUBLIC 
    $<INSTALL_INTERFACE:include>
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include> # project public includes
  PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR} # private includes go here
)

# shared libraries need PIC, if they are compile from the obj files, they also 
# neet
set_property(TARGET ${MODULE_NAME}_obj 
  PROPERTY POSITION_INDEPENDENT_CODE ON
)

# shared and static libraries built from the same object files
add_library(${MODULE_NAME} SHARED)
target_link_libraries(${MODULE_NAME} PUBLIC ${MODULE_NAME}_obj)

# add a dependency for all libraries of the project
target_link_libraries(${PROJECT_NAME} INTERFACE ${MODULE_NAME})


if (BUILD_PYBIND11_BINDINGS)
  set(PYTHON_PACKAGE_NAME ${PROJECT_NAME}.${MODULE_NAME})

  pybind11_add_module(${PYTHON_PACKAGE_NAME} ${MODULE_NAME}_python_bindings.cpp)

  target_link_libraries(${PYTHON_PACKAGE_NAME} PRIVATE ${MODULE_NAME})
  #set_target_properties(foo PROPERTIES OUTPUT_NAME mymodule/foo)

  target_link_libraries(python_bindings INTERFACE ${PYTHON_PACKAGE_NAME}) 

  install(TARGETS ${PYTHON_PACKAGE_NAME}
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

install(TARGETS ${MODULE_NAME} ${MODULE_NAME}_obj
  EXPORT ${PROJECT_NAME}-targets
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/${PROJECT_NAME} COMPONENT libs
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}/${PROJECT_NAME} COMPONENT libs # ?? what is this ??
)

# install module files
install(FILES 
    ${PROJECT_SOURCE_DIR}/include/${PROJECT_NAME}/${MODULE_NAME}/A.h
    ${PROJECT_SOURCE_DIR}/include/${PROJECT_NAME}/${MODULE_NAME}/B.h
    ${PROJECT_SOURCE_DIR}/include/${PROJECT_NAME}/${MODULE_NAME}/C.h
    ${PROJECT_SOURCE_DIR}/include/${PROJECT_NAME}/${MODULE_NAME}/D.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}/${MODULE_NAME} 
  COMPONENT dev
)

# TODO: add options to build static libs,
# add_library(${MODULE_NAME}_static STATIC)
# target_link_libraries(${MODULE_NAME}_static ${MODULE_NAME}_obj)


