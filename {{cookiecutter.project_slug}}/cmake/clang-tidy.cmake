find_program(RUN_CLANG_TIDY_PATH NAMES run-clang-tidy.py run-clang-tidy-6.0.py)

if(NOT RUN_CLANG_TIDY_PATH)
  message(WARNING "run-clang-tidy.py: script not found!")
  message(WARNING "clang-tidy: not adding C++ check targets.")
else()

  add_custom_target(
      clang-tidy
      COMMAND
      ${RUN_CLANG_TIDY_PATH} # -p ${CMAKE_BINARY_DIR}
      DEPENDS ${CMAKE_BINARY_DIR}/compile_commands.json
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
      COMMENT "Auto formatting of all source files"
  )


  add_custom_command(OUTPUT ${CMAKE_BINARY_DIR}/compile_commands.json
    COMMAND ${CMAKE_COMMAND} -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ${CMAKE_SOURCE_DIR} 
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
  )

endif()





