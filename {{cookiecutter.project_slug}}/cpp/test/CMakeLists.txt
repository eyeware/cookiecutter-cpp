# Tests for {{ cookiecutter.project_slug }}

# Add here additional source files
add_executable( ${PROJECT_NAME}_test test_{{cookiecutter.project_slug}}.cpp )

# Add here modules
add_subdirectory(core)
# add_subdirectory(module1)

# make sure you execute "conan install .." in the build directory
target_link_libraries(${PROJECT_NAME}_test CONAN_PKG::catch2 libcore) # module1)

# Register the tests
# TODO: check about registering test names to filter the tests
# check CTest
add_test(NAME ${PROJECT_NAME}_test COMMAND ${PROJECT_NAME}_test)

# there is no way for ctest to display test output on failure from whithim cmake
# so add this custom command.
# SEE: 
# https://stackoverflow.com/a/36729074/3978614
# https://stackoverflow.com/a/31124523/3978614
add_custom_target(check 
    ${CMAKE_COMMAND} -E echo CWD=${CMAKE_BINARY_DIR}
    COMMAND ${CMAKE_COMMAND} -E echo CMD=${CMAKE_CTEST_COMMAND} -C $<CONFIG>
    COMMAND ${CMAKE_COMMAND} -E echo ----------------------------------
    COMMAND ${CMAKE_COMMAND} -E env CTEST_OUTPUT_ON_FAILURE=1
        ${CMAKE_CTEST_COMMAND} -C $<CONFIG> 
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        DEPENDS ${PROJECT_NAME}_test
)
