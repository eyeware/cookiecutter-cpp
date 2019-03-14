# clang-format

# Add clang-format custom targets.
# Assumes git is being used.

find_program(CLANG_FORMAT_PATH clang-format)

if(NOT CLANG_FORMAT_PATH)
  message(WARNING "cmake-format: not found!")
  message(WARNING "cmake-format: not adding C++ check style targets.")
else()

  add_custom_target(
      format
      COMMAND
      ${CMAKE_CURRENT_LIST_DIR}/clang-format-format.sh
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      COMMENT "Auto formatting of modified git source files"
  )

  add_custom_target(
      format-all
      COMMAND
      ${CMAKE_CURRENT_LIST_DIR}/clang-format-format-all.sh
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      COMMENT "Auto formatting of all source files"
  )

  add_custom_target(
      check-format
      COMMAND
      ${CMAKE_CURRENT_LIST_DIR}/clang-format-check-format.sh
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      COMMENT "Check and list modified git files that violate style check."
  )

  add_custom_target(
      check-all-format
      COMMAND
      ${CMAKE_CURRENT_LIST_DIR}/clang-format-check-all-format.sh
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      COMMENT "Check and list all files that violate style check."
  )

endif()


