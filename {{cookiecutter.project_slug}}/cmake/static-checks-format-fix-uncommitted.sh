# clang-format functions to use in project targets
# this is required to avoid limitations of shell escaping caracters in
# custom targets.
# FIXME: https://gitlab.kitware.com/cmake/cmake/issues/18062

CLANG_FORMAT_CPP_FILES_REGEX=".*\.(c|h|cpp|hpp|cxx)$"

{ git diff --name-only --diff-filter=ACMRT; git diff --name-only --diff-filter=ACRMT --cached; } | \ 
grep -E ${CLANG_FORMAT_CPP_FILES_REGEX} | \
xargs -n 1 clang-format -style=file -i
