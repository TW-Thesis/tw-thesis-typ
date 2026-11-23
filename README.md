# tw-thesis-typ

[English](README.en.md) | 繁體中文

![Typst](https://img.shields.io/badge/made%20with-Typst-4b69c6?style=flat-square&logo=typst&logoColor=white) ![schools](https://img.shields.io/badge/schools-122-4b69c6?style=flat-square) ![i18n](https://img.shields.io/badge/tutorial-zh--Hant%20%7C%20en-4b69c6?style=flat-square) [![license](https://img.shields.io/badge/license-MIT-4b69c6?style=flat-square)](LICENSE)

TW-Thesis 提供臺灣主要大學碩博士論文的 [Typst](https://typst.app) 模板。內建 122 所學校的格式設定，教學文件本身就是可以編譯的範例，可以直接按照範例修改，以符合學校格式的論文。

> **免責聲明**：模板的格式設定僅供參考，實際仍請以學校公布的論文規範及系所要求為準。

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

論文的內容都在 `contents/`，結構如下：

```text
contents/
├── front/           摘要、致謝、符號列表等
├── chapter01.typ    以下為各章內容
├── chapter02.typ
├── chapter03.typ
├── chapter04.typ
├── back/            附錄與參考文獻
└── i18n/en/         英文版教學
```

初次複製下來的檔案內是教學內容，也是可以參考的範例。

各章的順序由 `main.typ` 決定。多一章或少一章，就在裡面加或刪對應的那一行 `#include` 即可：

```typ
#include "contents/chapter01.typ"
#include "contents/chapter02.typ"
```

參考文獻寫在 `contents/back/references.bib`，內文用識別名稱引用，例如 `references.bib` 裡有一筆 `kocher99`：

```typ
#cp("kocher99")
```

英文版教學放在 `contents/i18n/en/`，不屬於你的論文。想單獨看它的成品（圖表與章節前綴為 Figure、Table、Chapter、Section），執行 `just compile-en`。

### 編輯與預覽

想邊寫邊看結果，可以開監看模式，存檔就會自動重新編譯，PDF 也會跟著更新：

```bash
typst watch main.typ --font-path fonts/
```

用 VS Code 的話，安裝 [Tinymist](https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist) 擴充套件就能直接預覽。專案裡已經附了 `.vscode/settings.json`，裡面指定好主檔案和字型路徑，打開資料夾即可。

交稿如果需要浮水印，要先在設定檔指定浮水印圖片（第二章有寫），再用下面的指令編譯：

```bash
typst compile main.typ --font-path fonts/ --input watermark=true
```

若有安裝 [`just`](https://github.com/casey/just) 的話，上面流程可以縮短為：

```bash
just compile   # 一般編譯
just watch     # 存檔就重新編譯
just release   # 加上浮水印
just clean     # 刪掉 main.pdf
```

## 內建學校

| 代碼 | 學校 | 英文名稱 | 規範版本 |
|---|---|---|---|
| [`aeust`](schools/aeust.yml) | 亞東科技大學 | Asia Eastern University of Science and Technology | [民國 110 年 7 月 28 日](docs/亞東科技大學-1100728-碩博士論文規範.pdf) |
| [`asia`](schools/asia.yml) | 亞洲大學 | Asia University | [民國 109 年 11 月 18 日](docs/亞洲大學-1091118-碩博士論文規範.pdf) |
| [`au`](schools/au.yml) | 真理大學 | Aletheia University | [民國 113 年 5 月 27 日](docs/真理大學-1130527-碩博士論文規範.pdf) |
| [`ccu`](schools/ccu.yml) | 國立中正大學 | National Chung Cheng University | [民國 90 年 1 月](docs/國立中正大學-0900100-碩博士論文規範.pdf) |
| [`cgu`](schools/cgu.yml) | 長庚大學 | Chang Gung University | [民國 110 年 7 月 16 日](docs/長庚大學-1100716-碩博士論文規範.pdf) |
| [`cgust`](schools/cgust.yml) | 長庚科技大學 | Chang Gung University of Science and Technology | [民國 114 年 6 月 9 日](docs/長庚科技大學-1140609-碩博士論文規範.pdf) |
| [`chihlee`](schools/chihlee.yml) | 致理科技大學 | Chihlee University of Technology | [民國 105 年 1 月 25 日](docs/致理科技大學-1050125-碩博士論文規範.pdf) |
| [`chu`](schools/chu.yml) | 中華大學 | Chung Hua University | [民國 111 年 9 月 14 日](docs/中華大學-1110914-碩博士論文規範.pdf) |
| [`cjcu`](schools/cjcu.yml) | 長榮大學 | Chang Jung Christian University | [民國 107 年 3 月 13 日](docs/長榮大學-1070313-碩博士論文規範.pdf) |
| [`cmu`](schools/cmu.yml) | 中國醫藥大學 | China Medical University | [民國 111 年 8 月 8 日](docs/中國醫藥大學-1110808-碩博士論文規範.pdf) |
| [`cnu`](schools/cnu.yml) | 嘉南藥理大學 | Chia Nan University of Pharmacy & Science | [民國 109 年 10 月 13 日](docs/嘉南藥理大學-1091013-碩博士論文規範.pdf) |
| [`cpu`](schools/cpu.yml) | 中央警察大學 | Central Police University | [民國 109 年 4 月 28 日](docs/中央警察大學-1090428-碩博士論文規範.pdf) |
| [`csmu`](schools/csmu.yml) | 中山醫學大學 | Chung Shan Medical University | [民國 115 年 5 月 13 日](docs/中山醫學大學-1150513-碩博士論文規範.pdf) |
| [`csu`](schools/csu.yml) | 正修科技大學 | Cheng Shiu University | [民國 115 年 2 月 11 日](docs/正修科技大學-1150211-碩博士論文規範.pdf) |
| [`ctbctech`](schools/ctbctech.yml) | 中信科技大學 | CTBC UNIVERSITY OF TECHNOLOGY | [民國 114 年 1 月 16 日](docs/中信科技大學-1140116-碩博士論文規範.pdf) |
| [`ctu`](schools/ctu.yml) | 建國科技大學 | Chienkuo Technology University | [民國 111 年 7 月 28 日](docs/建國科技大學-1110728-碩博士論文規範.pdf) |
| [`ctust`](schools/ctust.yml) | 中臺科技大學 | Central Taiwan University of Science and Technology | [民國 106 年 7 月 18 日](docs/中臺科技大學-1060718-碩博士論文規範.pdf) |
| [`cufa`](schools/cufa.yml) | 崇右影藝科技大學 | Chungyu University of Film and Arts | [民國 104 年 2 月 3 日](docs/崇右影藝科技大學-1040203-碩博士論文規範.pdf) |
| [`cust`](schools/cust.yml) | 中華科技大學 | China University of Science and Technology | [民國 107 年 5 月 10 日](docs/中華科技大學-1070510-碩博士論文規範.pdf) |
| [`cute`](schools/cute.yml) | 中國科技大學 | China University of Technology | [民國 105 年 2 月](docs/中國科技大學-1050200-碩博士論文規範.pdf) |
| [`cycu`](schools/cycu.yml) | 中原大學 | Chung Yuan Christian University | [民國 115 年 1 月 21 日](docs/中原大學-1150121-碩博士論文規範.pdf) |
| [`cyut`](schools/cyut.yml) | 朝陽科技大學 | Chaoyang University of Technology | [民國 115 年 10 月 16 日](docs/朝陽科技大學-1151016-碩博士論文規範.pdf) |
| [`dyu`](schools/dyu.yml) | 大葉大學 | Da-Yeh University | [民國 114 年 12 月 15 日](docs/大葉大學-1141215-碩博士論文規範.pdf) |
| [`fcu`](schools/fcu.yml) | 逢甲大學 | Feng Chia University | [民國 111 年 3 月 18 日](docs/逢甲大學-1110318-碩博士論文規範.pdf) |
| [`fgu`](schools/fgu.yml) | 佛光大學 | Fo Guang University | [民國 110 年 1 月 6 日](docs/佛光大學-1100106-碩博士論文規範.pdf) |
| [`fju`](schools/fju.yml) | 輔仁大學 | Fu Jen Catholic University | [民國 91 年 5 月 2 日](docs/輔仁大學-0910502-碩博士論文規範.pdf) |
| [`fy`](schools/fy.yml) | 輔英科技大學 | Fooyin University | [民國 115 年 3 月 4 日](docs/輔英科技大學-1150304-碩博士論文規範.pdf) |
| [`hcu`](schools/hcu.yml) | 玄奘大學 | Hsuan Chuang University | [民國 112 年 10 月 4 日](docs/玄奘大學-1121004-碩博士論文規範.pdf) |
| [`hdut`](schools/hdut.yml) | 宏國德霖科技大學 | Hungkuo Delin University of Technology | [民國 110 年 12 月 29 日](docs/宏國德霖科技大學-1101229-碩博士論文規範.pdf) |
| [`hfu`](schools/hfu.yml) | 華梵大學 | Huafan University | [民國 109 年 6 月 3 日](docs/華梵大學-1090603-碩博士論文規範.pdf) |
| [`hk`](schools/hk.yml) | 弘光科技大學 | Hungkuang University | [民國 109 年 12 月](docs/弘光科技大學-1091200-碩博士論文規範.pdf) |
| [`hust`](schools/hust.yml) | 修平科技大學 | Hsiuping University of Science and Technology | [民國 100 年 12 月 2 日](docs/修平科技大學-1001202-碩博士論文規範.pdf) |
| [`hwai`](schools/hwai.yml) | 中華醫事科技大學 | Chung Hwa University of Medical Technology | [民國 110 年 1 月 26 日](docs/中華醫事科技大學-1100126-碩博士論文規範.pdf) |
| [`hwh`](schools/hwh.yml) | 華夏科技大學 | Hwa Hsia University of Technology | [民國 112 年 2 月 22 日](docs/華夏科技大學-1120222-碩博士論文規範.pdf) |
| [`hwu`](schools/hwu.yml) | 醒吾科技大學 | Hsing Wu University of Science and Technology | [民國 106 年 9 月 6 日](docs/醒吾科技大學-1060906-碩博士論文規範.pdf) |
| [`isu`](schools/isu.yml) | 義守大學 | I-Shou University | [民國 115 年 4 月 30 日](docs/義守大學-1150430-碩博士論文規範.pdf) |
| [`just`](schools/just.yml) | 景文科技大學 | Jinwen University of Science and Technology | [民國 110 年 6 月](docs/景文科技大學-1100600-碩博士論文規範.pdf) |
| [`kmu`](schools/kmu.yml) | 高雄醫學大學 | Kaohsiung Medical University | [民國 114 年 6 月 18 日](docs/高雄醫學大學-1140618-碩博士論文規範.pdf) |
| [`knu`](schools/knu.yml) | 開南大學 | Kainan University | [民國 109 年 4 月 8 日](docs/開南大學-1090408-碩博士論文規範.pdf) |
| [`ksu`](schools/ksu.yml) | 崑山科技大學 | Kun Shan University | [民國 107 年 12 月 3 日](docs/崑山科技大學-1071203-碩博士論文規範.pdf) |
| [`lhu`](schools/lhu.yml) | 龍華科技大學 | Lunghwa University of Science and Technology | [民國 114 年 6 月 5 日](docs/龍華科技大學-1140605-碩博士論文規範.pdf) |
| [`ltu`](schools/ltu.yml) | 嶺東科技大學 | Ling Tung University | [民國 114 年 1 月 2 日](docs/嶺東科技大學-1140102-碩博士論文規範.pdf) |
| [`mcu`](schools/mcu.yml) | 銘傳大學 | Ming Chuan University | [未標日期](docs/銘傳大學-0000000-碩博士論文規範.pdf) |
| [`mcut`](schools/mcut.yml) | 明志科技大學 | Ming Chi University of Technology | [民國 114 年 11 月 4 日](docs/明志科技大學-1141104-碩博士論文規範.pdf) |
| [`meiho`](schools/meiho.yml) | 美和科技大學 | Meiho University | [民國 114 年 5 月 12 日](docs/美和科技大學-1140512-碩博士論文規範.pdf) |
| [`mmu`](schools/mmu.yml) | 馬偕醫學大學 | MacKay Medical University | [民國 115 年 5 月 22 日](docs/馬偕醫學大學-1150522-碩博士論文規範.pdf) |
| [`must`](schools/must.yml) | 明新科技大學 | Minghsin University of Science and Technology | [民國 112 年 5 月 29 日](docs/明新科技大學-1120529-碩博士論文規範.pdf) |
| [`nccu`](schools/nccu.yml) | 國立政治大學 | National Chengchi University | [民國 113 年 12 月 23 日](docs/國立政治大學-1131223-碩博士論文規範.pdf) |
| [`nchu`](schools/nchu.yml) | 國立中興大學 | National Chung Hsing University | [民國 111 年 4 月 21 日](docs/國立中興大學-1110421-碩博士論文規範.pdf) |
| [`ncku`](schools/ncku.yml) | 國立成功大學 | National Cheng Kung University | [民國 110 年 1 月 6 日](docs/國立成功大學-1100106-碩博士論文規範.pdf) |
| [`ncnu`](schools/ncnu.yml) | 國立暨南國際大學 | National Chi Nan University | [民國 110 年 11 月 1 日](docs/國立暨南國際大學-1101101-碩博士論文規範.pdf) |
| [`ncu`](schools/ncu.yml) | 國立中央大學 | National Central University | [民國 105 年 1 月 27 日](docs/國立中央大學-1050127-碩博士論文規範.pdf) |
| [`ncue`](schools/ncue.yml) | 國立彰化師範大學 | National Changhua University of Education | [民國 110 年 12 月 15 日](docs/國立彰化師範大學-1101215-碩博士論文規範.pdf) |
| [`ncut`](schools/ncut.yml) | 國立勤益科技大學 | National Chin-Yi University of Technology | [民國 114 年 7 月 16 日](docs/國立勤益科技大學-1140716-碩博士論文規範.pdf) |
| [`ncyu`](schools/ncyu.yml) | 國立嘉義大學 | National Chiayi University | [民國 114 年 11 月 25 日](docs/國立嘉義大學-1141125-碩博士論文規範.pdf) |
| [`ndhu`](schools/ndhu.yml) | 國立東華大學 | National Dong Hwa University | [民國 112 年 12 月 8 日](docs/國立東華大學-1121208-碩博士論文規範.pdf) |
| [`ndmu`](schools/ndmu.yml) | 國防醫學大學 | National Defense Medical University | [民國 114 年 11 月 13 日](docs/國防醫學大學-1141113-碩博士論文規範.pdf) |
| [`ndu`](schools/ndu.yml) | 國防大學 | National Defense University | [未標日期](docs/國防大學-0000000-碩博士論文規範.pdf) |
| [`nfu`](schools/nfu.yml) | 國立虎尾科技大學 | National Formosa University | [民國 111 年 7 月 26 日](docs/國立虎尾科技大學-1110726-碩博士論文規範.pdf) |
| [`nhu`](schools/nhu.yml) | 南華大學 | Nanhua university | [民國 108 年 12 月 15 日](docs/南華大學-1081215-碩博士論文規範.pdf) |
| [`niu`](schools/niu.yml) | 國立宜蘭大學 | National Ilan University | [民國 111 年 12 月 20 日](docs/國立宜蘭大學-1111220-碩博士論文規範.pdf) |
| [`nknu`](schools/nknu.yml) | 國立高雄師範大學 | National Kaohsiung Normal University | [民國 110 年 8 月 24 日](docs/國立高雄師範大學-1100824-碩博士論文規範.pdf) |
| [`nkuht`](schools/nkuht.yml) | 國立高雄餐旅大學 | National Kaohsiung University of Hospitality and Tourism | [民國 110 年 10 月 29 日](docs/國立高雄餐旅大學-1101029-碩博士論文規範.pdf) |
| [`nkust`](schools/nkust.yml) | 國立高雄科技大學 | National Kaohsiung University of Science and Technology | [民國 111 年 3 月](docs/國立高雄科技大學-1110300-碩博士論文規範.pdf) |
| [`nkut`](schools/nkut.yml) | 南開科技大學 | Nan Kai University of Technology | [民國 101 年 12 月 19 日](docs/南開科技大學-1011219-碩博士論文規範.pdf) |
| [`nptu`](schools/nptu.yml) | 國立屏東大學 | National Pingtung University | [民國 112 年 6 月 13 日](docs/國立屏東大學-1120613-碩博士論文規範.pdf) |
| [`npu`](schools/npu.yml) | 國立澎湖科技大學 | National Penghu University of Science and Technology | [未標日期](docs/國立澎湖科技大學-0000000-碩博士論文規範.pdf) |
| [`npust`](schools/npust.yml) | 國立屏東科技大學 | National Pingtung University of Science and Technology | [民國 111 年 4 月 12 日](docs/國立屏東科技大學-1110412-碩博士論文規範.pdf) |
| [`nqu`](schools/nqu.yml) | 國立金門大學 | National Quemoy University | [民國 111 年 6 月 29 日](docs/國立金門大學-1110629-碩博士論文規範.pdf) |
| [`nsysu`](schools/nsysu.yml) | 國立中山大學 | National Sun Yat-sen University | [民國 111 年 3 月 15 日](docs/國立中山大學-1110315-碩博士論文規範.pdf) |
| [`ntcu`](schools/ntcu.yml) | 國立臺中教育大學 | National Taichung University of Education | [民國 113 年 1 月 15 日](docs/國立臺中教育大學-1130115-碩博士論文規範.pdf) |
| [`nthu`](schools/nthu.yml) | 國立清華大學 | National Tsing Hua University | [民國 114 年 5 月 29 日](docs/國立清華大學-1140529-碩博士論文規範.pdf) |
| [`ntnu`](schools/ntnu.yml) | 國立臺灣師範大學 | National Taiwan Normal University | [民國 114 年 3 月 5 日](docs/國立臺灣師範大學-1140305-碩博士論文規範.pdf) |
| [`ntou`](schools/ntou.yml) | 國立臺灣海洋大學 | National Taiwan Ocean University | [民國 114 年 8 月 6 日](docs/國立臺灣海洋大學-1140806-碩博士論文規範.pdf) |
| [`ntpu`](schools/ntpu.yml) | 國立臺北大學 | National Taipei University | [民國 111 年 8 月 16 日](docs/國立臺北大學-1110816-碩博士論文規範.pdf) |
| [`ntsu`](schools/ntsu.yml) | 國立體育大學 | National Taiwan Sport University | [民國 113 年 5 月 30 日](docs/國立體育大學-1130530-碩博士論文規範.pdf) |
| [`nttu`](schools/nttu.yml) | 國立臺東大學 | National Taitung University | [民國 111 年 6 月 2 日](docs/國立臺東大學-1110602-碩博士論文規範.pdf) |
| [`ntu`](schools/ntu.yml) | 國立臺灣大學 | National Taiwan University | [民國 112 年 10 月 20 日](docs/國立臺灣大學-1121020-碩博士論文規範.pdf) |
| [`ntua`](schools/ntua.yml) | 國立臺灣藝術大學 | National Taiwan University of Arts | [民國 115 年 6 月 1 日](docs/國立臺灣藝術大學-1150601-碩博士論文規範.pdf) |
| [`ntub`](schools/ntub.yml) | 國立臺北商業大學 | National Taipei University of  Business | [未標日期](docs/國立臺北商業大學-0000000-碩博士論文規範.pdf) |
| [`ntue`](schools/ntue.yml) | 國立臺北教育大學 | National Taipei University of Education | [民國 115 年 4 月 22 日](docs/國立臺北教育大學-1150422-碩博士論文規範.pdf) |
| [`ntunhs`](schools/ntunhs.yml) | 國立臺北護理健康大學 | National Taipei University of Nursing and Health Sciences | [未標日期](docs/國立臺北護理健康大學-0000000-碩博士論文規範.pdf) |
| [`ntus`](schools/ntus.yml) | 國立臺灣體育運動大學 | National Taiwan University of Sport | [民國 115 年 1 月 21 日](docs/國立臺灣體育運動大學-1150121-碩博士論文規範.pdf) |
| [`ntust`](schools/ntust.yml) | 國立臺灣科技大學 | National Taiwan University of Science and Technology | [民國 113 年 12 月 24 日](docs/國立臺灣科技大學-1131224-碩博士論文規範.pdf) |
| [`ntut`](schools/ntut.yml) | 國立臺北科技大學 | National Taipei University of Technology | [民國 114 年 2 月 1 日](docs/國立臺北科技大學-1140201-碩博士論文規範.pdf) |
| [`nuk`](schools/nuk.yml) | 國立高雄大學 | National University of Kaohsiung | [民國 105 年 8 月 26 日](docs/國立高雄大學-1050826-碩博士論文規範.pdf) |
| [`nutc`](schools/nutc.yml) | 國立臺中科技大學 | National  Taichung University Of  Science And Technology | [民國 114 年 5 月 19 日](docs/國立臺中科技大學-1140519-碩博士論文規範.pdf) |
| [`nutn`](schools/nutn.yml) | 國立臺南大學 | National University of Tainan | [民國 110 年 8 月 11 日](docs/國立臺南大學-1100811-碩博士論文規範.pdf) |
| [`nuu`](schools/nuu.yml) | 國立聯合大學 | National United University | [民國 110 年 7 月 2 日](docs/國立聯合大學-1100702-碩博士論文規範.pdf) |
| [`nycu`](schools/nycu.yml) | 國立陽明交通大學 | National Yang Ming Chiao Tung University | [民國 115 年 9 月 17 日](docs/國立陽明交通大學-1150917-碩博士論文規範.pdf) |
| [`ocu`](schools/ocu.yml) | 僑光科技大學 | Overseas Chinese University | [未標日期](docs/僑光科技大學-0000000-碩博士論文規範.pdf) |
| [`pccu`](schools/pccu.yml) | 中國文化大學 | Chinese Culture University | [民國 115 年 3 月 30 日](docs/中國文化大學-1150330-碩博士論文規範.pdf) |
| [`pu`](schools/pu.yml) | 靜宜大學 | Providence University | [民國 109 年 5 月 28 日](docs/靜宜大學-1090528-碩博士論文規範.pdf) |
| [`scu`](schools/scu.yml) | 東吳大學 | Soochow University | [民國 115 年 5 月 28 日](docs/東吳大學-1150528-碩博士論文規範.pdf) |
| [`shu`](schools/shu.yml) | 世新大學 | Shih Hsin University | [未標日期](docs/世新大學-0000000-碩博士論文規範.pdf) |
| [`sju`](schools/sju.yml) | 聖約翰科技大學 | St. John’s University | [民國 115 年 9 月 22 日](docs/聖約翰科技大學-1150922-碩博士論文規範.pdf) |
| [`stu`](schools/stu.yml) | 樹德科技大學 | Shu-Te University | [未標日期](docs/樹德科技大學-0000000-碩博士論文規範.pdf) |
| [`stust`](schools/stust.yml) | 南臺科技大學 | Southern Taiwan University of Science and Technology | [民國 107 年 5 月 29 日](docs/南臺科技大學-1070529-碩博士論文規範.pdf) |
| [`tajen`](schools/tajen.yml) | 大仁科技大學 | Tajen University | [民國 94 年 10 月 19 日](docs/大仁科技大學-0941019-碩博士論文規範.pdf) |
| [`takming`](schools/takming.yml) | 德明財經科技大學 | Takming University of Science and Technology | [民國 112 年 5 月 8 日](docs/德明財經科技大學-1120508-碩博士論文規範.pdf) |
| [`tcu`](schools/tcu.yml) | 慈濟大學 | Tzu Chi University | [民國 110 年 3 月 15 日](docs/慈濟大學-1100315-碩博士論文規範.pdf) |
| [`thu`](schools/thu.yml) | 東海大學 | Tunghai University | [民國 112 年 11 月 8 日](docs/東海大學-1121108-碩博士論文規範.pdf) |
| [`tku`](schools/tku.yml) | 淡江大學 | Tamkang University | [民國 114 年 12 月 9 日](docs/淡江大學-1141209-碩博士論文規範.pdf) |
| [`tmu`](schools/tmu.yml) | 臺北醫學大學 | Taipei Medical University | [民國 115 年 11 月 18 日](docs/臺北醫學大學-1151118-碩博士論文規範.pdf) |
| [`tnnua`](schools/tnnua.yml) | 國立臺南藝術大學 | Tainan National University of the Arts | [民國 115 年 5 月 28 日](docs/國立臺南藝術大學-1150528-碩博士論文規範.pdf) |
| [`tnu`](schools/tnu.yml) | 東南科技大學 | Tungnan University | [民國 107 年 12 月 27 日](docs/東南科技大學-1071227-碩博士論文規範.pdf) |
| [`tnua`](schools/tnua.yml) | 國立臺北藝術大學 | Taipei National University of the Arts | [民國 100 年 5 月 18 日](docs/國立臺北藝術大學-1000518-碩博士論文規範.pdf) |
| [`tpcu`](schools/tpcu.yml) | 臺北城市科技大學 | Taipei City University of Science and Technology | [民國 110 年 12 月 27 日](docs/臺北城市科技大學-1101227-碩博士論文規範.pdf) |
| [`tsust`](schools/tsust.yml) | 台鋼科技大學 | Taiwan Steel University of Science and Technology | [未標日期](docs/台鋼科技大學-0000000-碩博士論文規範.pdf) |
| [`ttu`](schools/ttu.yml) | 大同大學 | Tatung University | [民國 115 年 8 月 12 日](docs/大同大學-1150812-碩博士論文規範.pdf) |
| [`tumt`](schools/tumt.yml) | 台北海洋科技大學 | Taipei University of Marine Technology | [民國 111 年 3 月 30 日](docs/台北海洋科技大學-1110330-碩博士論文規範.pdf) |
| [`tut`](schools/tut.yml) | 台南應用科技大學 | Tainan University of Technology | [民國 114 年 2 月 21 日](docs/台南應用科技大學-1140221-碩博士論文規範.pdf) |
| [`uch`](schools/uch.yml) | 健行科技大學 | Chien Hsin University of Science and Technology | [民國 115 年 4 月 23 日](docs/健行科技大學-1150423-碩博士論文規範.pdf) |
| [`ukn`](schools/ukn.yml) | 康寧大學 | University of Kang Ning | [民國 103 年 5 月 5 日](docs/康寧大學-1030505-碩博士論文規範.pdf) |
| [`usc`](schools/usc.yml) | 實踐大學 | Shih Chien University | [民國 115 年 5 月 25 日](docs/實踐大學-1150525-碩博士論文規範.pdf) |
| [`vnu`](schools/vnu.yml) | 萬能科技大學 | Vanung University | [民國 106 年 2 月 16 日](docs/萬能科技大學-1060216-碩博士論文規範.pdf) |
| [`wfu`](schools/wfu.yml) | 吳鳳科技大學 | WuFeng University | [未標日期](docs/吳鳳科技大學-0000000-碩博士論文規範.pdf) |
| [`wzu`](schools/wzu.yml) | 文藻外語大學 | Wenzao Ursuline University of Languages | [民國 112 年 4 月 1 日](docs/文藻外語大學-1120401-碩博士論文規範.pdf) |
| [`ydu`](schools/ydu.yml) | 育達科技大學 | Yu Da University of Science and Technology | [民國 114 年 12 月 17 日](docs/育達科技大學-1141217-碩博士論文規範.pdf) |
| [`ypu`](schools/ypu.yml) | 元培醫事科技大學 | Yuanpei University of Medical Technology | [民國 115 年 4 月 2 日](docs/元培醫事科技大學-1150402-碩博士論文規範.pdf) |
| [`yuntech`](schools/yuntech.yml) | 國立雲林科技大學 | National Yunlin University of Science & Technology | [民國 114 年 9 月 1 日](docs/國立雲林科技大學-1140901-碩博士論文規範.pdf) |
| [`yzu`](schools/yzu.yml) | 元智大學 | Yuan Ze University | [民國 112 年 11 月 23 日](docs/元智大學-1121123-碩博士論文規範.pdf) |

各校的官方規範 PDF 收在 [`docs/`](docs/)，每個設定檔開頭都註明依據、適用範圍與尚未支援的項目。完整收錄範圍與排除理由見 [`docs/COVERAGE.md`](docs/COVERAGE.md)。

## 專案結構

| 路徑 | 用途 |
|---|---|
| `config.yml` | 論文資料與設定 |
| `main.typ` | 裝訂順序：前置、各章、參考文獻、附錄 |
| `contents/` | 論文內容（教學章節即範例） |
| `schools/` | 各校格式；`default.yml` 是唯一的預設值來源 |
| `i18n/` | 其他語言範例檔 |
| `lib/`、`helper/` | 模板核心與這本論文專用的工具函式 |
| `fonts/`、`assets/`、`docs/` | 字型、浮水印、各校規範 PDF |

## 貢獻

歡迎新增學校、修正格式、改善教學。請先看 [CONTRIBUTING.md](CONTRIBUTING.md)。

## 授權

程式與教學文字採 [MIT](LICENSE)。字型、校徽與各校規範文件不在此授權範圍內，詳見 [THIRD_PARTY.md](THIRD_PARTY.md)。
