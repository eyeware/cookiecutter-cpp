# Target:   {{ cookiecutter.project_slug }}
# Type:     Library


# use object libraries
add_library({{ cookiecutter.project_slug }}_obj OBJECT
A.cpp
B.cpp
C.cpp
D.cpp
E.cpp)

target_include_directories({{ cookiecutter.project_slug }}_obj
    PUBLIC 
        $<INSTALL_INTERFACE:include>    
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../include>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}
)

# shared libraries need PIC, if they are compile from the obj files, they also 
# neet
set_property(TARGET {{ cookiecutter.project_slug }}_obj 
  PROPERTY POSITION_INDEPENDENT_CODE ON
)


# shared and static libraries built from the same object files
add_library({{ cookiecutter.project_slug }} SHARED
  $<TARGET_OBJECTS:{{ cookiecutter.project_slug }}_obj>
)

add_library({{ cookiecutter.project_slug }}_static STATIC
  $<TARGET_OBJECTS:{{ cookiecutter.project_slug }}_obj>
)


#install(TARGETS {{ cookiecutter.project_slug }}_lib EXPORT {{ cookiecutter.project_slug }} DESTINATION ${CMAKE_INSTALL_LIBDIR})
#export(TARGETS {{ cookiecutter.project_slug }}_lib FILE ${CMAKE_BINARY_DIR}/{{ cookiecutter.project_slug }}-config.cmake)
