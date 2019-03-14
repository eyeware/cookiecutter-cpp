# clang-format functions to use in project targets
# this is required to avoid limitations of shell escaping caracters in
# custom targets.
# FIXME: https://gitlab.kitware.com/cmake/cmake/issues/18062

CLANG_FORMAT_CPP_FILES_REGEX=".*\.(c|h|cpp|hpp|cxx)$"

tempfile=$(mktemp)
{ git diff --name-only --diff-filter=ACMRT; git diff --name-only --diff-filter=ACRMT --cached; } | \
grep -E ${CLANG_FORMAT_CPP_FILES_REGEX} | \
xargs -n 1 -i bash -c "clang-format -style=file -output-replacements-xml {} | grep -qE '<replacement offset=' && echo {} > $tempfile"
cat $tempfile | grep ".*"
exitcode=$?
rm $tempfile
test $exitcode -eq 1
