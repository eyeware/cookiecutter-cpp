# static check targets

# Add clang-format custom targets.
# Assumes git is being used.

set(STATIC_CHECK_PROGRAMS 
  clang-format
#  clang-tidy
)

foreach(STATIC_CHECK_PROGRAM IN LISTS STATIC_CHECK_PROGRAMS)
  find_program(STATIC_CHECK_PROGRAM_PATH ${STATIC_CHECK_PROGRAM})

  if(NOT STATIC_CHECK_PROGRAM_PATH)
    message(WARNING "${STATIC_CHECK_PROGRAM}: not found!")
  endif()
endforeach()

# clang-format

set(STATIC_CHECK_FORMAT_TARGETS
  format-check-uncommitted
  format-check-all
  format-fix-uncommitted 
  format-fix-all
)

set(STATIC_CHECK_FORMAT_TARGETS_COMMENT
  "Check formating and list uncommitted git files violating style check."
  "Check formating and list all files violating style check."
  "Fix formatting in uncommitted git source files."
  "Fix formatting in all source files."
)

# clang-tidy

set(STATIC_CHECK_NAMING_TARGETS
#  naming-check-uncommitted
#  naming-check-all
#  naming-fix-uncommitted a
#  naming-fix-all
  ""
)

set(STATIC_CHECK_NAMING_TARGETS_COMMENT
#  "Check and list identifier naming issues in uncommitted git files."
#  "Check and list identifier naming issues in all files."
#  "Fix identifier naming issues in uncommitted git files."
#  "Fix identifier naming issues in all files."
  ""
)

set(STATIC_CHECK_TARGETS "")
set(STATIC_CHECK_TARGETS_COMMENT "")

list(APPEND STATIC_CHECK_TARGETS ${STATIC_CHECK_FORMAT_TARGETS})
list(APPEND STATIC_CHECK_TARGETS_COMMENT ${STATIC_CHECK_FORMAT_TARGETS_COMMENT})


list(APPEND STATIC_CHECK_TARGETS ${STATIC_CHECK_NAMING_TARGETS})
list(APPEND STATIC_CHECK_TARGETS_COMMENT ${STATIC_CHECK_NAMING_TARGETS_COMMENT})


list(LENGTH STATIC_CHECK_TARGETS STATIC_CHECK_TARGETS_LENGTH)
math(EXPR STATIC_CHECK_TARGETS_LENGTH1 "${STATIC_CHECK_TARGETS_LENGTH} - 1")

foreach(index RANGE ${STATIC_CHECK_TARGETS_LENGTH1})
  list(GET STATIC_CHECK_TARGETS ${index} STATIC_CHECK_TARGET)
  list(GET STATIC_CHECK_TARGETS_COMMENT ${index} STATIC_CHECK_TARGET_COMMENT)

  add_custom_target(
      ${STATIC_CHECK_TARGET}
      COMMAND
      ${CMAKE_CURRENT_LIST_DIR}/clang-format-${CLANG_FORMAT_TARGET}.sh
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      COMMENT ${STATIC_CHECK_TARGET_COMMENT}
  )
endforeach()


