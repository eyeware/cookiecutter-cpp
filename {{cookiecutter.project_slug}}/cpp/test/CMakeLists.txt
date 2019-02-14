# Tests for {{ cookiecutter.project_slug }}

# Add here additional source files
add_executable( ${PROJECT_NAME}_test test_{{cookiecutter.project_slug}}.cpp )

# Add here modules
add_subdirectory(core)
# add_subdirectory(module1)

# make sure you execute "conan install .." in the build directory
target_link_libraries(${PROJECT_NAME}_test CONAN_PKG::catch2 core) # module1)

# Register the tests
# TODO: check about registering test names to filter the tests
# check CTest
add_test(NAME ${PROJECT_NAME}_test COMMAND ${PROJECT_NAME}_test)
