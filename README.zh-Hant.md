# Cassotis IME - 言泉輸入法

<p align="center">
  <img src="docs/images/cassotis-logo.png" alt="Cassotis IME - 言泉輸入法 logo" width="280">
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-GPL--3.0-blue" alt="License: GPL-3.0"></a>
  <a href="COMPATIBILITY.md"><img src="https://img.shields.io/badge/platform-macOS-000000?logo=apple&amp;logoColor=white" alt="Platform: macOS"></a>
  <a href="BUILD.md"><img src="https://img.shields.io/badge/arch-Apple%20Silicon-5a67d8" alt="Architecture: Apple Silicon"></a>
</p>

<p align="center">
  <img src="docs/images/macos-preview.png" alt="言泉輸入法 macOS 版晴白、青瓷與靛夜主題的候選視窗和 Tab 補全展示" width="600">
</p>

<p align="center"><sub>macOS 原生候選視窗 · Tab 補全 · 晴白、青瓷與靛夜主題</sub></p>

[English](README.md) | [簡體中文](README.zh-Hans.md) | 繁體中文

Cassotis IME - 言泉輸入法是一款面向 macOS 的開源中文拼音輸入法，提供原生候選視窗、本機語言模型與儲存在本機的使用者詞學習。

[官網](https://www.yanquan.org/mac) · [下載安裝套件](https://github.com/shenmin/cassotis-ime-mac/releases) · [Windows](https://github.com/shenmin/cassotis-ime) · [Linux](https://github.com/shenmin/cassotis-ime-linux)

採用 **InputMethodKit / AppKit 前端與 Free Pascal 獨立引擎處理程序**，融入 macOS 原生文字輸入。詞庫與模型隨套件提供，候選排序、句子修正及 Tab 補全皆在本機完成。

開發中的 **2.0.0**（build **4**）支援 Apple Silicon 與 macOS 14 及以上，尚未正式發行；目前正式版為 **1.0.0**。已驗證範圍與已知限制請見 [COMPATIBILITY.md](COMPATIBILITY.md)。

## 主要功能

- 全拼、簡拼與微軟／小鶴／自然碼／搜狗／紫光／拼音加加雙拼，支援簡繁詞庫、模糊音及分段選詞。
- 一個約 1.5 億參數的本機字符級語言模型統一負責長句、短詞、一鍵補全、Tab 續寫及拼音約束修正；安裝資源只含一個神經模型。
- 長句逐鍵輸入與整串輸入使用一致的解碼路徑，改善首選與第二候選，同時保護使用者學習及完整精確詞的固定首選。
- 三至五音節片語可由模型結合前文產生，再依拼音修正同音字，例如 `jiuguize` →「舊規則」；明確選取過的片語可以被記住。
- [U/I/V 快捷輸入](QUICK_INPUT.md)：符號、序號、數學符號、箭頭、單位、中文標點、日期、時間、星期，以及中文數字和金額大寫。雙拼下以 Shift+U/I/V 進入，數字轉換以 A/B/C/D 選詞。
- 連續輸入數字後按句號鍵自動輸出小數點，預設開啟，可在設定中立即關閉。
- 預設兩行候選視窗，可於翻頁時展開三行候選：每行最多九項，切換行時文字位置保持穩定；始終保留 Tab 區，右下顯示 logo 與版本，使用者詞可點選小紅 × 刪除。
- 橫排候選不換行、預設 14 點字級、八種配色與即時預覽；原生候選視窗不會搶走輸入焦點。
- 切換中英文或從其他輸入法切入言泉時，游標旁的短暫氣泡顯示言泉 logo 與「中」或「英」，避開附近系統游標標誌，輸入時自動收起。
- 左側分類設定、字體名稱補全、直接按鍵錄製快捷鍵，確定選項後自動儲存；預設按應用程式記住中英文狀態，記錄檔預設關閉。
- 修飾鍵單獨切換使用系統事件計數防止組合鍵誤觸，不需 HID、輸入監控或輔助使用權限；保留 macOS 系統快捷鍵與安全密碼欄位行為。
- Tab 比較詞庫補全、後續片語與下一個字建議；短詞先顯示詞庫結果，再於背景重排。沒有預測提示時，可精確拼接已輸入的拼音，使用一般文字色區分。
- 拼音診斷保守標示異常輸入，不改動原文；共用使用者詞依簡繁模式轉換顯示，專業詞支援精確輸入。
- 所有推論透過 CPU ONNX Runtime 在本機完成。詞庫與模型隨套件提供，安裝後不需編譯器、Python 或網路服務。

## 安裝與試用

一般使用者下載並開啟 DMG，按兩下其中的「言泉输入法安装器」，再點選「安装」。安裝程式會自動請求啟用；若 macOS 顯示確認視窗，請點選「允許」。顯示「安装完成」後，直接從選單列的輸入選單選用「言泉输入法」，選取時會顯示彩色言泉 logo。輸入 `nihao` 後按空白鍵，即可試打「你好」。若尚未啟用，可點選「重试启用」，或透過「打开键盘设置」手動加入。

macOS 27 可能只開啟鍵盤設定而未顯示確認視窗。請在「文字輸入 → 編輯 → + → 中文（簡體）」中加入「言泉输入法」，再返回安裝程式；安裝程式會自動核實啟用狀態。

圖形安裝程式會顯示進度，升級時保留設定與學習紀錄，失敗時提供記錄檔與重試選項。使用時不需要終端機、編譯器、Python 或另外下載模型。正式安裝包使用 `cassotis-ime-macos-<版本號>-arm64-installer-signed.dmg` 檔名，經 Sunisoft Limited 的 Developer ID 簽章並完成 Apple 公證。安裝程式也提供解除安裝功能；請先從系統設定移除輸入來源。

## 基準測試

以下使用相同完整語料，比較 macOS v2.0.0 與前一版 v1.0.0。表中版本號均為 macOS 產品版本。

語料來自開發者自己的小說著作 [《永恆的舞動》](https://www.qidian.com/book/1037259117/)。

兩版均在 Apple M2 Pro、32 GiB 記憶體、macOS 27.0.1 上以原生 arm64 程式測量。v1.0.0 保留發行時的實測耗時，沒有在本輪重新執行舊版。

### Cassotis 長句語料基準測試-16300

| macOS 版本 | Top1 | Top2 | 平均 (ms) | P50 (ms) | P95 (ms) | 最大 (ms) |
| --- | --- | --- | --- | --- | --- | --- |
| `v2.0.0` | 13,381/16,300 (82.09%) | 14,268/16,300 (87.53%) | 86.921 | 83 | 144 | 508 |
| `v1.0.0` | 12,941/16,300 (79.39%) | 13,534/16,300 (83.03%) | 85.043 | 79 | 148 | 567 |

### 短詞上下文基準測試-65000

| macOS 版本 | Top1 | Top2 | 競爭詞 Top1 | 競爭詞 Top2 | 平均 (ms) | P50 (ms) | P95 (ms) | 最大 (ms) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `v2.0.0` | 63,361/65,000 (97.48%) | 64,290/65,000 (98.91%) | 10,533/11,728 (89.81%) | 11,244/11,728 (95.87%) | 7.018 | 5 | 19 | 57 |
| `v1.0.0` | 63,036/65,000 (96.98%) | 64,103/65,000 (98.62%) | 10,488/11,728 (89.43%) | 11,196/11,728 (95.46%) | 6.801 | 6 | 17 | 40 |

「競爭詞」是同一拼音對應至少兩個目標詞的 11,728 例子集。

### 一鍵補全上下文基準測試-12831

| macOS 版本 | 補全命中率 | 平均節省按鍵 | 逐鍵穩定率 | 按鍵 P95 (ms) | 最終顯示 P95 (ms) |
| --- | --- | --- | --- | --- | --- |
| `v2.0.0` | 10,441/12,831 (81.37%) | 2.633 | 2,126/2,188 (97.17%) | 1.897 | 18.718 |
| `v1.0.0` | 10,331/12,831 (80.52%) | 2.638 | 2,117/2,180 (97.11%) | 1.213 | 9.385 |

平均節省按鍵按每次正確補全計算，已扣除接受補全的一次按鍵；逐鍵穩定率只統計繼續輸入後原補全仍相容的機會。 v2.0.0 短詞補全累計淨節省 27,491 鍵，v1.0.0 為 27,250 鍵。

### Cassotis 長句一鍵補全基準測試-16300

每條長句保留末尾四個拼音音節不輸入，評估介面顯示的唯一續寫。覆蓋率僅統計預測提示，不含已輸入拼音的精確拼接，也不代表提示準確率。

| macOS 版本 | 局部續寫命中率 | 預測提示覆蓋率 | 總節省按鍵 | P95 (ms) |
| --- | --- | --- | --- | --- |
| `v2.0.0` | 3,761/16,300 (23.07%) | 16,120/16,300 (98.90%) | 9,296 | 131 |
| `v1.0.0` | 3,539/16,300 (21.71%) | 15,812/16,300 (97.01%) | 7,539 | 131 |

兩版長句補全均使用 80 ms 結果預算，並將相同位置的「他/她」視為等價；短詞補全及逐鍵穩定性仍嚴格比對。表中延遲為引擎查詢或補全過程耗時，不含模型冷啟動、InputMethodKit/IPC、候選視窗繪製及實際按鍵間隔。短詞 Tab 的按鍵 P95 不包含背景重排，最終顯示 P95 在提示改變時計入重排耗時。

測試程式、基準工具、語料和逐例報告不隨公開原始碼發行。

發行驗證涵蓋 777 項核心回歸、3,112 條簡繁詞庫案例、模型執行、IPC、組字復原與設定儲存，以及原生文字控制項、WebKit、Chrome、Electron 和 Terminal 中的實際輸入。

## 建置與安裝

開發需要 **Free Pascal 3.2.2、Xcode 命令列工具與 Python 3.11+**，不依賴 Lazarus/LCL。準備 [Cassotis Lexicon v2.0.0](https://github.com/shenmin/cassotis-lexicon/tree/v2.0.0) 的產生資產，將 `CASSOTIS_LEXICON_ROOT` 指向自己的詞庫目錄（`/path/to/...` 為佔位路徑）：

```sh
export CASSOTIS_LEXICON_ROOT="/path/to/cassotis-lexicon"
./build_all.sh
./install.sh
```

應用程式輸出至 `build/arm64/Cassotis.app`，安裝至 `~/Library/Input Methods/Cassotis.app`。從「系統設定 → 鍵盤 → 文字輸入」加入「言泉输入法」，再透過輸入選單啟用。如果系統清單尚未更新，可登出後重新登入。

預設以 Shift 切換中英文、空白鍵或數字鍵選取候選、Tab 接受補全，並以 Ctrl+Shift+F10 開啟設定。預設按應用程式記住中英文狀態，各應用程式分別保留上次的選擇，可在設定中關閉。完整按鍵與資料位置請見 [CONFIGURATION.md](CONFIGURATION.md)。

`./rebuild_all.sh` 會清理建置輸出並完整重建；`./uninstall.sh` 會解除安裝目前使用者的輸入法並保留學習紀錄。建置環境、模型下載與詞庫匯入說明請見 [BUILD.md](BUILD.md)。預設建置使用本機臨時簽章，封裝與簽署方式也請見建置文件。

## 原始碼與授權

引擎衍生自 [Cassotis IME Windows 版](https://github.com/shenmin/cassotis-ime)，Free Pascal 移植基礎與 [Linux 版](https://github.com/shenmin/cassotis-ime-linux) 共用。macOS 2.0.0 納入 Windows 2.0.0 的引擎改進，使用 [Cassotis Lexicon 2.0.0](https://github.com/shenmin/cassotis-lexicon) 詞庫與模型；共用引擎的後續更新繼續跟進 Windows。macOS 版獨立維護原生介面、產品發行與基準歷史。

`src/macos` 是原生前端，`src/service` / `src/ipc` 提供處理程序通訊協定，`src/engine` / `src/dictionary` 為共用的正式核心，`src/host` 負責承載本機模型。模組說明請見[架構文件](docs/ARCHITECTURE.md)。模型/schema 校驗值與詞庫輸入雜湊值分別位於 `data/runtime-assets.sha256` 和 `data/lexicon-inputs.json`，授權與來源請見 [NOTICE.md](NOTICE.md)。應用程式碼採用 GPL-3.0，詞庫採用上游聲明的 CC BY-SA 4.0。
