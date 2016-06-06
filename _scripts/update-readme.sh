#!/bin/bash

# name of script, for output prefixing
NM="$(basename "$0")"
# http://stackoverflow.com/a/246128/962603 comments
DIR="$(dirname "$(readlink -f "$0")")"
GIT_DIR="$(readlink -f "$DIR/..")"
# file to write to
OUT="$GIT_DIR/index.md"

# -- functions -----------------------------------------------------------------

function write_header() {
  cat << 'EOF' > "$OUT"
---
layout: default
---
EOF
}

# -- logic ---------------------------------------------------------------------

# determine current branch, should be `gh-pages`
BRANCH="$(git symbolic-ref --short HEAD)"
if [ "$BRANCH" != "gh-pages" ]; then
  echo "$NM: can only be run from \`gh-pages\` branch."
  exit
fi

# check if there is a special checkout of the `master` branch
if [ "$(basename "$GIT_DIR")" != "Beamer-TUe" -a \
    -d "$GIT_DIR/../Beamer-TUe" ]; then
  cd "$GIT_DIR/../Beamer-TUe"
  BRANCH="$(git symbolic-ref --short HEAD)"
  if [ "$BRANCH" == "master" ]; then
    write_header
    cat README.md >> "$OUT"
    exit
  fi
fi

# checkout master branch, save README contents in memory and switch back
cd "$GIT_DIR"
git checkout master >/dev/null
if [ $? -ne 0 ]; then
  exit
fi
README=$(<README.md)
git checkout gh-pages >/dev/null
write_header
echo "$README" >> index.md
