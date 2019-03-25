#!/bin/bash
# clang-format functions to use in project targets
# this is required to avoid limitations of shell escaping caracters in
# custom targets.
# FIXME: https://gitlab.kitware.com/cmake/cmake/issues/18062

CLANG_CPP_FILES_REGEX=".*\.(c|h|cpp|hpp|cxx)$"

CLANG_TIDY_CONFIG=".clang-tidy-identifier-naming"

STATIC_CHECK_COMMAND="clang-tidy -fix -config=\"$(cat $CLANG_TIDY_CONFIG)\" {} -- {}"

echo $STATIC_CHECK_COMMAND

find -regextype posix-extended -regex ${CLANG_CPP_FILES_REGEX} \
-exec $STATIC_CHECK_COMMAND \;
