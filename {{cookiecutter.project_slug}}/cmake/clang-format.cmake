# clang-format


# Add clang-format custom targets.
# Assumes git is being used.

find_program(CLANG_FORMAT_PATH clang-format)

set(CLANG_FORMAT_CPP_FILES_REGEX "'.*\.(c|h|cpp|hpp|cxx)$'")



if(NOT CLANG_FORMAT_PATH)
  message(WARNING "cmake-format: not found!")
  message(WARNING "cmake-format: not adding check style targets.")
else()
  message("Adding clang-format targets [format,format-all,check-format,\
check-all-format]"
  )

  add_custom_target(       
      format
      COMMAND
      git diff --name-only --diff-filter=ACMRT | grep -E ${CLANG_FORMAT_CPP_FILES_REGEX}
      | xargs -n 1 ${CLANG_FORMAT_PATH}
      -i
      -style=file
      COMMAND
      git diff --name-only --diff-filter=ACMRT --cached | grep -E ${CLANG_FORMAT_CPP_FILES_REGEX}
      | xargs -n 1 ${CLANG_FORMAT_PATH}
      -i
      -style=file
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      COMMENT "Auto formatting of modified git files."
      VERBATIM
  )

  add_custom_target(
      format-all
      COMMAND
      find . -regextype posix-extended -regex ${CLANG_FORMAT_CPP_FILES_REGEX}
      | xargs -n 1 ${CLANG_FORMAT_PATH}
      -i
      -style=file
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      COMMENT "Auto formatting of all source files"
      VERBATIM
  )

  add_custom_target(
      check-format
      COMMAND
      ! git diff --name-only --diff-filter=ACMRT | grep -E ${CLANG_FORMAT_CPP_FILES_REGEX}
      | xargs -n 1 ${CLANG_FORMAT_PATH}
      -style=file
      -output-replacements-xml
      | grep "<replacement " > /dev/null
      COMMAND
      ! git diff --name-only --diff-filter=ACMRT --cached | grep -E ${CLANG_FORMAT_CPP_FILES_REGEX}
      | xargs -n 1 ${CLANG_FORMAT_PATH}
      -style=file
      -output-replacements-xml
      | grep "<replacement " > /dev/null
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      COMMENT "Checking format of modified git files."
      VERBATIM
  )

  add_custom_target(
      check-all-format
      COMMAND
      ! find . -regextype posix-extended -regex ${CLANG_FORMAT_CPP_FILES_REGEX}
      | xargs -n 1 ${CLANG_FORMAT_PATH}
      -style=file
      -output-replacements-xml
      | grep "<replacement " > /dev/null
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      COMMENT "Checking format compliance of all source files"
      VERBATIM
  )
endif()


