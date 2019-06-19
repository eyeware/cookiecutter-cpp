
# Generate Version file for the project with some macros and functions
# for runtime version checks and static time checks.
configure_file (
  "${PROJECT_PUBLIC_INCLUDE_DIR}/${PROJECT_PREFIX}/Version.h.in"
  "${PROJECT_PUBLIC_INCLUDE_DIR}/${PROJECT_PREFIX}/Version.h"
)

configure_file (
  "${CMAKE_CURRENT_LIST_DIR}/Version.cpp.in"
  "${CMAKE_CURRENT_LIST_DIR}/Version.cpp"
)

practci_add_cpp_module(SOURCES Version.cpp
    INTERFACE_HEADERS Version.h
)
