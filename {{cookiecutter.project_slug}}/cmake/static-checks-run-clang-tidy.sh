#!/bin/bash
# Wrapper script, that forces -1 result if theres any check that fails 

FIND_PROGRAM_NAMES=(run-clang-tidy-6.0.py)

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

PARAMS=""
JUNIT=""
JUNIT_SRC_ROOT=""

while (( "$#" )); do
  case "$1" in
    -junit)
      JUNIT=$2
      shift 2
      ;;
    -junit-src-root)
      JUNIT_SRC_ROOT=$2
      shift 2
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done

# set positional arguments in their proper place
eval set -- "$PARAMS"

if [ -z "$JUNIT" ]; then
  ! $FIND_PROGRAM_NAME_PATH "$@" 2>/dev/null | grep -E '\[([a-z]|-)+\]$'
else
  $FIND_PROGRAM_NAME_PATH "$@" 2>/dev/null | clang-tidy-to-junit.py ${JUNIT_SRC_ROOT} > ${JUNIT}
fi
