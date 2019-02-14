# Target:   {{ cookiecutter.project_slug }}
# Type:     Library


# use object libraries
add_library(core_obj OBJECT
A.cpp
B.cpp
C.cpp
D.cpp
E.cpp)

target_include_directories(core_obj
    PUBLIC 
        $<INSTALL_INTERFACE:include>    
        $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include> # project public includes
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR} # private includes go here
)

# shared libraries need PIC, if they are compile from the obj files, they also 
# neet
set_property(TARGET core_obj 
  PROPERTY POSITION_INDEPENDENT_CODE ON
)

# shared and static libraries built from the same object files
add_library(core SHARED)

target_link_libraries(core core_obj)

# TODO: add options to build static libs,
add_library(core_static STATIC)

target_link_libraries(core_static core_obj)


