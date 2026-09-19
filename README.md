# tw-thesis-typ

![Typst](https://img.shields.io/badge/made%20with-Typst-4b69c6?style=flat-square&logo=typst&logoColor=white) ![schools](https://img.shields.io/badge/schools-15-4b69c6?style=flat-square) ![i18n](https://img.shields.io/badge/tutorial-zh--Hant%20%7C%20en-4b69c6?style=flat-square) [![license](https://img.shields.io/badge/license-MIT-4b69c6?style=flat-square)](LICENSE)

TW-Thesis 提供臺灣主要大學碩博士論文的 [$\color{#239dad}{\textbf{Typst}}$](https://typst.app) 模板。內建 15 所學校的格式設定，教學文件本身就是可以編譯的範例，可以直接按照範例修改，以符合學校格式的論文。

> **免責聲明**：模板的格式設定僅供參考，實際仍請以學校公布的論文規範及系所要求為準。

*English: a $\color{#239dad}{\textbf{Typst}}$ thesis template for Taiwanese universities, with format presets for 15 schools. The tutorial chapters are also the sample thesis. English versions of the tutorial live in [`contents/i18n/en/`](contents/i18n/en/) for reference.*

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

這份模板以 $\color{#239dad}{\textbf{Typst}}$ 0.15 開發與測試，建議使用同一版或更新的版本。

### 取得專案

任選一種：

```bash
git clone https://github.com/TW-Thesis/tw-thesis-typ.git my-thesis
cd my-thesis
rm -rf .git      # 這是你自己的論文，不需要模板的歷史紀錄；之後可以 git init 重新開始
```

或在 GitHub 頁面按 **Code → Download ZIP**，解壓縮後進入資料夾。

之後所有指令都在**專案根目錄**執行，也就是有 `main.typ` 和 `config.yml` 的那一層。

### 編譯第一份 PDF

```bash
typst compile main.typ --font-path fonts/
```

完成後根目錄會出現 `main.pdf`。打開它，確認封面、目次與內文的中英文字型都顯示正常。

- `--font-path fonts/` 會讓 $\color{#239dad}{\textbf{Typst}}$ 讀取專案附帶的字型（EB Garamond、Tinos、教育部標準楷書），不必另外安裝到系統。
- **第一次編譯需要連網**：模板會下載幾個 $\color{#239dad}{\textbf{Typst}}$ 套件（假文用的 `kouhu`、`ipsum`），之後會快取在本機，離線也能編譯。
- 終端機出現 `unknown font family: dfkai-sb` 的警告可以忽略，那是備用字型，沒裝也不影響結果。

### 填入自己的資料並選學校

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

### 開始寫論文

- 論文內容在 `contents/`：`front/` 是摘要與致謝，`chapter01.typ` 起是各章，`back/` 是附錄與參考文獻檔。目前這些檔案是教學範例，每個範例都能直接複製使用。
- `main.typ` 決定裝訂順序，新增或刪除一章，就在裡面增減對應的 `#include` 那一行。
- 參考文獻放在 `contents/back/references.bib`，在內文用 `#cp("識別名稱")` 引用。

每一章的用法都寫在教學章節裡，依序是：第一章開始使用、第二章版面設定、第三章圖片與表格、第四章文獻／程式碼／附錄。

### 好用的做法

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

`ntu` 臺灣大學 · `nthu` 清華大學 · `nycu` 陽明交通大學 · `ncku` 成功大學 · `nccu` 政治大學 · `ntpu` 臺北大學 · `ntnu` 臺灣師範大學 · `nknu` 高雄師範大學 · `ncue` 彰化師範大學 · `ncu` 中央大學 · `nsysu` 中山大學 · `nchu` 中興大學 · `ccu` 中正大學 · `ntou` 臺灣海洋大學 · `nuk` 高雄大學

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
