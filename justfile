typst := "typst"
main := "main.typ"
output := "main.pdf"
fonts := "fonts/"

# watermark is off unless this is passed
release_flag := "--input watermark=true"

# `just compile` when nothing else is specified
default: compile

# draft, no watermark
compile:
    {{ typst }} compile {{ main }} --font-path {{ fonts }}

# final, with watermark
release:
    {{ typst }} compile {{ main }} --font-path {{ fonts }} {{ release_flag }}

watch:
    {{ typst }} watch {{ main }} --font-path {{ fonts }}

watch-release:
    {{ typst }} watch {{ main }} --font-path {{ fonts }} {{ release_flag }}

clean:
    rm -f {{ output }}
