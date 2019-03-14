find_program(IWYU_PATH iwyu)

if(NOT IWYU_PATH)
  message(WARNING "iwyu: not found!")
  message(WARNING "iwyu: not checking for includes.")
else()
  set(CMAKE_CXX_INCLUDE_WHAT_YOU_USE="${IWYU_PATH};--transitive_includes_only")
endif()



