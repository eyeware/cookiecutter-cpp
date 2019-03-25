#!/bin/bash
# clang-format functions to use in project targets
# this is required to avoid limitations of shell escaping caracters in
# custom targets.
# FIXME: https://gitlab.kitware.com/cmake/cmake/issues/18062

CLANG_CPP_FILES_REGEX=".*\.(c|h|cpp|hpp|cxx)$"

CLANG_TIDY_CONFIG=".clang-tidy-identifier-naming"

STATIC_CHECK_COMMAND="clang-tidy -config=\"$(cat $CLANG_TIDY_CONFIG)\" {} -- {}"

! { git diff --name-only --diff-filter=ACMRT; git diff --name-only --diff-filter=ACRMT --cached; } | \
grep -E ${CLANG_CPP_FILES_REGEX} | \
xargs -I{} -n 1 clang-tidy -config=\"$(cat $CLANG_TIDY_CONFIG)\" {} -- {} | grep ".*"

