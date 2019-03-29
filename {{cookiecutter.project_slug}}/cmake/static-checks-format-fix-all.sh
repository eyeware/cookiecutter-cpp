#!/bin/bash
# clang-format functions to use in project targets
# this is required to avoid limitations of shell escaping caracters in
# custom targets.
# FIXME: https://gitlab.kitware.com/cmake/cmake/issues/18062

FIND_PROGRAM_NAMES=(clang-format-6.0 clang-format-5.0 clang-format)

for FIND_PROGRAM_NAME in "${FIND_PROGRAM_NAMES[@]}"
do
  FIND_PROGRAM_NAME_PATH=$(which $FIND_PROGRAM_NAME)
  if [ -n "$FIND_PROGRAM_NAME_PATH" ]; then
    break
  fi
done

if [ -z "$FIND_PROGRAM_NAME_PATH" ]; then
  echo "Program with names ${FIND_PROGRAM_NAMES[@]} not found!"
  exit -1
fi

CLANG_FORMAT_CPP_FILES_REGEX=".*\.(c|h|cpp|hpp|cxx)$"

find -regextype posix-extended -regex ${CLANG_FORMAT_CPP_FILES_REGEX} \
-exec $FIND_PROGRAM_NAME_PATH -style=file -i {} \;
