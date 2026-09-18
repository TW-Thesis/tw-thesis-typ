# English strings for scripts/init.sh.
# Keep the same variable names as init.zh.sh -- init.sh sources whichever
# file matches TW_THESIS_LANG (or the detected system locale).

SKIP="Skip, leave unchanged"

MSG_INSTALLING_GUM="First run -- installing gum for a nicer interface (to ~/.local/bin, no sudo, no system changes)..."
MSG_GUM_FAILED="Could not install gum -- falling back to plain text menus, still works fine"

MSG_BANNER_TITLE="tw-thesis-typ setup"
MSG_BANNER_BODY="Four questions: thesis language, school, department, citation style.
Any question can be skipped (\"$SKIP\") if you're not sure yet -- rerun \`just init\` anytime, or edit config.yml directly."

MSG_LANG_HEADER="Thesis language"
MSG_SCHOOL_HEADER="School (type to filter)"
MSG_INSTITUTE_HEADER="Department name (e.g. Department of Computer Science, leave blank to skip)"
MSG_INSTITUTE_PLACEHOLDER="Department of ..."
MSG_CITE_HEADER="Citation style"

CITE_LABELS=(
  "APA -- psychology, education, social sciences"
  "Harvard -- business, social sciences"
  "Chicago -- history, humanities"
  "MLA -- literature, languages, the arts"
  "IEEE -- computer science, EE, engineering"
  "Vancouver -- medicine, nursing"
)

MSG_FB_LANG_ZH="-> Language: Chinese (the default for most Taiwanese schools)"
MSG_FB_LANG_EN="-> Language: English (check that each chapter's examples are switched to English too)"
MSG_FB_LANG_SKIP="-> Language: skipped, current setting kept"
MSG_FB_SCHOOL="-> School: %s (applies the format rules in schools/%s.yml)"
MSG_FB_SCHOOL_SKIP="-> School: skipped, generic formatting applies (no specific school's rules)"
MSG_FB_INSTITUTE="-> Department: %s"
MSG_FB_INSTITUTE_SKIP="-> Department: skipped, left as a placeholder for you to fill in"
MSG_FB_STYLE="-> Citation style: %s"
MSG_FB_STYLE_SKIP="-> Citation style: skipped, current setting kept"

MSG_DONE="config.yml updated -- run \`just compile\` to see it; edit config.yml directly for anything else (title, author, advisor, ...)."

MSG_FIRST_TIME_HEADER="New to Typst or LaTeX?"
MSG_FIRST_TIME_BODY="Worth 15 minutes before you start editing chapters:
  Typst's own tutorial (starts from zero, no LaTeX needed): https://typst.app/docs/tutorial/
  Typst for LaTeX users: https://typst.app/docs/guides/guide-for-latex-users/
This template's own walkthrough lives in contents/chapter01.typ ~ chapter04.typ -- the compiled main.pdf is itself a chapter-by-chapter demo; copying its examples is the fastest way in."
