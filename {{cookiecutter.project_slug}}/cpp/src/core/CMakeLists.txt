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


# Add library to the export install target
# TODO: this ${MODULE_NAME}_obj gets exported, it make no sense, check for a 
# better solution, that might include droping the obj library ...
install(TARGETS ${MODULE_NAME} ${MODULE_NAME}_obj
  EXPORT ${PROJECT_NAME}-targets
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/${PROJECT_NAME} COMPONENT Libraries
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}/${PROJECT_NAME} COMPONENT Libraries # ?? what is this ??
)

# install module files
install(FILES 
    ${PROJECT_SOURCE_DIR}/include/${PROJECT_NAME}/${MODULE_NAME}/A.h
    ${PROJECT_SOURCE_DIR}/include/${PROJECT_NAME}/${MODULE_NAME}/B.h
    ${PROJECT_SOURCE_DIR}/include/${PROJECT_NAME}/${MODULE_NAME}/C.h
    ${PROJECT_SOURCE_DIR}/include/${PROJECT_NAME}/${MODULE_NAME}/D.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}/${MODULE_NAME} 
  COMPONENT Headers
)

# TODO: add options to build static libs,
# add_library(${MODULE_NAME}_static STATIC)
# target_link_libraries(${MODULE_NAME}_static ${MODULE_NAME}_obj)


