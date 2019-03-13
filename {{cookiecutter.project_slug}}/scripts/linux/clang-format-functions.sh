# clang-format functions to use in project targets
# this is required to avoid limitations of shell escaping caracters in
# custom targets.
# FIXME: https://gitlab.kitware.com/cmake/cmake/issues/18062


CLANG_FORMAT_PATH=$(which clang-format)

CLANG_FORMAT_CPP_FILES_REGEX=".*\.(c|h|cpp|hpp|cxx)$"

CLANG_FORMAT_FIND_COMAND="find . -regextype posix-extended -regex \
${CLANG_FORMAT_CPP_FILES_REGEX}"


format () {
  { git diff --name-only --diff-filter=ACMRT; git diff --name-only --diff-filter=ACRMT --cached; } | grep -E ${CLANG_FORMAT_CPP_FILES_REGEX} | \
  xargs -n 1 ${CLANG_FORMAT_PATH} -i -style=file
}


format-all () {
  ${CLANG_FORMAT_FIND_COMAND} | \
  xargs -n 1 ${CLANG_FORMAT_PATH} -i -style=file
}

check-format () {
  !   { git diff --name-only --diff-filter=ACMRT; git diff --name-only --diff-filter=ACRMT --cached; } | grep -E ${CLANG_FORMAT_CPP_FILES_REGEX} | \
  xargs -n 1 ${CLANG_FORMAT_PATH} -style=file -output-replacements-xml | \
  grep "<replacement " > /dev/null
}

check-all-format () {
  ! ${CLANG_FORMAT_FIND_COMAND} | \
  xargs -n 1 ${CLANG_FORMAT_PATH} -style=file -output-replacements-xml | \
  grep "<replacement " > /dev/null
}
