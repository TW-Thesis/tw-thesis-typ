#import "/helper/mod.typ": *

= 文獻、程式碼與附錄

本章接續說明文獻引用、程式碼與附錄的寫法。各節範例互不依賴，需要哪個就照抄哪段，再換成自己論文的資料即可。

文獻與附錄的檔案放在 `contents/back/`，其餘範例可以直接寫進本章。搬動或修改內容時，記得同步更新 `main.typ` 裡對應的引用位置，以免參考文獻或附錄的順序跑掉。

== 引用文獻

`.bib` 是以 #bibtex 格式儲存的純文字文獻資料庫，一筆文獻對應一個條目，格式是 `@類型{識別名稱, 欄位 = {值}, ...}`。`contents/back/references.bib` 已經收錄幾筆範例，其中一筆長這樣：

#code[
  ```
  @inproceedings{kocher99,
    author =       {C. Kocher and J. Jaffe and B. Jun},
    title =        {Differential Power Analysis},
    editor =       {M. Wiener},
    booktitle =    {Advances in Cryptology ({CRYPTO}~'99)},
    series =       {Lecture Notes in Computer Science},
    volume =       1666,
    pages =        {388-397},
    publisher =    {Springer-Verlag},
    month =        {August},
    year =         1999
  }
  ```
]

`@inproceedings` 是文獻類型（研討會論文），常見的還有 `@article`（期刊論文）、`@book`（書籍）、`@incollection`（專書篇章）等，類型會影響參考文獻頁該顯示哪些欄位。`kocher99` 是識別名稱，用來在內文引用這筆文獻，同一份 `.bib` 裡不能重複；後面的 `author`、`title`、`year` 等則是這筆文獻的資料，逐欄填入即可，順序不影響排版結果。

Google Scholar 每筆搜尋結果下方的「引用」按鈕，彈出視窗最下面就有 #bibtex 連結，點開即可複製整個條目；圖書館資料庫（如 IEEE Xplore、ACM Digital Library）的文獻頁面也大多有「Export Citation」或「Cite」功能，選 #bibtex 格式匯出。若平常使用 Zotero、EndNote 等文獻管理軟體，同樣可以直接匯出 `.bib` 檔。拿到條目後貼進 `references.bib`，把識別名稱改成自己好記的名字（例如 `作者姓+年份`），再確認沒有跟既有條目重複即可。

文獻資料準備好後，回到章節檔案，使用相同的識別名稱引用。若要把文獻放在句尾，可以使用 `cp()`；若要把作者寫進句子，則使用 `c()`。以下也列出只顯示作者或年份的寫法，可以依句子需要選用。

#code[
  ```typ
  #cp("kocher99")   // \citep，括號引用
  #c("kocher99")    // \citet，行文引用
  #ca("kocher99")   // \citeauthor，只要作者
  #cy("kocher99")   // \citeyear，只要年份
  ```
]

四個函式編譯後的差異如下，請先對照確認，再將識別名稱換成自己要引用的文獻：

#tlt(
  caption: [文獻引用函式對照],
  columns: (auto, auto, 1fr),
  align: left + horizon,
  header: ([函式], [顯示結果], [用途]),
  rows: (
    ([`cp("kocher99")`], [#cp("kocher99")], [`\citep`，括號引用，放在句尾]),
    ([`c("kocher99")`], [#c("kocher99")], [`\citet`，行文引用，把作者寫進句子]),
    ([`ca("kocher99")`], [#ca("kocher99")], [`\citeauthor`，只顯示作者]),
    ([`cy("kocher99")`], [#cy("kocher99")], [`\citeyear`，只顯示年份]),
  ),
) <tbl:cite-forms>

引用書中的特定段落時，可以用 `supplement` 補上頁碼或章節。以下以 `companion` 這筆文獻為例，加入「第 42 頁」；套用到自己的論文時，請改成實際引用的位置：

#code[
  ```typ
  #cp("companion", supplement: [第 42 頁])
  ```
]

編譯後會顯示為 #cp("companion", supplement: [第 42 頁])。頁碼會與文獻引用一起排版，標點和排列方式則由選用的參考文獻樣式決定。

若不需要另外呼叫函式，也可以使用 #typst 原生的引用語法。例如在內文寫入 `@IEEE-1363`，就會得到@IEEE-1363。這種寫法與 `cp()` 都會使用設定檔中的文獻樣式，可以選擇自己較習慣的方式。

== 參考文獻設定

請打開 `config.yml`，在既有的 `bibliography:` 區塊下加入需要的設定。`path` 用來指定文獻檔案，`style` 決定引用格式；若資料分散在多個檔案，可以在 `path` 的清單中依序加入路徑。

#code[
  ```yaml
  bibliography:
    path: ["/contents/back/references.bib"] # 可以給多個檔案
    style: "apa"       # 內建 CSL 樣式名稱，或 .csl 檔案路徑，見下方對照表
    title: "參~考~文~獻"
    color: "#0000ff"   # 引用與連結的顏色，要黑白印就改成 "#000000"
    full: false        # true 會把沒引用到的條目也列出來
  ```
]

`style` 決定文獻的排版邏輯，大致分成三個系統：作者-年份制在正文顯示作者姓名與年份，讀者能一眼看出研究新舊；作者-頁碼制在正文顯示作者與頁碼，方便對照原文出處；數字制則在正文只留數字或上標，清單依編號排列，讀起來最不受干擾。#typst 內建超過八十種 CSL 樣式，各領域慣用的幾種如下：

#tlt(
  caption: [常見文獻格式對照],
  columns: (5em, 7em, 11em, 12em),
  align: left + horizon,
  header: ([格式], [系統], [常見領域], [`style` 值]),
  rows: (
    ([APA], [作者-年份制], [心理、教育、社會科學], [`apa`]),
    ([Harvard], [作者-年份制], [商管、社會科學], [`harvard-cite-them-right`]),
    ([Chicago], [作者-年份制], [歷史、人文], [`chicago-author-date`]),
    ([MLA], [作者-頁碼制], [文學、語言、藝術], [`mla`]),
    ([IEEE], [數字制], [資工、電機、工程], [`ieee`]),
    ([Vancouver], [數字制], [醫學、護理], [`vancouver`]),
  ),
) <tbl:citation-styles>

`style` 直接改成對照表最後一欄的值即可，例如把 `"apa"` 改成 `"ieee"`，正文引用與文末清單會一起換成對應樣式，就不用再額外調整 `cp()`、`c()` 等函式的呼叫方式。修改後請同時查看正文與參考文獻頁，確認作者、年份或編號的呈現方式。

以上清單只列出最常見的幾種，實際內建的樣式遠不止這些；若系所指定的格式不在其中（例如法律學門常用的 Bluebook，#typst 目前未內建），可以自行取得對應的 `.csl` 樣式檔，將 `style` 改填該檔案的路徑，例如 `style: "/misc/my-style.csl"`。

預設的 `full: false` 只會列出正文已引用的文獻。若加入新條目後，清單中仍看不到它，請先確認正文是否已經引用，以及識別名稱的大小寫是否一致。需要暫時列出文獻檔中的所有條目時，可以改為 `true`，方便逐筆檢查資料。

參考文獻的插入位置由 `main.typ` 中的 `#references()` 決定。以下將它放在第四章之後、附錄之前；若系所要求不同的裝訂順序，移動此行即可，不需要手動複製文獻清單：

#code[
  ```typ
  #include "contents/chapter04.typ"

  #references()                            // 參考文獻

  #include "contents/back/appendix01.typ"  // 附錄
  ```
]

== 程式碼區塊

要在論文中列出程式碼，可以直接在章節檔案裡建立程式碼區塊。模板會套用等寬字型、淺灰底色與行號，並依指定的語言進行語法標色。先選擇符合內容的語言名稱，例如 `python`、`bash` 或 `typ` 等，再填入程式碼即可。

建立程式碼區塊的方法是用反引號包住需要顯示的程式碼，並在開頭的反引號後加上語言名稱。結尾的三個反引號另起一行，表示這個區塊到此結束。以 Python 程式的寫法為例：

#code[
  ````typ
  ```python
  def solve(n):
      return sum(range(n))
  ```
  ````
]

如果這段程式需要標題與編號，再用 `#code()` 包住整個區塊，並在 `caption` 中填入標題。需要從內文引用時，也可以在結尾加上標籤，寫法和前一章的圖表相同：

#code[
  ````typ
  #code(caption: [遞迴版本])[
  ```python
  def fib(n):
      return n if n < 2 else fib(n - 1) + fib(n - 2)
  ```
  ]<lst:fib>
  ````
]

注意到：程式碼預設不顯示標題與編號，下面也採用不加標題的寫法。需要標題時，可以依上面的範例選填 `caption`，並用 `#ref(<lst:fib>)` 引用加上標籤的程式碼。標題預設放在下方；若要移到上方，請將 `layout.caption-position.code` 設為 `"top"`。

#code[
  ```python
  def fib(n):
      return n if n < 2 else fib(n - 1) + fib(n - 2)
  ```
]

當程式碼超過一頁時，會與表格一樣自動跨頁，行號也會連續編排，不必手動拆成數個區塊——直接使用反引號的區塊，以及用 `#code()` 加上標題的區塊，都支援跨頁；有標題時，整段程式仍共用一個編號與標題。

只有一行的程式碼區塊不會顯示行號。若只是在句子中提到指令或檔名，請用一對反引號包住文字，例如

#code[
  ```typ
  `just release`
  ```
]

這種行內寫法會保留等寬字型，字級與基線則和本文一致，不會另外加上底色或框線。

如果需要調整程式碼區塊外觀時，請打開 `helper/code.typ`，修改最上方的 `code-theme` 即可。此處的設定會套用到共用的程式碼樣式，不必逐一修改各章範例；其中 `size` 控制區塊字級，行內程式碼仍會跟隨所在段落的字級。以下列出各項設定：

#code[
  ```typ
  #let code-theme = (
    font: ("DejaVu Sans Mono",), // 等寬字體，可以放自己的字型
    size: 0.95em,                // 相對於本文字級
    fill: luma(248),             // 底色
    rule: 0.6pt + luma(180),     // 上下細線
    number: luma(140),           // 行號顏色
    inset: 0.6em,                // 內距
  )
  ```
]

#tlt(
  caption: [程式碼樣式參數],
  columns: (7em, 1fr),
  align: left + horizon,
  header: ([參數], [用途與範例]),
  rows: (
    ([`font`], [等寬字型；例：`("DejaVu Sans Mono",)`。]),
    ([`size`], [區塊字級；例：`0.95em`，行內程式碼仍跟隨本文。]),
    ([`fill`], [區塊底色；例：`luma(248)`。]),
    ([`rule`], [上下分隔線；例：`0.6pt + luma(180)`。]),
    ([`number`], [行號顏色；例：`luma(140)`。]),
    ([`inset`], [區塊內距；例：`0.6em`。]),
  ),
)

== 附錄

需要收錄問卷、補充資料或較長的推導時，可以放到 `contents/back/` 的附錄檔案。請先在檔案開頭設定附錄編號，再填入標題與內文。以下示範第一份附錄的寫法，編譯後會使用 A、B 等字母編號：

#code[
  ```typ
  #set heading(numbering: "A.1")
  #counter(heading).update(0)

  = 問卷內容 <appendix-a>

  == 第一部分
  ```
]

範例中的第一行會切換標題編號，第二行則將標題計數歸零。因此接下來的第一層標題會顯示為「附錄 A」，第二層標題則使用 `A.1`。替換內容時，只需修改「問卷內容」與各節標題，不必在標題中手動輸入字母或編號。

若要新增第二份附錄，請建立另一個 `.typ` 檔案，同樣在開頭設定 `#set heading(numbering: "A.1")`，但不再加入重設計數的指令。接著到 `main.typ`，在第一份附錄後面加入新檔案的 `#include`，編號就會接續為 B。

這裡的 `A.1` 是編號格式，其中 `A` 表示使用大寫字母計數，不是指定這份附錄一定叫作 A。因此第二份、第三份附錄仍使用相同設定，不要改成 `B.1` 或 `C.1`。

== 自動更新學校規範

各校的論文格式規範偶爾會修訂，`scripts/` 提供下載程式，能重新抓取官方文件並存進 `docs/`，方便對照排版是否需要跟著調整。一般撰寫論文時不需要每次編譯都執行，寫作期間偶爾檢查一次即可。

=== 快速開始：`just update`

專案根目錄的 `justfile` 定義了 `update` 這個指令，電腦上需要先裝好 #link("https://github.com/casey/just")[`just`]（單一執行檔，`brew install just` 或依官網說明安裝，不需要另外裝 uv 或 node）。裝好後直接執行：

#code[
  ```bash
  just update             # 檢查所有學校
  just update ntu nccu    # 只檢查指定學校
  just update --dry-run   # 只回報有無變化，不寫檔
  ```
]

`just update` 背後實際上會跑 `scripts/python/update_docs.py`，但不需要自己先裝 Python 或任何套件：第一次執行時，指令會偵測系統上有沒有 `uv`（一套 Python 版本與套件管理工具），若沒有就自動下載安裝到 `~/.local/bin`，不需要 sudo、也不會動到系統既有的 Python。之後每次執行，都是靠這個獨立安裝的 `uv` 建立乾淨環境來跑，不會裝進系統或污染其他專案。萬一自動安裝 `uv` 失敗（例如離線環境），指令才會退回改用 Node.js 版本，但仍要求電腦上已經有 `node`；兩者都不可用時，指令會直接報錯並提示原因，不會靜默失敗。

=== 手動執行

不想額外裝 `just`，也可以直接呼叫 Python 或 Node.js 版本，效果與 `just update` 相同：

#code[
  ```bash
  # Python 版，需要先自行安裝 uv
  cd scripts/python
  uv run update_docs.py --dry-run
  uv run update_docs.py ntu nccu
  uv run update_docs.py

  # 或 Node.js 版，需要先自行安裝 node
  cd scripts/nodeJS
  npm install
  node update-docs.mjs --dry-run
  ```
]

無論用哪種方式，下載新文件後都還需要自己閱讀規範內容並調整 `schools/`，程式只負責抓檔，不會自動修改排版設定。

=== 運作方式

兩個版本讀的是同一份 `scripts/sources.json`，裡面列出每間學校的規範文件網址；下載後會用 `docs/sources.lock.json` 記錄每份檔案的雜湊值，之後每次執行只比對雜湊，內容沒變就不會重新寫檔，執行結果也會中英並列標示「未變更 unchanged」或「已更新 updated」。若來源是 `.doc` 或 `.odt` 格式，還需要另外安裝 LibreOffice（提供 `soffice` 指令），讓程式能把檔案轉成 PDF 後再存入 `docs/`。

=== 排程定期檢查

確認手動執行正常後，若希望定期自動檢查，可以把以下排程加入自己的 `crontab`。範例會在每週一早上六點執行；請把專案路徑換成實際位置：

#code[
  ```bash
  0 6 * * 1 cd ~/tw-thesis-typ && just update
  ```
]
