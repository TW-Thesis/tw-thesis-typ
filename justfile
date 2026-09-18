typst := "typst"
main := "main.typ"
output := "main.pdf"
fonts := "fonts/"

# watermark is off unless this is passed
release_flag := "--input watermark=true"

# `just compile` when nothing else is specified
default: compile

# tidies main.typ and the content files before compiling
sync:
    @scripts/sync.sh

# interactive first-run setup: language, school, department, citation style
# interface language follows your system locale; override with TW_THESIS_LANG=en/zh
init:
    @scripts/init.sh

# draft, no watermark
compile: sync
    {{ typst }} compile {{ main }} --font-path {{ fonts }}

# final, with watermark
release: sync
    {{ typst }} compile {{ main }} --font-path {{ fonts }} {{ release_flag }}

watch: sync
    {{ typst }} watch {{ main }} --font-path {{ fonts }}

watch-release: sync
    {{ typst }} watch {{ main }} --font-path {{ fonts }} {{ release_flag }}

# adds contents/chapterNN.typ and its #include in main.typ
# `just chapter`, `just chapter 3`, `just chapter 1 研究方法`
chapter N="1" TITLE="":
    scripts/new-chapter.sh "{{ N }}" "{{ TITLE }}"

clean:
    rm -f {{ output }}

# Fetch the latest official school-format regulations into docs/.
#
#   just update              # check every school
#   just update ntu nccu     # only these
#   just update --dry-run    # report without writing
#
# Prefers a sandboxed Python via uv (installed to ~/.local/bin on first run,
# never touches system Python or requires sudo); falls back to Node.js only
# if that install fails and node is already on PATH.
update *ARGS:
    #!/usr/bin/env bash
    set -euo pipefail

    uv="$(command -v uv || true)"
    if [ -z "$uv" ] && [ -x "$HOME/.local/bin/uv" ]; then
        uv="$HOME/.local/bin/uv"
    fi

    if [ -z "$uv" ]; then
        echo "uv not found -- installing it to ~/.local/bin (no sudo, no system changes)" >&2
        if curl -LsSf https://astral.sh/uv/install.sh | sh; then
            uv="$HOME/.local/bin/uv"
        fi
    fi

    if [ -n "$uv" ] && [ -x "$uv" ]; then
        cd scripts/python && "$uv" run update_docs.py {{ ARGS }}
    elif command -v node >/dev/null 2>&1; then
        echo "uv unavailable -- falling back to the Node.js version" >&2
        cd scripts/nodeJS && npm install --silent && node update-docs.mjs {{ ARGS }}
    else
        echo "Need either uv (auto-install failed -- check your network) or Node.js on PATH." >&2
        exit 1
    fi
