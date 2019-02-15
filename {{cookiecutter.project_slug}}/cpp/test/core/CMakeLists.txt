# Add module tests here

# NOTE: use the prefix ${CMAKE_CURRENT_SOURCE_DIR} when adding source files
# otherwise they might not be found where you include the target.
target_sources(${PROJECT_NAME}_test PRIVATE 
  ${CMAKE_CURRENT_SOURCE_DIR}/test_core.cpp
)
