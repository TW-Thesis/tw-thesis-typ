#!/usr/bin/env bash
# Keep main.typ and the content files consistent, so writing a thesis never
# means bookkeeping:
#
#   * an #include whose file was deleted is dropped (typst treats a missing
#     include as a hard error)
#   * a content file that does not import helper/mod.typ gets the import back,
#     otherwise #fig(), #tlt() and friends would be undefined
#
#   scripts/sync.sh          # fix both
#   scripts/sync.sh --check  # report only, exit 1 if anything is out of sync
set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
main="$root/main.typ"
helper='#import "/helper/mod.typ": *'
check=${1:-}
issues=0

# 1. includes pointing at files that are gone
while IFS= read -r path; do
  [ -n "$path" ] || continue
  [ -e "$root/$path" ] && continue
  issues=$((issues + 1))
  if [ "$check" = "--check" ]; then
    echo "sync: $path is gone but still included"
  else
    grep -v -x -F "#include \"$path\"" "$main" > "$main.tmp"
    mv "$main.tmp" "$main"
    echo "sync: dropped #include \"$path\" (file is gone)"
  fi
done < <(sed -n 's/^#include "\(.*\)".*/\1/p' "$main")

# 2. content files that lost their import line
while IFS= read -r path; do
  [ -n "$path" ] || continue
  file="$root/$path"
  [ -e "$file" ] || continue
  # anchored: a sample import inside a listing is indented, not at column 0
  grep -q '^#import "/helper/mod.typ"' "$file" && continue
  issues=$((issues + 1))
  if [ "$check" = "--check" ]; then
    echo "sync: $path does not import helper/mod.typ"
  else
    # drop leading blank lines so the import is followed by exactly one
    printf '%s\n\n%s\n' "$helper" "$(sed '/./,$!d' "$file")" > "$file.tmp"
    mv "$file.tmp" "$file"
    echo "sync: added the helper import to $path"
  fi
done < <(sed -n 's/^#include "\(.*\)".*/\1/p' "$main")

[ "$check" = "--check" ] && [ "$issues" -gt 0 ] && exit 1
exit 0
