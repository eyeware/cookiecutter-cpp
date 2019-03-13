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

#  if(APPLE) TODO: not working !?
#    set(CLANG_FORMAT_FIND_COMAND "find . -E -regex")
#  elseif(UNIX)
    set(CLANG_FORMAT_FIND_COMAND 
      "find . -regextype posix-extended -regex ${CLANG_FORMAT_CPP_FILES_REGEX}"
    )
#  endif()

  set(CLANG_FORMAT_GIT_LIST_MODIFIED 
    "git diff --name-only --diff-filter=ACMRT | grep -E ${CLANG_FORMAT_CPP_FILES_REGEX}"
  )

  set(CLANG_FORMAT_GIT_LIST_MODIFIED_STASHED 
    "git diff --name-only --diff-filter=ACMRT --cached | grep -E ${CLANG_FORMAT_CPP_FILES_REGEX}"
  )

  add_custom_target(       
      format
      COMMAND
      ${CLANG_FORMAT_GIT_LIST_MODIFIED} 
      | xargs -n 1 | ${CLANG_FORMAT_PATH}
      -i
      -style=file
      COMMAND
      ${CLANG_FORMAT_GIT_LIST_MODIFIED_STASHED} 
      | xargs -n 1 | ${CLANG_FORMAT_PATH}
      -i
      -style=file
      COMMENT "Auto formatting of modified git files."
      VERBATIM
  )

  add_custom_target(
      format-all
      COMMAND
      ${CLANG_FORMAT_FIND_COMAND} 
      | xargs -n 1 | ${CLANG_FORMAT_PATH}
      -i
      -style=file
      COMMENT "Auto formatting of all source files"
      VERBATIM
  )

  add_custom_target(
      check-format
      COMMAND
      ! ${CLANG_FORMAT_GIT_LIST_MODIFIED} 
      | xargs -n 1 | ${CLANG_FORMAT_PATH}
      -style=file
      -output-replacements-xml
      | grep "<replacement " > /dev/null
      COMMENT "Checking format of modified git files."
      COMMAND
      ! ${CLANG_FORMAT_GIT_LIST_MODIFIED_STASHED} 
      | xargs -n 1 | ${CLANG_FORMAT_PATH}
      -style=file
      -output-replacements-xml
      | grep "<replacement " > /dev/null
      VERBATIM
  )

  add_custom_target(
      check-all-format
      COMMAND
      ! ${CLANG_FORMAT_FIND_COMAND} 
      | xargs -n 1 | ${CLANG_FORMAT_PATH}
      -style=file
      -output-replacements-xml
      | grep "<replacement " > /dev/null
      COMMENT "Checking format compliance of all source files"
      VERBATIM
  )
endif()


