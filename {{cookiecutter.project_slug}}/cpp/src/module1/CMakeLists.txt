# Target:   {{ cookiecutter.project_slug }}
# Type:     Library

# TODO: add hook scripts to generate a list of modules from module templates 
# for, same for tests
# SEE: https://cookiecutter.readthedocs.io/en/0.9.1/advanced_usage.html

# use object libraries
add_library({{ cookiecutter.module }}_obj OBJECT
    {{ cookiecutter.module }}.cpp
)

target_include_directories({{ cookiecutter.module }}_obj
    PUBLIC 
        $<INSTALL_INTERFACE:include>    
        $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include> # project public includes
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR} # private includes go here
)

# shared libraries need PIC, if they are compile from the obj files, they also 
# neet
set_property(TARGET {{ cookiecutter.module }}_obj 
  PROPERTY POSITION_INDEPENDENT_CODE ON
)

# shared and static libraries built from the same object files
add_library({{ cookiecutter.module }} SHARED)

target_link_libraries({{ cookiecutter.module }} {{ cookiecutter.module }}_obj)

# TODO: add options to build static libs,
add_library({{ cookiecutter.module }}_static STATIC)

target_link_libraries({{ cookiecutter.module }}_static {{ cookiecutter.module }}_obj)
