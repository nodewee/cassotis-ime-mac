# Cassotis IME - 言泉输入法

<p align="center">
  <img src="docs/images/cassotis-logo.png" alt="Cassotis IME - 言泉输入法 logo" width="280">
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-GPL--3.0-blue" alt="License: GPL-3.0"></a>
  <a href="COMPATIBILITY.md"><img src="https://img.shields.io/badge/platform-macOS-000000?logo=apple&amp;logoColor=white" alt="Platform: macOS"></a>
  <a href="BUILD.md"><img src="https://img.shields.io/badge/arch-Apple%20Silicon-5a67d8" alt="Architecture: Apple Silicon"></a>
</p>

<p align="center">
  <img src="docs/images/macos-preview.png" alt="言泉输入法 macOS 版晴白、青瓷与靛夜主题的候选窗和 Tab 补全展示" width="600">
</p>

<p align="center"><sub>macOS 原生候选窗 · Tab 补全 · 晴白、青瓷与靛夜主题</sub></p>

[English](README.md) | 简体中文 | [繁體中文](README.zh-Hant.md)

Cassotis IME - 言泉输入法是一款面向 macOS 的开源中文拼音输入法，提供原生候选窗、本地语言模型和保存在本机的用户词学习。

[官网](https://www.yanquan.org/mac) · [下载安装包](https://github.com/shenmin/cassotis-ime-mac/releases) · [Windows](https://github.com/shenmin/cassotis-ime) · [Linux](https://github.com/shenmin/cassotis-ime-linux)

使用 **InputMethodKit / AppKit 前端与 Free Pascal 独立引擎**，融入 macOS 原生文字输入。词库和模型随包提供，候选排序、句子修正与 Tab 补全均在本机完成。

开发中的 **2.0.0**（build **4**）支持 Apple Silicon 和 macOS 14 及以上，尚未正式发布；当前正式版为 **1.0.0**。已验证范围和已知限制见 [COMPATIBILITY.md](COMPATIBILITY.md)。

## 主要特性

- 全拼、简拼、微软 / 小鹤 / 自然码 / 搜狗 / 紫光 / 拼音加加双拼，支持简繁词库、模糊音和分段选词。
- 一个约 1.5 亿参数的本地字符级语言模型统一负责长句、短词、一键补全、Tab 续写和拼音约束纠错；安装资源只含一个神经模型。
- 长句逐键输入与整串输入使用一致的解码路径，改善首选与第二候选，同时保护用户学习和完整精确词的固定首选。
- 三至五音节短语可由模型结合前文生成，再按拼音修正同音字，例如 `jiuguize` →“旧规则”；显式选择过的短语可以被记住。
- 中文全拼、半角模式可识别英文单词，保留大小写并用空格上屏，中文候选编号不变；默认开启，可在设置中关闭。
- 可设置保持半角的标点符号，默认使用 Markdown 预设，也可切换标准中文标点或自定义。
- [U/I/V 快捷输入](QUICK_INPUT.md)：符号、序号、数学符号、箭头、单位、中文标点、日期、时间、星期，以及中文数字和金额大写。双拼下用 Shift+U/I/V 进入，数字转换用 A/B/C/D 选词。
- 连续输入数字后按句号键自动输出小数点，默认开启，可在设置中立即关闭。
- 默认两行候选窗，可在翻页时展开为三行候选：每行最多九个编号候选，切换行时文字位置保持稳定；始终保留 Tab 区，右下显示 logo 和版本，用户词可点小红 × 删除。
- 横排候选不换行、默认 14 点字号、八种配色和实时预览；原生候选窗不抢输入焦点。
- 切换中英文或从其他输入法切入言泉时，光标旁的短暂气泡显示言泉 logo 和“中”或“英”，避让附近系统光标标志，输入时自动收起。
- 左侧分类设置、字体名称补全、直接按键录制快捷键，确定选项后自动保存；默认按应用记住中英文状态，日志默认关闭。
- 修饰键单独切换使用系统事件计数防止组合键误触，无需 HID、输入监控或辅助功能权限；保留 macOS 系统快捷键和安全密码框行为。
- Tab 比较词库补全、后续短语和下一个字建议；短词先显示词库结果，再后台重排。没有预测提示时，可精确拼接已输入的拼音，使用普通文字色区分。
- 拼音诊断保守标示异常输入，不改动原文；共享用户词随简繁模式转换显示，专业词支持精确输入。
- 所有推理通过 CPU ONNX Runtime 在本机完成。词库和模型随包提供，安装后无需编译器、Python 或联网服务。

## 安装与试用

普通用户下载 DMG，双击其中的“言泉输入法安装器”，点击“安装”。安装器会自动请求启用；若 macOS 弹出确认，点击“允许”。显示“安装完成”后，直接从菜单栏的输入菜单选择言泉输入法，选中时显示彩色言泉 logo。输入 `nihao` 后按空格，可试打“你好”。若尚未启用，可点击“重试启用”，或通过“打开键盘设置”手动添加。

macOS 27 上可能只打开键盘设置而不弹出确认。请在“文字输入 → 编辑 → + → 中文（简体）”中添加“言泉输入法”，再返回安装器；安装器会自动核实启用状态。

图形安装程序显示安装进度，升级保留设置和学习记录，失败时提供日志与重试。使用无需终端、编译器、Python 或另外下载模型。正式安装包使用 `cassotis-ime-macos-<版本号>-arm64-installer-signed.dmg` 文件名，经 Sunisoft Limited 的 Developer ID 签名并完成 Apple 公证。卸载入口也在安装程序中；先通过系统设置移除输入源。

## 基准测试

以下使用相同完整语料，对比 macOS v2.0.0 与前一版 v1.0.0。表中版本号均为 macOS 产品版本。

语料来自开发者自己的小说著作 [《永恒的舞动》](https://www.qidian.com/book/1037259117/)。

两版均在 Apple M2 Pro、32 GiB 内存、macOS 27.0.1 上以原生 arm64 程序测量。v1.0.0 保留发布时的实测耗时，没有在本轮重新运行旧版。

### Cassotis 长句语料基准测试-16300

| macOS 版本 | Top1 | Top2 | 平均 (ms) | P50 (ms) | P95 (ms) | 最大 (ms) |
| --- | --- | --- | --- | --- | --- | --- |
| `v2.0.0` | 13,382/16,300 (82.10%) | 14,270/16,300 (87.55%) | 85.110 | 81 | 141 | 472 |
| `v1.0.0` | 12,941/16,300 (79.39%) | 13,534/16,300 (83.03%) | 85.043 | 79 | 148 | 567 |

### 短词上下文基准测试-65000

| macOS 版本 | Top1 | Top2 | 竞争词 Top1 | 竞争词 Top2 | 平均 (ms) | P50 (ms) | P95 (ms) | 最大 (ms) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `v2.0.0` | 63,361/65,000 (97.48%) | 64,290/65,000 (98.91%) | 10,533/11,728 (89.81%) | 11,244/11,728 (95.87%) | 6.819 | 5 | 19 | 60 |
| `v1.0.0` | 63,036/65,000 (96.98%) | 64,103/65,000 (98.62%) | 10,488/11,728 (89.43%) | 11,196/11,728 (95.46%) | 6.801 | 6 | 17 | 40 |

“竞争词”是同一拼音对应至少两个目标词的 11,728 例子集。

### 一键补全上下文基准测试-12831

| macOS 版本 | 补全命中率 | 平均节省按键 | 逐键稳定率 | 按键 P95 (ms) | 最终显示 P95 (ms) |
| --- | --- | --- | --- | --- | --- |
| `v2.0.0` | 10,441/12,831 (81.37%) | 2.633 | 2,126/2,188 (97.17%) | 1.895 | 19.312 |
| `v1.0.0` | 10,331/12,831 (80.52%) | 2.638 | 2,117/2,180 (97.11%) | 1.213 | 9.385 |

平均节省按键按每次正确补全计算，已扣除接受补全的一次按键；逐键稳定率只统计继续输入后原补全仍兼容的机会。 v2.0.0 短词补全累计净节省 27,491 键，v1.0.0 为 27,250 键。

### Cassotis 长句一键补全基准测试-16300

每条长句保留末尾四个拼音音节不输入，评估界面显示的唯一续写。覆盖率仅统计预测提示，不含已输入拼音的精确拼接，也不代表提示准确率。

| macOS 版本 | 局部续写命中率 | 预测提示覆盖率 | 总节省按键 | P95 (ms) |
| --- | --- | --- | --- | --- |
| `v2.0.0` | 3,764/16,300 (23.09%) | 16,119/16,300 (98.89%) | 9,303 | 134 |
| `v1.0.0` | 3,539/16,300 (21.71%) | 15,812/16,300 (97.01%) | 7,539 | 131 |

两版长句补全均使用 80 ms 结果预算，并将相同位置的“他/她”视为等价；短词补全及逐键稳定性仍严格匹配。表中延迟为引擎查询或补全过程耗时，不含模型冷启动、InputMethodKit/IPC、候选窗绘制及真实按键间隔。短词 Tab 的按键 P95 不包含后台重排，最终显示 P95 在提示改变时计入重排耗时。

测试程序、基准工具、语料和逐例报告不随公开源码分发。

发行验证覆盖 935 项核心回归、3,984 条简繁词库用例、模型运行、IPC、组合输入恢复与设置保存，以及原生文本控件、WebKit、Chrome、Electron 和 Terminal 中的实际输入。

## 构建与安装

开发需要 **Free Pascal 3.2.2、Xcode 命令行工具、Python 3.11+**，不依赖 Lazarus/LCL。准备 [Cassotis Lexicon v2.1.0](https://github.com/shenmin/cassotis-lexicon/tree/v2.1.0) 的生成资产，将 `CASSOTIS_LEXICON_ROOT` 指向自己的词库目录（`/path/to/...` 为占位路径）：

```sh
export CASSOTIS_LEXICON_ROOT="/path/to/cassotis-lexicon"
./build_all.sh
./install.sh
```

应用输出到 `build/arm64/Cassotis.app`，安装到 `~/Library/Input Methods/Cassotis.app`。从系统设置 → 键盘 → 文本输入添加言泉输入法，再通过输入菜单启用。若系统列表未刷新，可退出登录后重新登录。

默认 Shift 切换中英文，Space 或数字选择候选，Tab 接受补全，Ctrl+Shift+F10 打开设置。默认按应用记住中英文状态（设置 → 常规），每个应用分别保留上次的选择。完整按键和数据位置见 [CONFIGURATION.md](CONFIGURATION.md)。

`./rebuild_all.sh` 清理构建输出并完整重建；`./uninstall.sh` 卸载当前用户的输入源并保留学习记录。构建环境、模型下载和词库导入说明见 [BUILD.md](BUILD.md)。默认构建为本机临时签名，打包与签名方法也见构建文档。

## 源码与许可

引擎衍生自 [Cassotis IME Windows 版](https://github.com/shenmin/cassotis-ime)，Free Pascal 移植基础与 [Linux 版](https://github.com/shenmin/cassotis-ime-linux) 共用。macOS 2.0.0 合入 Windows 2.1.0 的引擎改进，使用 [Cassotis Lexicon 2.1.0](https://github.com/shenmin/cassotis-lexicon) 词库与模型；共享引擎的后续更新继续跟进 Windows。macOS 版独立维护原生界面、产品发行和基准历史。

`src/macos` 是原生前端，`src/service` / `src/ipc` 提供进程协议，`src/engine` / `src/dictionary` 为共享生产核心，`src/host` 是本地模型宿主。模块说明见 [架构文档](docs/ARCHITECTURE.md)。模型/schema 校验值和词库输入哈希分别在 `data/runtime-assets.sha256` 与 `data/lexicon-inputs.json`，许可证与来源见 [NOTICE.md](NOTICE.md)。应用代码使用 GPL-3.0，词库使用上游声明的 CC BY-SA 4.0。
