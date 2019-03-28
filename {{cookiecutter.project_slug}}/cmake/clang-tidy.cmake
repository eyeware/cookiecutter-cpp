
find_program(RUN_CLANG_TIDY_PATH NAMES run-clang-tidy-6.0.py run-clang-tidy.py )
find_program(CLANG_TIDY_TO_JUNIT_PATH NAMES clang-tidy-to-junit.py )

if(NOT RUN_CLANG_TIDY_PATH)
  message(WARNING 
    "run-clang-tidy.py: script not found, not adding clang-tidy targets."
  )
else()
  add_custom_command(OUTPUT ${CMAKE_BINARY_DIR}/compile_commands.json
    COMMAND ${CMAKE_COMMAND} -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ${CMAKE_SOURCE_DIR} 
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
  )

  add_custom_target(
    clang-tidy
    COMMAND ${CMAKE_CURRENT_LIST_DIR}/static-checks-run-clang-tidy.sh -quiet -p ${CMAKE_BINARY_DIR} -header-filter='include/${PROJECT_NAMESPACE}/${PROJECT_NAME}|src/cpp'
    VERBATIM
    DEPENDS ${CMAKE_BINARY_DIR}/compile_commands.json
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    COMMENT "clang-tidy project checks."
  )

  if(NOT CLANG_TIDY_TO_JUNIT_PATH)
    message(WARNING 
      "clang-tidy-to-junit.py: script not found, not adding clang-tidy targets junit xml reports."
    )
  else()
    add_custom_target(
      clang-tidy-junit-report
      COMMAND ${CMAKE_CURRENT_LIST_DIR}/static-checks-run-clang-tidy.sh -junit ${CMAKE_BINARY_DIR}/test_clang-tidy_junit_report.xml -junit-src-root ${PROJECT_SOURCE_DIR} -quiet -p ${CMAKE_BINARY_DIR} -header-filter='include/${PROJECT_NAMESPACE}/${PROJECT_NAME}|src/cpp'ls
      VERBATIM
      DEPENDS ${CMAKE_BINARY_DIR}/compile_commands.json
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      COMMENT "clang-tidy project checks, with junit compatible output."
    )
  endif()
endif()





