# clang-format


# Add clang-format custom targets.
# Assumes git is being used.

find_program(CLANG_FORMAT_PATH clang-format)

set(CLANG_FORMAT_CPP_FILES_REGEX ".*\.(c|h|cpp|hpp|cxx)$")



if(NOT CLANG_FORMAT_PATH)
  message(WARNING "cmake-format: not found!")
  message(WARNING "cmake-format: not adding check style targets.")
else()
  message("Adding clang-format targets [format,format-all,check-format,\
check-all-format]"
  )

  if(APPLE)
    set(CLANG_FORMAT_FIND_COMAND "find . -E -regex")
  elseif(UNIX)
    set(CLANG_FORMAT_FIND_COMAND 
      "find . -regextype posix-extended -regex ${CLANG_FORMAT_CPP_FILES_REGEX}"
    )
  endif()

  set(CLANG_FORMAT_GIT_LIST_MODIFIED 
  "{ git diff --name-only --diff-filter=ACMRT; \
  git diff --name-only --diff-filter=ACRMT --cached; } | \
  grep -E ${CLANG_FORMAT_CPP_FILES_REGEX}"
  )

  add_custom_target(       
      format
      COMMAND
      ${CLANG_FORMAT_GIT_LIST_MODIFIED} 
      | xargs -n 1 | ${CLANG_FORMAT_PATH}
      -i
      -style=file
      COMMENT "Auto formatting of modified git files."
  )

  add_custom_target(
      format-all
      COMMAND
      ${CLANG_FORMAT_FIND_COMAND} 
      | xargs -n 1 | ${CLANG_FORMAT_PATH}
      -i
      -style=file
      COMMENT "Auto formatting of all source files"
  )

  add_custom_target(
      check-format
      COMMAND
      ${CLANG_FORMAT_GIT_LIST_MODIFIED} 
      | xargs -n 1 | ${CLANG_FORMAT_PATH}
      -style=file
      -output-replacements-xml
      | grep "<replacement " > /dev/null
      COMMENT "Checking format of modified git files."
  )

  add_custom_target(
      check-all-format
      COMMAND
      ${CLANG_FORMAT_FIND_COMAND} 
      | xargs -n 1 | ${CLANG_FORMAT_PATH}
      -style=file
      -output-replacements-xml
      ${CHECK_CXX_SOURCE_FILES}
      # print output
      | tee ${CMAKE_BINARY_DIR}/check_format_file.txt | grep -c "replacement " |
              tr -d "[:cntrl:]" && echo " replacements necessary"
      # WARNING: fix to stop with error if there are problems
      COMMAND ! grep -c "replacement "
                ${CMAKE_BINARY_DIR}/check_format_file.txt > /dev/null
      COMMENT "Checking format compliance of all source files"
  )
endif()


