#!/bin/bash
# clang-format functions to use in project targets
# this is required to avoid limitations of shell escaping caracters in
# custom targets.
# FIXME: https://gitlab.kitware.com/cmake/cmake/issues/18062

CLANG_FORMAT_NAMES=(clang-format-6.0 clang-format-5.0 clang-format)

for CLANG_FORMAT_NAME in "${CLANG_FORMAT_NAMES[@]}"
do
  CLANG_FORMAT_PATH=$(which $CLANG_FORMAT_NAME)
  if [ -n "$CLANG_FORMAT_PATH" ]; then
    break
  fi
done

CLANG_FORMAT_CPP_FILES_REGEX=".*\.(c|h|cpp|hpp|cxx)$"

! find -regextype posix-extended -regex ${CLANG_FORMAT_CPP_FILES_REGEX} \
-exec bash -c "$CLANG_FORMAT_PATH -style=file -output-replacements-xml {} | grep -qE '<replacement offset=' " \; -print | \
grep ".*"
