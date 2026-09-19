# tw-thesis-typ

![Typst](https://img.shields.io/badge/made%20with-Typst-4b69c6?style=flat-square&logo=typst&logoColor=white) ![schools](https://img.shields.io/badge/schools-15-4b69c6?style=flat-square) ![i18n](https://img.shields.io/badge/tutorial-zh--Hant%20%7C%20en-4b69c6?style=flat-square) [![license](https://img.shields.io/badge/license-MIT-4b69c6?style=flat-square)](LICENSE)

台灣各大學碩博士論文的 [Typst](https://typst.app) 模板。內建 15 所學校的格式設定，教學文件本身就是可以編譯的範例：照著範例改，就能寫出符合學校格式的論文。

> **免責聲明**：模板的格式設定僅供參考，實際仍請以學校公布的論文規範及系所要求為準。

*English: a Typst thesis template for Taiwanese universities, with format presets for 15 schools. The tutorial chapters are also the sample thesis. English versions of the tutorial live in [`contents/i18n/en/`](contents/i18n/en/) for reference.*

## 快速開始

1. 安裝 [Typst](https://typst.app/open-source/)（`brew install typst`、`winget install --id Typst.Typst` 或 `cargo install --locked typst-cli`）。
2. 取得專案，在根目錄編譯：

   ```bash
   typst compile main.typ --font-path fonts/
   ```

   產生 `main.pdf`。`--font-path fonts/` 會讓 Typst 讀取專案附帶的字型。
3. 打開 `config.yml`，填入題目、姓名、系所，並選學校：

   ```yaml
   school: nccu   # 對應 schools/nccu.yml
   ```

已安裝 [`just`](https://github.com/casey/just) 的話，也可以用 `just compile`、`just watch`（存檔即重編）、`just release`（加上學校浮水印）。

完整說明請直接讀教學文件（`contents/chapter01.typ` 起），或編譯後看 `main.pdf`。

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
