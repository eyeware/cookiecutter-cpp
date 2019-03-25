#!/bin/bash
# clang-format functions to use in project targets
# this is required to avoid limitations of shell escaping caracters in
# custom targets.
# FIXME: https://gitlab.kitware.com/cmake/cmake/issues/18062

set -x

CLANG_CPP_FILES_REGEX=".*\.(c|h|cpp|hpp|cxx)$"

CLANG_TIDY_CONFIG=".clang-tidy-identifier-naming"

STATIC_CHECK_COMMAND="clang-tidy -config=\"$(cat $CLANG_TIDY_CONFIG)\" {} -- {}"


! find -regextype posix-extended -regex "${CLANG_CPP_FILES_REGEX}" \
-exec bash -c "clang-tidy -config=\"$(cat $CLANG_TIDY_CONFIG)\" {} -- {}" \; | \
grep ".*"
