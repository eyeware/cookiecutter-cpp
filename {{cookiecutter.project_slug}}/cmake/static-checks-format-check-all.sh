#!/bin/bash
# clang-format functions to use in project targets
# this is required to avoid limitations of shell escaping caracters in
# custom targets.
# FIXME: https://gitlab.kitware.com/cmake/cmake/issues/18062

CLANG_FORMAT_CPP_FILES_REGEX=".*\.(c|h|cpp|hpp|cxx)$"

! find -regextype posix-extended -regex ${CLANG_FORMAT_CPP_FILES_REGEX} \
-exec bash -c "clang-format -style=file -output-replacements-xml {} | grep -qE '<replacement offset=' " \; -print | \
grep ".*"
