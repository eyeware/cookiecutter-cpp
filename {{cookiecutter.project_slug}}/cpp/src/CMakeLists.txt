# Target:   {{ cookiecutter.project_slug }}_lib
# Type:     Library
file(GLOB SOURCE *.cpp)
add_library({{ cookiecutter.project_slug }}_lib SHARED ${SOURCE})
set_target_properties({{ cookiecutter.project_slug }}_lib PROPERTIES
    "OUTPUT_NAME" "{{ cookiecutter.project_slug }}"
    "INCLUDE_DIRECTORIES" "${CMAKE_CURRENT_SOURCE_DIR}/include"
)
install(TARGETS {{ cookiecutter.project_slug }}_lib EXPORT {{ cookiecutter.project_slug }} DESTINATION ${CMAKE_SOURCE_DIR}/lib)
export(TARGETS {{ cookiecutter.project_slug }}_lib FILE ${CMAKE_BINARY_DIR}/{{ cookiecutter.project_slug }}-config.cmake)
