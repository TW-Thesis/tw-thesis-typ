typst := "typst"
main := "main.typ"
main_en := "main.en.typ"
output_en := "main.en.pdf"
config_en := "config=/contents/i18n/en/config.yml"
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

# the English tutorial, with English prefixes (Figure, Table, Chapter, Section)
compile-en:
    {{ typst }} compile {{ main_en }} --font-path {{ fonts }} --input {{ config_en }}

watch-en:
    {{ typst }} watch {{ main_en }} --font-path {{ fonts }} --input {{ config_en }}

clean:
    rm -f {{ output }} {{ output_en }}
