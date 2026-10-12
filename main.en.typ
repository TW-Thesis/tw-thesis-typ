// The English tutorial as a document of its own, with English prefixes (Figure,
// Table, Chapter, Section). Build it with `just compile-en`, which passes
// `--input config=/contents/i18n/en/config.yml`. Your thesis is built from
// main.typ; this file is not part of it.
#import "helper/mod.typ": *

#show: thesis

#set heading(numbering: "1.1")
#include "contents/i18n/en/chapter01.typ"
#include "contents/i18n/en/chapter02.typ"
#include "contents/i18n/en/chapter03.typ"
#include "contents/i18n/en/chapter04.typ"

#references()
