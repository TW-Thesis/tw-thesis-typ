# tw-thesis-typ

English | [繁體中文](README.md)

![Typst](https://img.shields.io/badge/made%20with-Typst-4b69c6?style=flat-square&logo=typst&logoColor=white) ![schools](https://img.shields.io/badge/schools-122-4b69c6?style=flat-square) ![i18n](https://img.shields.io/badge/tutorial-zh--Hant%20%7C%20en-4b69c6?style=flat-square) [![license](https://img.shields.io/badge/license-MIT-4b69c6?style=flat-square)](LICENSE)

TW-Thesis provides a [Typst](https://typst.app) template for master's and doctoral theses at major universities in Taiwan. It includes format presets for 122 schools. The tutorial is also a working sample thesis, so you can compile it, copy what you need, and change it into your own thesis.

> **Disclaimer**: The format presets in this template are for reference only. Always follow your school's official thesis regulations and your department's requirements.

## Getting started

Follow the steps below to go from nothing to your first PDF. It takes about ten minutes.

### Install Typst

Choose one method for your system. `brew`, `winget` and `cargo` need to be installed first.

```bash
brew install typst                # macOS
winget install --id Typst.Typst   # Windows
cargo install --locked typst-cli  # any platform
```

After installing, check that it works:

```bash
typst --version
```

This template was developed and tested with Typst 0.15, so we recommend using the same version or a newer one.

### Get the project

This repository is a GitHub **template repository**. Please use **Use this template** to create your own thesis project:

1. Click the green **Use this template** button at the top right, then choose **Create a new repository**.
2. Enter a name for the project (for example, `my-thesis`). We recommend setting the visibility to **Private**.
3. When the repository is created, clone it to your computer:

```bash
git clone https://github.com/<your-account>/my-thesis.git
cd my-thesis
```

If you have the [GitHub CLI](https://cli.github.com), one command creates the repository and clones it:

```bash
gh repo create my-thesis --template TW-Thesis/tw-thesis-typ --private --clone
cd my-thesis
```

A project created from a template is a **brand-new repository**. It has only one initial commit, does not contain the template's history, and is not linked to this repository. Later updates to the template are not applied to your project automatically. When you want them, you can compare with the new version and copy over the parts you need.

If you do not use GitHub, you can also choose **Code → Download ZIP** on this page and unzip it.

Run all the commands below from the **project root**, which is the folder that contains both `main.typ` and `config.yml`.

### Compile

Once you have the project on your computer, try compiling it:

```bash
typst compile main.typ --font-path fonts/
```

A `main.pdf` file will appear in the project root. Open it and check that the cover page, the table of contents and the body text all display correctly, including the Chinese and English fonts.

- `--font-path fonts/` tells Typst to use the fonts that come with the project (EB Garamond, Tinos and the Ministry of Education Standard Kai typeface), so you do not need to install them on your system.
- **You need an internet connection the first time you compile.** The template downloads a few Typst packages (`kouhu` and `ipsum`, which provide the sample text). They are cached afterwards, so later compilations work offline.
- If you see the warning `unknown font family: dfkai-sb`, you can ignore it. It refers to a backup font and does not affect the result.

### Fill in your information

Open `config.yml` in any text editor. Replace the title, name, department and date with your own, and uncomment the `school` line with your school's code:

```yaml
school: nccu              # uses schools/nccu.yml; see "Supported schools" below

title: "Thesis title in Chinese"
title-en: "A Study on Consistency in Distributed Systems"

author: "Author name in Chinese"
author-en: "Wang, Xiao-Ming"
advisor: "Advisor name in Chinese"
advisor-en: "Chen, Da-Wen"

institute: "Department name in Chinese"
institute-en: "Department of Computer Science"

date: "2027-01-15"        # date on the cover, in YYYY-MM-DD format
```

The fields without `-en` hold the Chinese text, so replace the placeholders above with your Chinese title, name, advisor and department. The fields ending in `-en` hold the English text. Fill in both, or the cover page will be missing one of the languages. Compile again and check the cover page and the verification page. When you choose a school, the format (margins, font sizes, cover style and so on) follows that school's preset. If you do not choose one, the default format is used.

If you want to change a setting that the school preset does not cover, for example setting only the top margin to 3.5 cm, just write it in `config.yml`. It has the highest priority, so you do not have to edit anything in `schools/`. Every available setting and its unit is documented in `schools/default.yml`.

### Write your thesis

The content of your thesis is in `contents/`, organised like this:

```text
contents/
├── front/           abstract, acknowledgements, list of symbols, etc.
├── chapter01.typ    the chapters start here
├── chapter02.typ
├── chapter03.typ
├── chapter04.typ
├── back/            appendices and the bibliography
└── i18n/en/         English version of the tutorial
```

When you first copy the project, these files contain the tutorial. They are also examples you can learn from.

The order of the chapters is set in `main.typ`. To add or remove a chapter, add or delete the matching `#include` line:

```typ
#include "contents/chapter01.typ"
#include "contents/chapter02.typ"
```

References go in `contents/back/references.bib`. In the text, cite an entry by its key. For example, `references.bib` contains an entry called `kocher99`:

```typ
#cp("kocher99")
```

The English version of the tutorial is in `contents/i18n/en/`. It is not part of your thesis. To see it as a document of its own, with English prefixes (Figure, Table, Chapter, Section), run `just compile-en`.

### Edit and preview

If you want to see the result while you write, use watch mode. The PDF is rebuilt every time you save a file:

```bash
typst watch main.typ --font-path fonts/
```

If you use VS Code, install the [Tinymist](https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist) extension to preview the document directly. The project already includes a `.vscode/settings.json` file that sets the main file and the font path, so you only need to open the folder.

If your school requires a watermark when you submit, first set the watermark image in the configuration file (this is explained in Chapter 2 of the tutorial), then compile with the following command:

```bash
typst compile main.typ --font-path fonts/ --input watermark=true
```

If you have [`just`](https://github.com/casey/just) installed, the commands above can be shortened to:

```bash
just compile   # normal build
just watch     # rebuild every time you save
just release   # build with the watermark
just clean     # delete main.pdf
```

## Supported schools

| Code | School | Chinese name | Regulation version |
|---|---|---|---|
| [`aeust`](schools/aeust.yml) | Asia Eastern University of Science and Technology | 亞東科技大學 | [28 Jul 2021](docs/亞東科技大學-1100728-碩博士論文規範.pdf) |
| [`asia`](schools/asia.yml) | Asia University | 亞洲大學 | [18 Nov 2020](docs/亞洲大學-1091118-碩博士論文規範.pdf) |
| [`au`](schools/au.yml) | Aletheia University | 真理大學 | [27 May 2024](docs/真理大學-1130527-碩博士論文規範.pdf) |
| [`ccu`](schools/ccu.yml) | National Chung Cheng University | 國立中正大學 | [Jan 2001](docs/國立中正大學-0900100-碩博士論文規範.pdf) |
| [`cgu`](schools/cgu.yml) | Chang Gung University | 長庚大學 | [16 Jul 2021](docs/長庚大學-1100716-碩博士論文規範.pdf) |
| [`cgust`](schools/cgust.yml) | Chang Gung University of Science and Technology | 長庚科技大學 | [9 Jun 2025](docs/長庚科技大學-1140609-碩博士論文規範.pdf) |
| [`chihlee`](schools/chihlee.yml) | Chihlee University of Technology | 致理科技大學 | [25 Jan 2016](docs/致理科技大學-1050125-碩博士論文規範.pdf) |
| [`chu`](schools/chu.yml) | Chung Hua University | 中華大學 | [14 Sep 2022](docs/中華大學-1110914-碩博士論文規範.pdf) |
| [`cjcu`](schools/cjcu.yml) | Chang Jung Christian University | 長榮大學 | [13 Mar 2018](docs/長榮大學-1070313-碩博士論文規範.pdf) |
| [`cmu`](schools/cmu.yml) | China Medical University | 中國醫藥大學 | [8 Aug 2022](docs/中國醫藥大學-1110808-碩博士論文規範.pdf) |
| [`cnu`](schools/cnu.yml) | Chia Nan University of Pharmacy & Science | 嘉南藥理大學 | [13 Oct 2020](docs/嘉南藥理大學-1091013-碩博士論文規範.pdf) |
| [`cpu`](schools/cpu.yml) | Central Police University | 中央警察大學 | [28 Apr 2020](docs/中央警察大學-1090428-碩博士論文規範.pdf) |
| [`csmu`](schools/csmu.yml) | Chung Shan Medical University | 中山醫學大學 | [13 May 2026](docs/中山醫學大學-1150513-碩博士論文規範.pdf) |
| [`csu`](schools/csu.yml) | Cheng Shiu University | 正修科技大學 | [11 Feb 2026](docs/正修科技大學-1150211-碩博士論文規範.pdf) |
| [`ctbctech`](schools/ctbctech.yml) | CTBC UNIVERSITY OF TECHNOLOGY | 中信科技大學 | [16 Jan 2025](docs/中信科技大學-1140116-碩博士論文規範.pdf) |
| [`ctu`](schools/ctu.yml) | Chienkuo Technology University | 建國科技大學 | [28 Jul 2022](docs/建國科技大學-1110728-碩博士論文規範.pdf) |
| [`ctust`](schools/ctust.yml) | Central Taiwan University of Science and Technology | 中臺科技大學 | [18 Jul 2017](docs/中臺科技大學-1060718-碩博士論文規範.pdf) |
| [`cufa`](schools/cufa.yml) | Chungyu University of Film and Arts | 崇右影藝科技大學 | [3 Feb 2015](docs/崇右影藝科技大學-1040203-碩博士論文規範.pdf) |
| [`cust`](schools/cust.yml) | China University of Science and Technology | 中華科技大學 | [10 May 2018](docs/中華科技大學-1070510-碩博士論文規範.pdf) |
| [`cute`](schools/cute.yml) | China University of Technology | 中國科技大學 | [Feb 2016](docs/中國科技大學-1050200-碩博士論文規範.pdf) |
| [`cycu`](schools/cycu.yml) | Chung Yuan Christian University | 中原大學 | [21 Jan 2026](docs/中原大學-1150121-碩博士論文規範.pdf) |
| [`cyut`](schools/cyut.yml) | Chaoyang University of Technology | 朝陽科技大學 | [16 Oct 2026](docs/朝陽科技大學-1151016-碩博士論文規範.pdf) |
| [`dyu`](schools/dyu.yml) | Da-Yeh University | 大葉大學 | [15 Dec 2025](docs/大葉大學-1141215-碩博士論文規範.pdf) |
| [`fcu`](schools/fcu.yml) | Feng Chia University | 逢甲大學 | [18 Mar 2022](docs/逢甲大學-1110318-碩博士論文規範.pdf) |
| [`fgu`](schools/fgu.yml) | Fo Guang University | 佛光大學 | [6 Jan 2021](docs/佛光大學-1100106-碩博士論文規範.pdf) |
| [`fju`](schools/fju.yml) | Fu Jen Catholic University | 輔仁大學 | [2 May 2002](docs/輔仁大學-0910502-碩博士論文規範.pdf) |
| [`fy`](schools/fy.yml) | Fooyin University | 輔英科技大學 | [4 Mar 2026](docs/輔英科技大學-1150304-碩博士論文規範.pdf) |
| [`hcu`](schools/hcu.yml) | Hsuan Chuang University | 玄奘大學 | [4 Oct 2023](docs/玄奘大學-1121004-碩博士論文規範.pdf) |
| [`hdut`](schools/hdut.yml) | Hungkuo Delin University of Technology | 宏國德霖科技大學 | [29 Dec 2021](docs/宏國德霖科技大學-1101229-碩博士論文規範.pdf) |
| [`hfu`](schools/hfu.yml) | Huafan University | 華梵大學 | [3 Jun 2020](docs/華梵大學-1090603-碩博士論文規範.pdf) |
| [`hk`](schools/hk.yml) | Hungkuang University | 弘光科技大學 | [Dec 2020](docs/弘光科技大學-1091200-碩博士論文規範.pdf) |
| [`hust`](schools/hust.yml) | Hsiuping University of Science and Technology | 修平科技大學 | [2 Dec 2011](docs/修平科技大學-1001202-碩博士論文規範.pdf) |
| [`hwai`](schools/hwai.yml) | Chung Hwa University of Medical Technology | 中華醫事科技大學 | [26 Jan 2021](docs/中華醫事科技大學-1100126-碩博士論文規範.pdf) |
| [`hwh`](schools/hwh.yml) | Hwa Hsia University of Technology | 華夏科技大學 | [22 Feb 2023](docs/華夏科技大學-1120222-碩博士論文規範.pdf) |
| [`hwu`](schools/hwu.yml) | Hsing Wu University of Science and Technology | 醒吾科技大學 | [6 Sep 2017](docs/醒吾科技大學-1060906-碩博士論文規範.pdf) |
| [`isu`](schools/isu.yml) | I-Shou University | 義守大學 | [30 Apr 2026](docs/義守大學-1150430-碩博士論文規範.pdf) |
| [`just`](schools/just.yml) | Jinwen University of Science and Technology | 景文科技大學 | [Jun 2021](docs/景文科技大學-1100600-碩博士論文規範.pdf) |
| [`kmu`](schools/kmu.yml) | Kaohsiung Medical University | 高雄醫學大學 | [18 Jun 2025](docs/高雄醫學大學-1140618-碩博士論文規範.pdf) |
| [`knu`](schools/knu.yml) | Kainan University | 開南大學 | [8 Apr 2020](docs/開南大學-1090408-碩博士論文規範.pdf) |
| [`ksu`](schools/ksu.yml) | Kun Shan University | 崑山科技大學 | [3 Dec 2018](docs/崑山科技大學-1071203-碩博士論文規範.pdf) |
| [`lhu`](schools/lhu.yml) | Lunghwa University of Science and Technology | 龍華科技大學 | [5 Jun 2025](docs/龍華科技大學-1140605-碩博士論文規範.pdf) |
| [`ltu`](schools/ltu.yml) | Ling Tung University | 嶺東科技大學 | [2 Jan 2025](docs/嶺東科技大學-1140102-碩博士論文規範.pdf) |
| [`mcu`](schools/mcu.yml) | Ming Chuan University | 銘傳大學 | [undated](docs/銘傳大學-0000000-碩博士論文規範.pdf) |
| [`mcut`](schools/mcut.yml) | Ming Chi University of Technology | 明志科技大學 | [4 Nov 2025](docs/明志科技大學-1141104-碩博士論文規範.pdf) |
| [`meiho`](schools/meiho.yml) | Meiho University | 美和科技大學 | [12 May 2025](docs/美和科技大學-1140512-碩博士論文規範.pdf) |
| [`mmu`](schools/mmu.yml) | MacKay Medical University | 馬偕醫學大學 | [22 May 2026](docs/馬偕醫學大學-1150522-碩博士論文規範.pdf) |
| [`must`](schools/must.yml) | Minghsin University of Science and Technology | 明新科技大學 | [29 May 2023](docs/明新科技大學-1120529-碩博士論文規範.pdf) |
| [`nccu`](schools/nccu.yml) | National Chengchi University | 國立政治大學 | [23 Dec 2024](docs/國立政治大學-1131223-碩博士論文規範.pdf) |
| [`nchu`](schools/nchu.yml) | National Chung Hsing University | 國立中興大學 | [21 Apr 2022](docs/國立中興大學-1110421-碩博士論文規範.pdf) |
| [`ncku`](schools/ncku.yml) | National Cheng Kung University | 國立成功大學 | [6 Jan 2021](docs/國立成功大學-1100106-碩博士論文規範.pdf) |
| [`ncnu`](schools/ncnu.yml) | National Chi Nan University | 國立暨南國際大學 | [1 Nov 2021](docs/國立暨南國際大學-1101101-碩博士論文規範.pdf) |
| [`ncu`](schools/ncu.yml) | National Central University | 國立中央大學 | [27 Jan 2016](docs/國立中央大學-1050127-碩博士論文規範.pdf) |
| [`ncue`](schools/ncue.yml) | National Changhua University of Education | 國立彰化師範大學 | [15 Dec 2021](docs/國立彰化師範大學-1101215-碩博士論文規範.pdf) |
| [`ncut`](schools/ncut.yml) | National Chin-Yi University of Technology | 國立勤益科技大學 | [16 Jul 2025](docs/國立勤益科技大學-1140716-碩博士論文規範.pdf) |
| [`ncyu`](schools/ncyu.yml) | National Chiayi University | 國立嘉義大學 | [25 Nov 2025](docs/國立嘉義大學-1141125-碩博士論文規範.pdf) |
| [`ndhu`](schools/ndhu.yml) | National Dong Hwa University | 國立東華大學 | [8 Dec 2023](docs/國立東華大學-1121208-碩博士論文規範.pdf) |
| [`ndmu`](schools/ndmu.yml) | National Defense Medical University | 國防醫學大學 | [13 Nov 2025](docs/國防醫學大學-1141113-碩博士論文規範.pdf) |
| [`ndu`](schools/ndu.yml) | National Defense University | 國防大學 | [undated](docs/國防大學-0000000-碩博士論文規範.pdf) |
| [`nfu`](schools/nfu.yml) | National Formosa University | 國立虎尾科技大學 | [26 Jul 2022](docs/國立虎尾科技大學-1110726-碩博士論文規範.pdf) |
| [`nhu`](schools/nhu.yml) | Nanhua university | 南華大學 | [15 Dec 2019](docs/南華大學-1081215-碩博士論文規範.pdf) |
| [`niu`](schools/niu.yml) | National Ilan University | 國立宜蘭大學 | [20 Dec 2022](docs/國立宜蘭大學-1111220-碩博士論文規範.pdf) |
| [`nknu`](schools/nknu.yml) | National Kaohsiung Normal University | 國立高雄師範大學 | [24 Aug 2021](docs/國立高雄師範大學-1100824-碩博士論文規範.pdf) |
| [`nkuht`](schools/nkuht.yml) | National Kaohsiung University of Hospitality and Tourism | 國立高雄餐旅大學 | [29 Oct 2021](docs/國立高雄餐旅大學-1101029-碩博士論文規範.pdf) |
| [`nkust`](schools/nkust.yml) | National Kaohsiung University of Science and Technology | 國立高雄科技大學 | [Mar 2022](docs/國立高雄科技大學-1110300-碩博士論文規範.pdf) |
| [`nkut`](schools/nkut.yml) | Nan Kai University of Technology | 南開科技大學 | [19 Dec 2012](docs/南開科技大學-1011219-碩博士論文規範.pdf) |
| [`nptu`](schools/nptu.yml) | National Pingtung University | 國立屏東大學 | [13 Jun 2023](docs/國立屏東大學-1120613-碩博士論文規範.pdf) |
| [`npu`](schools/npu.yml) | National Penghu University of Science and Technology | 國立澎湖科技大學 | [undated](docs/國立澎湖科技大學-0000000-碩博士論文規範.pdf) |
| [`npust`](schools/npust.yml) | National Pingtung University of Science and Technology | 國立屏東科技大學 | [12 Apr 2022](docs/國立屏東科技大學-1110412-碩博士論文規範.pdf) |
| [`nqu`](schools/nqu.yml) | National Quemoy University | 國立金門大學 | [29 Jun 2022](docs/國立金門大學-1110629-碩博士論文規範.pdf) |
| [`nsysu`](schools/nsysu.yml) | National Sun Yat-sen University | 國立中山大學 | [15 Mar 2022](docs/國立中山大學-1110315-碩博士論文規範.pdf) |
| [`ntcu`](schools/ntcu.yml) | National Taichung University of Education | 國立臺中教育大學 | [15 Jan 2024](docs/國立臺中教育大學-1130115-碩博士論文規範.pdf) |
| [`nthu`](schools/nthu.yml) | National Tsing Hua University | 國立清華大學 | [29 May 2025](docs/國立清華大學-1140529-碩博士論文規範.pdf) |
| [`ntnu`](schools/ntnu.yml) | National Taiwan Normal University | 國立臺灣師範大學 | [5 Mar 2025](docs/國立臺灣師範大學-1140305-碩博士論文規範.pdf) |
| [`ntou`](schools/ntou.yml) | National Taiwan Ocean University | 國立臺灣海洋大學 | [6 Aug 2025](docs/國立臺灣海洋大學-1140806-碩博士論文規範.pdf) |
| [`ntpu`](schools/ntpu.yml) | National Taipei University | 國立臺北大學 | [16 Aug 2022](docs/國立臺北大學-1110816-碩博士論文規範.pdf) |
| [`ntsu`](schools/ntsu.yml) | National Taiwan Sport University | 國立體育大學 | [30 May 2024](docs/國立體育大學-1130530-碩博士論文規範.pdf) |
| [`nttu`](schools/nttu.yml) | National Taitung University | 國立臺東大學 | [2 Jun 2022](docs/國立臺東大學-1110602-碩博士論文規範.pdf) |
| [`ntu`](schools/ntu.yml) | National Taiwan University | 國立臺灣大學 | [20 Oct 2023](docs/國立臺灣大學-1121020-碩博士論文規範.pdf) |
| [`ntua`](schools/ntua.yml) | National Taiwan University of Arts | 國立臺灣藝術大學 | [1 Jun 2026](docs/國立臺灣藝術大學-1150601-碩博士論文規範.pdf) |
| [`ntub`](schools/ntub.yml) | National Taipei University of  Business | 國立臺北商業大學 | [undated](docs/國立臺北商業大學-0000000-碩博士論文規範.pdf) |
| [`ntue`](schools/ntue.yml) | National Taipei University of Education | 國立臺北教育大學 | [22 Apr 2026](docs/國立臺北教育大學-1150422-碩博士論文規範.pdf) |
| [`ntunhs`](schools/ntunhs.yml) | National Taipei University of Nursing and Health Sciences | 國立臺北護理健康大學 | [undated](docs/國立臺北護理健康大學-0000000-碩博士論文規範.pdf) |
| [`ntus`](schools/ntus.yml) | National Taiwan University of Sport | 國立臺灣體育運動大學 | [21 Jan 2026](docs/國立臺灣體育運動大學-1150121-碩博士論文規範.pdf) |
| [`ntust`](schools/ntust.yml) | National Taiwan University of Science and Technology | 國立臺灣科技大學 | [24 Dec 2024](docs/國立臺灣科技大學-1131224-碩博士論文規範.pdf) |
| [`ntut`](schools/ntut.yml) | National Taipei University of Technology | 國立臺北科技大學 | [1 Feb 2025](docs/國立臺北科技大學-1140201-碩博士論文規範.pdf) |
| [`nuk`](schools/nuk.yml) | National University of Kaohsiung | 國立高雄大學 | [26 Aug 2016](docs/國立高雄大學-1050826-碩博士論文規範.pdf) |
| [`nutc`](schools/nutc.yml) | National  Taichung University Of  Science And Technology | 國立臺中科技大學 | [19 May 2025](docs/國立臺中科技大學-1140519-碩博士論文規範.pdf) |
| [`nutn`](schools/nutn.yml) | National University of Tainan | 國立臺南大學 | [11 Aug 2021](docs/國立臺南大學-1100811-碩博士論文規範.pdf) |
| [`nuu`](schools/nuu.yml) | National United University | 國立聯合大學 | [2 Jul 2021](docs/國立聯合大學-1100702-碩博士論文規範.pdf) |
| [`nycu`](schools/nycu.yml) | National Yang Ming Chiao Tung University | 國立陽明交通大學 | [17 Sep 2026](docs/國立陽明交通大學-1150917-碩博士論文規範.pdf) |
| [`ocu`](schools/ocu.yml) | Overseas Chinese University | 僑光科技大學 | [undated](docs/僑光科技大學-0000000-碩博士論文規範.pdf) |
| [`pccu`](schools/pccu.yml) | Chinese Culture University | 中國文化大學 | [30 Mar 2026](docs/中國文化大學-1150330-碩博士論文規範.pdf) |
| [`pu`](schools/pu.yml) | Providence University | 靜宜大學 | [28 May 2020](docs/靜宜大學-1090528-碩博士論文規範.pdf) |
| [`scu`](schools/scu.yml) | Soochow University | 東吳大學 | [28 May 2026](docs/東吳大學-1150528-碩博士論文規範.pdf) |
| [`shu`](schools/shu.yml) | Shih Hsin University | 世新大學 | [undated](docs/世新大學-0000000-碩博士論文規範.pdf) |
| [`sju`](schools/sju.yml) | St. John’s University | 聖約翰科技大學 | [22 Sep 2026](docs/聖約翰科技大學-1150922-碩博士論文規範.pdf) |
| [`stu`](schools/stu.yml) | Shu-Te University | 樹德科技大學 | [undated](docs/樹德科技大學-0000000-碩博士論文規範.pdf) |
| [`stust`](schools/stust.yml) | Southern Taiwan University of Science and Technology | 南臺科技大學 | [29 May 2018](docs/南臺科技大學-1070529-碩博士論文規範.pdf) |
| [`tajen`](schools/tajen.yml) | Tajen University | 大仁科技大學 | [19 Oct 2005](docs/大仁科技大學-0941019-碩博士論文規範.pdf) |
| [`takming`](schools/takming.yml) | Takming University of Science and Technology | 德明財經科技大學 | [8 May 2023](docs/德明財經科技大學-1120508-碩博士論文規範.pdf) |
| [`tcu`](schools/tcu.yml) | Tzu Chi University | 慈濟大學 | [15 Mar 2021](docs/慈濟大學-1100315-碩博士論文規範.pdf) |
| [`thu`](schools/thu.yml) | Tunghai University | 東海大學 | [8 Nov 2023](docs/東海大學-1121108-碩博士論文規範.pdf) |
| [`tku`](schools/tku.yml) | Tamkang University | 淡江大學 | [9 Dec 2025](docs/淡江大學-1141209-碩博士論文規範.pdf) |
| [`tmu`](schools/tmu.yml) | Taipei Medical University | 臺北醫學大學 | [18 Nov 2026](docs/臺北醫學大學-1151118-碩博士論文規範.pdf) |
| [`tnnua`](schools/tnnua.yml) | Tainan National University of the Arts | 國立臺南藝術大學 | [28 May 2026](docs/國立臺南藝術大學-1150528-碩博士論文規範.pdf) |
| [`tnu`](schools/tnu.yml) | Tungnan University | 東南科技大學 | [27 Dec 2018](docs/東南科技大學-1071227-碩博士論文規範.pdf) |
| [`tnua`](schools/tnua.yml) | Taipei National University of the Arts | 國立臺北藝術大學 | [18 May 2011](docs/國立臺北藝術大學-1000518-碩博士論文規範.pdf) |
| [`tpcu`](schools/tpcu.yml) | Taipei City University of Science and Technology | 臺北城市科技大學 | [27 Dec 2021](docs/臺北城市科技大學-1101227-碩博士論文規範.pdf) |
| [`tsust`](schools/tsust.yml) | Taiwan Steel University of Science and Technology | 台鋼科技大學 | [undated](docs/台鋼科技大學-0000000-碩博士論文規範.pdf) |
| [`ttu`](schools/ttu.yml) | Tatung University | 大同大學 | [12 Aug 2026](docs/大同大學-1150812-碩博士論文規範.pdf) |
| [`tumt`](schools/tumt.yml) | Taipei University of Marine Technology | 台北海洋科技大學 | [30 Mar 2022](docs/台北海洋科技大學-1110330-碩博士論文規範.pdf) |
| [`tut`](schools/tut.yml) | Tainan University of Technology | 台南應用科技大學 | [21 Feb 2025](docs/台南應用科技大學-1140221-碩博士論文規範.pdf) |
| [`uch`](schools/uch.yml) | Chien Hsin University of Science and Technology | 健行科技大學 | [23 Apr 2026](docs/健行科技大學-1150423-碩博士論文規範.pdf) |
| [`ukn`](schools/ukn.yml) | University of Kang Ning | 康寧大學 | [5 May 2014](docs/康寧大學-1030505-碩博士論文規範.pdf) |
| [`usc`](schools/usc.yml) | Shih Chien University | 實踐大學 | [25 May 2026](docs/實踐大學-1150525-碩博士論文規範.pdf) |
| [`vnu`](schools/vnu.yml) | Vanung University | 萬能科技大學 | [16 Feb 2017](docs/萬能科技大學-1060216-碩博士論文規範.pdf) |
| [`wfu`](schools/wfu.yml) | WuFeng University | 吳鳳科技大學 | [undated](docs/吳鳳科技大學-0000000-碩博士論文規範.pdf) |
| [`wzu`](schools/wzu.yml) | Wenzao Ursuline University of Languages | 文藻外語大學 | [1 Apr 2023](docs/文藻外語大學-1120401-碩博士論文規範.pdf) |
| [`ydu`](schools/ydu.yml) | Yu Da University of Science and Technology | 育達科技大學 | [17 Dec 2025](docs/育達科技大學-1141217-碩博士論文規範.pdf) |
| [`ypu`](schools/ypu.yml) | Yuanpei University of Medical Technology | 元培醫事科技大學 | [2 Apr 2026](docs/元培醫事科技大學-1150402-碩博士論文規範.pdf) |
| [`yuntech`](schools/yuntech.yml) | National Yunlin University of Science & Technology | 國立雲林科技大學 | [1 Sep 2025](docs/國立雲林科技大學-1140901-碩博士論文規範.pdf) |
| [`yzu`](schools/yzu.yml) | Yuan Ze University | 元智大學 | [23 Nov 2023](docs/元智大學-1121123-碩博士論文規範.pdf) |

Official source PDFs are kept in [`docs/`](docs/). Each preset records its evidence, scope and unsupported requirements. See [`docs/COVERAGE.en.md`](docs/COVERAGE.en.md) for coverage and exclusions.

## Project structure

| Path | Purpose |
|---|---|
| `config.yml` | Your thesis information and settings |
| `main.typ` | Binding order: front matter, chapters, references, appendices |
| `contents/` | Thesis content (the tutorial chapters are the sample) |
| `schools/` | Format presets for each school; `default.yml` is the only source of default values |
| `i18n/` | Wording that depends on the language (Chinese and English) |
| `lib/`, `helper/` | The template core and the helper functions for this thesis |
| `fonts/`, `assets/`, `docs/` | Fonts, watermarks and each school's regulation PDFs |

## Contributing

New schools, format fixes and improvements to the tutorial are all welcome. Please read [CONTRIBUTING.md](CONTRIBUTING.md) first.

## License

The code and the tutorial text are released under the [MIT license](LICENSE). Fonts, school emblems and the schools' regulation documents are not covered by this license. See [THIRD_PARTY.md](THIRD_PARTY.md) for details.
