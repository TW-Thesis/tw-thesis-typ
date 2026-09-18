#!/usr/bin/env bash
# Create the next chapter file(s) under contents/ and include them from main.typ.
#
#   scripts/new-chapter.sh              # one chapter, untitled
#   scripts/new-chapter.sh 3            # three chapters at once
#   scripts/new-chapter.sh 1 研究方法    # one chapter with a title
#
# Driven by `just chapter`; existing files are never overwritten.

set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
contents="$root/contents"
main="$root/main.typ"

count=${1:-1}
title=${2:-}

if ! [[ $count =~ ^[0-9]+$ ]] || [ "$count" -lt 1 ]; then
  echo "new-chapter: N must be a positive integer, got '$count'" >&2
  exit 1
fi

# highest chapterNN.typ that already exists
last=0
for f in "$contents"/chapter[0-9][0-9].typ; do
  [ -e "$f" ] || continue
  n=$(basename "$f" .typ)
  n=${n#chapter}
  n=$((10#$n))
  [ "$n" -gt "$last" ] && last=$n
done

for i in $(seq 1 "$count"); do
  num=$(printf "%02d" $((last + i)))
  file="$contents/chapter$num.typ"
  if [ -e "$file" ]; then
    echo "new-chapter: $file exists, skipped"
    continue
  fi

  heading=${title:-章標題}
  [ "$count" -gt 1 ] && heading="章標題"

  cat > "$file" <<TYP
#import "/helper/mod.typ": *

= $heading

== 節標題

內文。
TYP

  # include it right after the last chapter include already in main.typ
  inc="#include \"contents/chapter$num.typ\""
  at=$(grep -n '^#include "contents/chapter[0-9][0-9]*\.typ"' "$main" | tail -1 | cut -d: -f1)
  if [ -z "$at" ]; then
    echo "new-chapter: no chapter include found in main.typ; add $inc yourself" >&2
  else
    awk -v inc="$inc" -v at="$at" 'NR == at { print; print inc; next } { print }' \
      "$main" > "$main.tmp" && mv "$main.tmp" "$main"
  fi

  echo "new-chapter: contents/chapter$num.typ + include in main.typ"
done
