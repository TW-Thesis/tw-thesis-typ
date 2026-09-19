# tw-thesis-typ

![Typst](https://img.shields.io/badge/made%20with-Typst-4b69c6?style=flat-square&logo=typst&logoColor=white) ![schools](https://img.shields.io/badge/schools-15-4b69c6?style=flat-square) ![i18n](https://img.shields.io/badge/tutorial-zh--Hant%20%7C%20en-4b69c6?style=flat-square) [![license](https://img.shields.io/badge/license-MIT-4b69c6?style=flat-square)](LICENSE)

TW-Thesis 提供臺灣主要大學碩博士論文的 [Typst](https://typst.app) 模板。內建 15 所學校的格式設定，教學文件本身就是可以編譯的範例，可以直接按照範例修改，以符合學校格式的論文。

> **免責聲明**：模板的格式設定僅供參考，實際仍請以學校公布的論文規範及系所要求為準。

*English: a Typst thesis template for Taiwanese universities, with format presets for 15 schools. The tutorial chapters are also the sample thesis. English versions of the tutorial live in [`contents/i18n/en/`](contents/i18n/en/) for reference.*

## 快速開始

將本專案 clone 下來後，建議按照以下步驟從零開始到編譯出第一份 PDF，耗時約十分鐘。

### 安裝 Typst

依系統選一種方式（`brew`、`winget`、`cargo` 需要先有對應的套件管理工具）：

```bash
brew install typst                # macOS
winget install --id Typst.Typst   # Windows
cargo install --locked typst-cli  # 任何平台
```

裝好後確認能執行：

```bash
typst --version
```

這份模板以 Typst 0.15 開發與測試，建議使用同一版或更新的版本。

### 取得專案

這個 repo 是 GitHub 的**範本儲存庫（template repository）**，請用 **Use this template** 建立你自己的論文專案：

1. 點擊右上角綠色的 **Use this template** 按鈕，選擇 **Create a new repository**。
2. 填入專案名稱（例如 `my-thesis`），可見度建議選 **Private**。
3. 建立完成後，把你的新專案 clone 到本機：

```bash
git clone https://github.com/<你的帳號>/my-thesis.git
cd my-thesis
```

已安裝 [GitHub CLI](https://cli.github.com) 的話，一行指令即可完成建立與 clone：

```bash
gh repo create my-thesis --template TW-Thesis/tw-thesis-typ --private --clone
cd my-thesis
```

用範本建立的專案是**全新的版本庫**：只有一個初始提交，不含模板的歷史紀錄，也不會與本 repo 有任何關聯。模板日後的更新不會自動套用到你的專案，需要時可以自行比對新版，再挑選要採用的部分。

若不使用 GitHub 的話，也可以在本頁選擇 **Code → Download ZIP**，解壓縮後進入資料夾即可。

後續所有指令都請在**專案根目錄**執行，也就是同時含有 `main.typ` 與 `config.yml` 的資料夾。

### 編譯

建立專案並 clone 後，可以嘗試編譯：

```bash
typst compile main.typ --font-path fonts/
```

完成後根目錄會出現 `main.pdf`。打開它，確認封面、目次與內文的中英文字型等內容均可正常顯示。

- `--font-path fonts/` 會讓 Typst 讀取專案附帶的字型（EB Garamond、Tinos、教育部標準楷書），不必另外安裝到系統。
- **第一次編譯需要連網**：模板會下載幾個 Typst 套件（假文用的 `kouhu`、`ipsum`），之後會快取在本機，離線也能編譯。
- 終端機若出現 `unknown font family: dfkai-sb` 的警告可直接忽略，那是備用字型，不影響結果。

### 填入資訊

用任何文字編輯器打開根目錄的 `config.yml`，把題目、姓名、系所、日期換成自己的，並取消註解、填上學校代碼：

```yaml
school: nccu              # 對應 schools/nccu.yml，代碼見下方「內建學校」

title: "分散式系統的一致性研究"
title-en: "A Study on Consistency in Distributed Systems"

author: "王小明"
author-en: "Wang, Xiao-Ming"
advisor: "陳大文"
advisor-en: "Chen, Da-Wen"

institute: "資訊科學系"
institute-en: "Department of Computer Science"

date: "2027-01-15"        # 封面上的日期，格式 YYYY-MM-DD
```

中英文欄位都要填，不然封面會缺其中一種語言。存檔後重新編譯，檢查封面與審定書；選了學校，格式（邊界、字級、封面樣式等）就會換成該校的設定，沒選則使用預設格式。

想改的設定不在學校預設裡（例如只把上邊界改成 3.5 公分），直接寫進 `config.yml` 即可，它的優先順序最高，不必動 `schools/`。每個可用設定與單位都寫在 `schools/default.yml`。

### 撰寫論文

論文內容在 `contents/`：`front/` 是摘要與致謝，`chapter01.typ` 起是各章，`back/` 是附錄與參考文獻檔。目前這些檔案是教學範例，每個範例都能直接複製使用。

`main.typ` 決定裝訂順序，新增或刪除一章，就在裡面增減對應的 `#include` 那一行。

而參考文獻放在 `contents/back/references.bib`，在內文用 `#cp("識別名稱")` 引用。

每一章的用法都寫在教學章節裡，依序是：第一章開始使用、第二章版面設定、第三章圖片與表格、第四章文獻／程式碼／附錄。

### 建議流程

- **存檔就重新編譯**：`typst watch main.typ --font-path fonts/`，保持終端機開著，存檔後 PDF 會自動更新。
- **VS Code**：安裝 [Tinymist](https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist) 擴充套件，專案已附 `.vscode/settings.json`（指定主檔案與字型路徑），開啟資料夾即可預覽。
- **交稿用的浮水印版本**：`typst compile main.typ --font-path fonts/ --input watermark=true`（需要先在設定檔指定浮水印圖片，見第二章）。
- 已安裝 [`just`](https://github.com/casey/just) 的話，`just compile`、`just watch`、`just release`、`just clean` 是上面幾個指令的縮寫。

### 遇到問題

- 找不到 `typst`：重新開啟終端機，並用 `typst --version` 確認安裝成功。
- 找不到 `main.typ`：目前所在的資料夾不對，請回到專案根目錄。
- `unknown key ...`：`config.yml` 的欄位名稱拼錯或縮排層級不對，對照 `schools/default.yml` 檢查。
- 其他編譯問題請看教學最後的附錄「編譯問題排查」。

## 內建學校

| 代碼 | 學校 | 英文名稱 | 規範版本 |
|---|---|---|---|
| [`ntu`](schools/ntu.yml) | 國立臺灣大學 | National Taiwan University | [民國 112 年 10 月 20 日](docs/國立臺灣大學-1121020-碩博士論文規範.pdf) |
| [`nthu`](schools/nthu.yml) | 國立清華大學 | National Tsing Hua University | [民國 114 年 5 月 29 日](docs/國立清華大學-1140529-碩博士論文規範.pdf) |
| [`nycu`](schools/nycu.yml) | 國立陽明交通大學 | National Yang Ming Chiao Tung University | [民國 115 年 9 月 17 日](docs/國立陽明交通大學-1150917-碩博士論文規範.pdf) |
| [`ncku`](schools/ncku.yml) | 國立成功大學 | National Cheng Kung University | [民國 110 年 1 月 6 日](docs/國立成功大學-1100106-碩博士論文規範.pdf) |
| [`nccu`](schools/nccu.yml) | 國立政治大學 | National Chengchi University | [民國 113 年 12 月 23 日](docs/國立政治大學-1131223-碩博士論文規範.pdf) |
| [`ntpu`](schools/ntpu.yml) | 國立臺北大學 | National Taipei University | [民國 111 年 8 月 16 日](docs/國立臺北大學-1110816-碩博士論文規範.pdf) |
| [`ntnu`](schools/ntnu.yml) | 國立臺灣師範大學 | National Taiwan Normal University | [民國 114 年 3 月 5 日](docs/國立臺灣師範大學-1140305-碩博士論文規範.pdf) |
| [`nknu`](schools/nknu.yml) | 國立高雄師範大學 | National Kaohsiung Normal University | [民國 110 年 8 月 24 日](docs/國立高雄師範大學-1100824-碩博士論文規範.pdf) |
| [`ncue`](schools/ncue.yml) | 國立彰化師範大學 | National Changhua University of Education | [民國 110 年 12 月 15 日](docs/國立彰化師範大學-1101215-碩博士論文規範.pdf) |
| [`ncu`](schools/ncu.yml) | 國立中央大學 | National Central University | [民國 105 年 1 月 27 日](docs/國立中央大學-1050127-碩博士論文規範.pdf) |
| [`nsysu`](schools/nsysu.yml) | 國立中山大學 | National Sun Yat-sen University | [民國 111 年 3 月 15 日](docs/國立中山大學-1110315-碩博士論文規範.pdf) |
| [`nchu`](schools/nchu.yml) | 國立中興大學 | National Chung Hsing University | [民國 111 年 4 月 21 日](docs/國立中興大學-1110421-碩博士論文規範.pdf) |
| [`ccu`](schools/ccu.yml) | 國立中正大學 | National Chung Cheng University | [民國 90 年 1 月](docs/國立中正大學-0900100-碩博士論文規範.pdf) |
| [`ntou`](schools/ntou.yml) | 國立臺灣海洋大學 | National Taiwan Ocean University | [民國 114 年 8 月 6 日](docs/國立臺灣海洋大學-1140806-碩博士論文規範.pdf) |
| [`nuk`](schools/nuk.yml) | 國立高雄大學 | National University of Kaohsiung | [民國 105 年 8 月 26 日](docs/國立高雄大學-1050826-碩博士論文規範.pdf) |

各校的官方規範 PDF 收在 [`docs/`](docs/)，每個設定檔開頭都註明依據的規範與尚未支援的項目。

## 專案結構

| 路徑 | 用途 |
|---|---|
| `config.yml` | 你的論文資料與想覆蓋的設定 |
| `main.typ` | 裝訂順序：前置、各章、參考文獻、附錄 |
| `contents/` | 論文內容（教學章節即範例） |
| `schools/` | 各校格式；`default.yml` 是唯一的預設值來源 |
| `i18n/` | 語言相關的用詞（中／英） |
| `lib/`、`helper/` | 模板核心與這本論文專用的工具函式 |
| `fonts/`、`assets/`、`docs/` | 字型、浮水印、各校規範 PDF |

## 貢獻

歡迎新增學校、修正格式、改善教學。請先看 [CONTRIBUTING.md](CONTRIBUTING.md)。

## 授權

程式與教學文字採 [MIT](LICENSE)。字型、校徽與各校規範文件不在此授權範圍內，詳見 [THIRD_PARTY.md](THIRD_PARTY.md)。
