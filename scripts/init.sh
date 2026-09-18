#!/usr/bin/env bash
# Interactive first-run setup: pick language, school, department, and a
# citation style, then write them into config.yml.
#
#   just init                 # interface language follows your system locale
#   TW_THESIS_LANG=en just init
#   TW_THESIS_LANG=zh just init
#
# Uses `gum` for a proper TUI when available -- auto-installed to
# ~/.local/bin on first run (no sudo, no system changes) for macOS/Linux;
# falls back to plain numbered prompts everywhere else, including Windows.
# Every question can be skipped (leaves that setting untouched).
#
# TW_THESIS_LANG only picks which language this SCRIPT talks to you in; the
# thesis document's own language is one of the four questions it asks.

set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
config="$root/config.yml"
schools_dir="$root/schools"
i18n_dir="$root/scripts/i18n"

ui_lang="${TW_THESIS_LANG:-}"
if [ -z "$ui_lang" ]; then
  case "${LC_ALL:-${LANG:-}}" in
    zh*) ui_lang="zh" ;;
    *) ui_lang="en" ;;
  esac
fi
[ -f "$i18n_dir/init.$ui_lang.sh" ] || ui_lang="en"
# shellcheck source=/dev/null
source "$i18n_dir/init.$ui_lang.sh"

# a pink -> purple gradient rule, matching gum/charm's own palette; only used
# when gum (and therefore a color-capable terminal) is already in play
gradient_rule() {
  local width=${1:-32} colors=(212 213 207 201 165 129 93) n=${#colors[@]}
  local out="" i c
  for ((i = 0; i < width; i++)); do
    c=${colors[i * n / width]}
    out+=$'\033[38;5;'"${c}m▀"
  done
  printf '%s\033[0m\n' "$out"
}

GUM_BIN="$HOME/.local/bin/gum"

find_gum() {
  if command -v gum > /dev/null 2>&1; then
    command -v gum
    return 0
  fi
  if [ -x "$GUM_BIN" ]; then
    echo "$GUM_BIN"
    return 0
  fi
  return 1
}

install_gum() {
  local os arch tag url tmp ext bin_name
  os=$(uname -s)
  arch=$(uname -m)
  case "$arch" in
    x86_64 | amd64) arch="x86_64" ;;
    arm64 | aarch64) arch="arm64" ;;
    i386 | i686) arch="i386" ;;
    *) return 1 ;; # unrecognized arch: fall back to plain prompts
  esac
  case "$os" in
    Darwin | Linux) ext="tar.gz" ;;
    # git-bash/MSYS2/Cygwin: the only way this script runs on Windows at all
    MINGW* | MSYS* | CYGWIN*) os="Windows" ext="zip" ;;
    *) return 1 ;; # native cmd/PowerShell etc.: use the plain prompts instead
  esac
  bin_name="gum"
  [ "$os" = "Windows" ] && bin_name="gum.exe" && GUM_BIN="${GUM_BIN}.exe"
  # capture the full response before parsing it -- piping straight into a
  # command that exits early (grep -m1, head) races pipefail against curl
  # and reports a bogus failure once the reader closes the pipe underneath it
  local resp
  resp=$(curl -fsSL https://api.github.com/repos/charmbracelet/gum/releases/latest) || return 1
  tag=$(printf '%s' "$resp" | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
  [ -n "$tag" ] || return 1
  url="https://github.com/charmbracelet/gum/releases/download/v${tag}/gum_${tag}_${os}_${arch}.${ext}"
  tmp=$(mktemp -d)
  if ! curl -fsSL "$url" -o "$tmp/gum.$ext"; then
    rm -rf "$tmp"
    return 1
  fi
  # `tar` extracts both .tar.gz and .zip on modern macOS/Linux/git-bash (bsdtar)
  if ! tar -xf "$tmp/gum.$ext" -C "$tmp"; then
    rm -rf "$tmp"
    return 1
  fi
  mkdir -p "$HOME/.local/bin"
  find "$tmp" -type f -name "$bin_name" -exec cp {} "$GUM_BIN" \;
  chmod +x "$GUM_BIN" 2> /dev/null || true
  rm -rf "$tmp"
  [ -x "$GUM_BIN" ]
}

gum=""
if gum="$(find_gum)"; then
  :
else
  echo "$MSG_INSTALLING_GUM" >&2
  if install_gum; then
    gum="$GUM_BIN"
  else
    echo "$MSG_GUM_FAILED" >&2
  fi
fi

if [ -n "$gum" ]; then
  gradient_rule 44
  "$gum" style --border rounded --border-foreground 212 --padding "1 2" --margin "0" --bold --align center --width 40 "$MSG_BANNER_TITLE"
  gradient_rule 44
  echo
  "$gum" style --faint "$MSG_BANNER_BODY"
  echo
else
  echo "== $MSG_BANNER_TITLE =="
  echo "$MSG_BANNER_BODY"
  echo
fi

# schools/*.yml (minus default.yml) -> parallel arrays of code and "university (code)",
# using the English name when the interface language is English
codes=()
labels=()
uni_key="university"
[ "$ui_lang" = "en" ] && uni_key="university-en"
for f in "$schools_dir"/*.yml; do
  [ "$(basename "$f")" = "default.yml" ] && continue
  code=$(basename "$f" .yml)
  uni=$(sed -n "s/^${uni_key}: *\"\\(.*\\)\"/\\1/p" "$f" | head -1)
  codes+=("$code")
  labels+=("$uni ($code)")
done
labels+=("$SKIP")

cite_values=("apa" "harvard-cite-them-right" "chicago-author-date" "mla" "ieee" "vancouver")
cite_labels=("${CITE_LABELS[@]}" "$SKIP")

school=""
language=""
institute=""
style=""

if [ -n "$gum" ]; then
  lang_choice=$("$gum" choose "中文 (chinese)" "英文 (english)" "$SKIP" --header "$MSG_LANG_HEADER" || true)
  case "$lang_choice" in
    "中文 (chinese)") language=chinese ;;
    "英文 (english)") language=english ;;
    *) language="" ;;
  esac

  school_choice=$("$gum" choose "${labels[@]}" --header "$MSG_SCHOOL_HEADER" || true)
  for i in "${!codes[@]}"; do
    [ "${labels[$i]}" = "$school_choice" ] && school="${codes[$i]}"
  done

  institute=$("$gum" input --header "$MSG_INSTITUTE_HEADER" --placeholder "$MSG_INSTITUTE_PLACEHOLDER" || true)

  cite_choice=$("$gum" choose "${cite_labels[@]}" --header "$MSG_CITE_HEADER" || true)
  for i in "${!cite_values[@]}"; do
    [ "${cite_labels[$i]}" = "$cite_choice" ] && style="${cite_values[$i]}"
  done
else
  echo "== $MSG_LANG_HEADER =="
  select opt in "中文 (chinese)" "英文 (english)" "$SKIP"; do
    case "${opt:-}" in
      "中文 (chinese)") language=chinese ;;
      "英文 (english)") language=english ;;
      "$SKIP") language="" ;;
      *) continue ;;
    esac
    break
  done

  echo "== $MSG_SCHOOL_HEADER =="
  select opt in "${labels[@]}"; do
    [ -n "${opt:-}" ] || continue
    for i in "${!codes[@]}"; do
      [ "${labels[$i]}" = "$opt" ] && school="${codes[$i]}"
    done
    break
  done

  read -rp "$MSG_INSTITUTE_HEADER: " institute

  echo "== $MSG_CITE_HEADER =="
  select opt in "${cite_labels[@]}"; do
    [ -n "${opt:-}" ] || continue
    for i in "${!cite_values[@]}"; do
      [ "${cite_labels[$i]}" = "$opt" ] && style="${cite_values[$i]}"
    done
    break
  done
fi

# feedback tailored to what was actually picked, not a generic "OK"
fb=""
if [ -n "$language" ]; then
  if [ "$language" = "chinese" ]; then
    fb="$fb$MSG_FB_LANG_ZH
"
  else
    fb="$fb$MSG_FB_LANG_EN
"
  fi
else
  fb="$fb$MSG_FB_LANG_SKIP
"
fi

if [ -n "$school" ]; then
  uni=""
  for i in "${!codes[@]}"; do
    [ "${codes[$i]}" = "$school" ] && uni="${labels[$i]%% (*}"
  done
  # shellcheck disable=SC2059 # MSG_FB_SCHOOL is a trusted local format string
  fb="$fb$(printf "$MSG_FB_SCHOOL" "$uni" "$school")
"
else
  fb="$fb$MSG_FB_SCHOOL_SKIP
"
fi

if [ -n "$institute" ]; then
  fb="$fb$(printf "$MSG_FB_INSTITUTE" "$institute")
"
else
  fb="$fb$MSG_FB_INSTITUTE_SKIP
"
fi

if [ -n "$style" ]; then
  cite_note=""
  for i in "${!cite_values[@]}"; do
    [ "${cite_values[$i]}" = "$style" ] && cite_note="${cite_labels[$i]}"
  done
  fb="$fb$(printf "$MSG_FB_STYLE" "$cite_note")"
else
  fb="$fb$MSG_FB_STYLE_SKIP"
fi

if [ -n "$gum" ]; then
  "$gum" style --border rounded --border-foreground 212 --padding "0 2" --margin "1 0" "$fb"
else
  echo
  echo "$fb"
  echo
fi

tmp="$config.tmp"
awk -v school="$school" -v language="$language" -v institute="$institute" -v style="$style" '
BEGIN { in_layout = 0; in_bib = 0; wrote_lang = 0; wrote_style = 0 }
school != "" && /^#?[[:space:]]*school:/ {
  print "school: \"" school "\" # pick one of schools/*.yml; without it the format defaults apply"
  next
}
institute != "" && /^institute: / { print "institute: \"" institute "\""; next }
/^layout:/ { print; in_layout = 1; next }
language != "" && in_layout && /^  language:/ {
  print "  language: \"" language "\" # chinese | english"
  wrote_lang = 1
  next
}
in_layout && /^[^[:space:]]/ {
  if (language != "" && !wrote_lang) {
    print "  language: \"" language "\" # chinese | english"
    wrote_lang = 1
  }
  in_layout = 0
}
/^bibliography:/ { print; in_bib = 1; next }
style != "" && in_bib && /^  style:/ {
  print "  style: \"" style "\" # see the citation-style table in chapter 4"
  wrote_style = 1
  next
}
in_bib && /^[^[:space:]]/ {
  if (style != "" && !wrote_style) {
    print "  style: \"" style "\" # see the citation-style table in chapter 4"
    wrote_style = 1
  }
  in_bib = 0
}
{ print }
END {
  if (in_layout && language != "" && !wrote_lang) print "  language: \"" language "\" # chinese | english"
  if (in_bib && style != "" && !wrote_style) print "  style: \"" style "\" # see the citation-style table in chapter 4"
}
' "$config" > "$tmp"
mv "$tmp" "$config"

if [ -n "$gum" ]; then
  gradient_rule 44
  "$gum" style --foreground 212 --bold "$MSG_DONE"
  echo
  "$gum" style --border rounded --border-foreground 244 --padding "0 2" --margin "0 0 1 0" --width 70 \
    "$("$gum" style --bold --foreground 212 "$MSG_FIRST_TIME_HEADER"; echo; echo "$MSG_FIRST_TIME_BODY")"
  gradient_rule 44
else
  echo "$MSG_DONE"
  echo
  echo "$MSG_FIRST_TIME_HEADER"
  echo "$MSG_FIRST_TIME_BODY"
fi
