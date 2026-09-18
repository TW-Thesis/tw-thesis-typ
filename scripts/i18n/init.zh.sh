# Traditional Chinese strings for scripts/init.sh.
# Keep the same variable names as init.en.sh -- init.sh sources whichever
# file matches TW_THESIS_LANG (or the detected system locale).

SKIP="略過，不修改"

MSG_INSTALLING_GUM="首次執行，正在安裝 gum 讓介面更好用（裝到 ~/.local/bin，不需要 sudo，也不會動到系統）..."
MSG_GUM_FAILED="gum 安裝不了，改用文字選單，一樣可以設定"

MSG_BANNER_TITLE="tw-thesis-typ 初始設定"
MSG_BANNER_BODY="接下來會問四個問題：論文語言、學校、系所名稱、參考文獻格式。
每一題都可以選「${SKIP}」略過，不確定的話先跳過，之後隨時能重跑 \`just init\` 或直接編輯 config.yml。"

MSG_LANG_HEADER="論文語言"
MSG_SCHOOL_HEADER="學校（輸入關鍵字可以篩選）"
MSG_INSTITUTE_HEADER="系所名稱（例如：資訊工程學系，留空略過）"
MSG_INSTITUTE_PLACEHOLDER="○○學系"
MSG_CITE_HEADER="參考文獻格式"

CITE_LABELS=(
  "APA -- 心理、教育、社會科學"
  "Harvard -- 商管、社會科學"
  "Chicago -- 歷史、人文"
  "MLA -- 文學、語言、藝術"
  "IEEE -- 資工、電機、工程"
  "Vancouver -- 醫學、護理"
)

MSG_FB_LANG_ZH="→ 語言：中文（大多數台灣學校的預設）"
MSG_FB_LANG_EN="→ 語言：英文（記得檢查各章範例是否也要換成英文）"
MSG_FB_LANG_SKIP="→ 語言：略過，沿用目前設定"
MSG_FB_SCHOOL="→ 學校：%s（套用 schools/%s.yml 的格式規則）"
MSG_FB_SCHOOL_SKIP="→ 學校：略過，套用通用格式（不特別符合任何學校規定）"
MSG_FB_INSTITUTE="→ 系所：%s"
MSG_FB_INSTITUTE_SKIP="→ 系所：略過，保留「○○學系」等你填"
MSG_FB_STYLE="→ 參考文獻格式：%s"
MSG_FB_STYLE_SKIP="→ 參考文獻格式：略過，沿用目前設定"

MSG_DONE="已寫入 config.yml，執行 \`just compile\` 看結果；想改其他項目（標題、作者、指導教授等）請直接編輯 config.yml。"

MSG_FIRST_TIME_HEADER="第一次用 Typst 或 LaTeX？"
MSG_FIRST_TIME_BODY="建議先花 15 分鐘讀過官方教學，之後編輯章節會順很多：
  Typst 官方教學（從零開始，不用先會 LaTeX）：https://typst.app/docs/tutorial/
  給 LaTeX 使用者的 Typst 對照：https://typst.app/docs/guides/guide-for-latex-users/
本模板自己的教學也直接寫在 contents/chapter01.typ ~ chapter04.typ 裡，編譯出的 main.pdf 本身就是逐章示範，照著範例改最快。"
