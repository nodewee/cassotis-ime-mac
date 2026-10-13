# Cassotis IME - 言泉输入法

<p align="center">
  <img src="docs/images/cassotis-logo.png" alt="Cassotis IME logo" width="280">
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-GPL--3.0-blue" alt="License: GPL-3.0"></a>
  <a href="COMPATIBILITY.md"><img src="https://img.shields.io/badge/platform-macOS-000000?logo=apple&amp;logoColor=white" alt="Platform: macOS"></a>
  <a href="BUILD.md"><img src="https://img.shields.io/badge/arch-Apple%20Silicon-5a67d8" alt="Architecture: Apple Silicon"></a>
</p>

<p align="center">
  <img src="docs/images/macos-preview.png" alt="Native macOS candidate windows and Tab completions in the light, jade and dark themes" width="600">
</p>

<p align="center"><sub>Native macOS candidate windows · Tab completion · Light, jade and dark themes</sub></p>

English | [简体中文](README.zh-Hans.md) | [繁體中文](README.zh-Hant.md)

Cassotis IME - 言泉输入法 is an open-source Chinese Pinyin input method for macOS, with native candidate windows, a local language model and private, offline word learning.

[Website](https://www.yanquan.org/mac) · [Downloads](https://github.com/shenmin/cassotis-ime-mac/releases) · [Windows](https://github.com/shenmin/cassotis-ime) · [Linux](https://github.com/shenmin/cassotis-ime-linux)

An **InputMethodKit / AppKit frontend and a separate Free Pascal engine process** integrate with macOS text input. Dictionaries and models are included; candidate ranking, sentence repair and Tab completion run locally.

Development version **2.0.0** (build **4**) supports Apple Silicon and macOS 14 or later. It has not been released yet; the latest published version is **1.0.0**. See [COMPATIBILITY.md](COMPATIBILITY.md) for the tested environments and known limitations.

## Features

- Full Pinyin, initial-letter abbreviations and six Double Pinyin schemes: Microsoft, Xiaohe, Ziranma, Sogou, Ziguang and Pinyin Jiajia; simplified/traditional dictionaries, fuzzy Pinyin and partial selection.
- One local character language model, with approximately 150 million parameters, handles sentence and word selection, one-key completion, Tab continuation and Pinyin-constrained correction. Only one neural model is installed.
- Long sentences follow the same decoding path when entered key by key or as a whole. First and second candidates improve while learned preferences and fixed preferences for complete exact words remain protected.
- Three-to-five-syllable phrases can be generated from context and corrected against Pinyin even when absent from the dictionary, such as `jiuguize` → “旧规则”. Explicitly chosen phrases can be learned.
- [U/I/V quick input](QUICK_INPUT.md) for symbols, numbering, math, arrows, units, punctuation, dates, times, weekdays, Chinese numbers and financial amounts. Enter with Shift+U/I/V under Double Pinyin; A/B/C/D selects number-conversion candidates.
- A period immediately after directly typed digits becomes a decimal point. This option is on by default and can be disabled in settings.
- A two-row candidate window, optionally expanding to three candidate rows while paging, with up to nine items per row and stable horizontal positions. The Tab area always remains visible, with a logo and version; a small red × removes learned words.
- Horizontal candidates without wrapping, a default 14-point font, eight color options and live previews. The native candidate window keeps focus in the application receiving input.
- A brief caret-side bubble shows the Cassotis logo and “中” or “英” when changing modes or switching to Cassotis. It avoids nearby system cursor indicators and dismisses when typing starts.
- Sidebar settings, font-name completion and direct shortcut recording with automatic saving. Each application remembers its Chinese/English mode by default; logging is off by default.
- System event counters guard against accidental modifier-only switching during shortcuts, without HID access, Input Monitoring or Accessibility permission. System shortcuts and secure password fields retain their normal behavior.
- Tab compares dictionary completions, following phrases and next-character suggestions. Short-word suggestions appear immediately and are reranked in the background. Exact joins of already typed Pinyin use ordinary text color when no predictive hint is available.
- Conservative Pinyin diagnostics preserve the original text; shared learned words follow the active Chinese script, and specialist vocabulary is available for exact input.
- All inference runs locally on the CPU through ONNX Runtime. Dictionaries and the model are bundled; the installed input method needs no compiler, Python installation or online service.

## Install and Try

Download the DMG, open it, double-click **言泉输入法安装器** (Cassotis IME Installer), and click **安装** (Install). The installer requests input-source enablement automatically; click **Allow** if macOS asks for confirmation. Once **安装完成** (Installation Complete) appears, select **言泉输入法** directly from the input menu in the menu bar. The color Cassotis logo indicates that it is selected. Type `nihao` and press Space to enter “你好”. If enablement is still pending, click **重试启用** (Retry Enablement), or use **打开键盘设置** (Open Keyboard Settings) to add it manually.

On macOS 27, the system may open Keyboard Settings without showing a confirmation. Add **言泉输入法** under **Text Input → Edit → + → Chinese, Simplified**, then return to the installer; it verifies enablement automatically.

The graphical installer shows progress, preserves settings and learned words during upgrades, and provides logs and a retry option if installation fails. Using the installed input method requires no Terminal commands, compiler, Python installation, or separate model downloads. Release downloads use the filename `cassotis-ime-macos-<version>-arm64-installer-signed.dmg` and are signed with the Sunisoft Limited Developer ID and notarized by Apple. The installer also provides an uninstall option; remove the input source in System Settings first.

## Benchmarks

Results compare macOS v2.0.0 with the previous release, v1.0.0, using the same complete corpora. All version numbers in these tables refer to macOS releases.

The corpus comes from the developer’s own novel, [Elegance in Timelessness (永恒的舞动)](https://www.qidian.com/book/1037259117/).

Both releases were measured as native arm64 programs on an Apple M2 Pro with 32 GiB of memory and macOS 27.0.1. v1.0.0 retains its recorded release measurements; the old engine was not rerun.

### Long Sentence Benchmark-16300

| macOS version | Top1 | Top2 | Mean (ms) | P50 (ms) | P95 (ms) | Max (ms) |
| --- | --- | --- | --- | --- | --- | --- |
| `v2.0.0` | 13,381/16,300 (82.09%) | 14,268/16,300 (87.53%) | 86.921 | 83 | 144 | 508 |
| `v1.0.0` | 12,941/16,300 (79.39%) | 13,534/16,300 (83.03%) | 85.043 | 79 | 148 | 567 |

### Short-word Context Benchmark-65000

| macOS version | Top1 | Top2 | Contested Top1 | Contested Top2 | Mean (ms) | P50 (ms) | P95 (ms) | Max (ms) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `v2.0.0` | 63,361/65,000 (97.48%) | 64,290/65,000 (98.91%) | 10,533/11,728 (89.81%) | 11,244/11,728 (95.87%) | 7.018 | 5 | 19 | 57 |
| `v1.0.0` | 63,036/65,000 (96.98%) | 64,103/65,000 (98.62%) | 10,488/11,728 (89.43%) | 11,196/11,728 (95.46%) | 6.801 | 6 | 17 | 40 |

Contested results cover the 11,728 cases whose Pinyin maps to at least two target words.

### One-key Completion Context Benchmark-12831

| macOS version | Completion Hit | Avg Keys Saved | Stability | Keystroke P95 (ms) | Final P95 (ms) |
| --- | --- | --- | --- | --- | --- |
| `v2.0.0` | 10,441/12,831 (81.37%) | 2.633 | 2,126/2,188 (97.17%) | 1.897 | 18.718 |
| `v1.0.0` | 10,331/12,831 (80.52%) | 2.638 | 2,117/2,180 (97.11%) | 1.213 | 9.385 |

Savings are per correct completion, after charging one key to accept it. Stability counts only adjacent prefixes for which the previous completion remains compatible. Short-word completions saved 27,491 net keys in v2.0.0 and 27,250 in v1.0.0.

### Long-sentence One-key Completion Benchmark-16300

Each sentence leaves its final four Pinyin syllables untyped and evaluates the single visible continuation. Coverage counts predictive prompts, excluding exact joins of already typed Pinyin; it is not accuracy.

| macOS version | Local Completion Hit | Predictive Prompt Coverage | Total Keys Saved | P95 (ms) |
| --- | --- | --- | --- | --- |
| `v2.0.0` | 3,761/16,300 (23.07%) | 16,120/16,300 (98.90%) | 9,296 | 131 |
| `v1.0.0` | 3,539/16,300 (21.71%) | 15,812/16,300 (97.01%) | 7,539 | 131 |

Both releases use an 80 ms long-completion result budget and treat 他 and 她 as equivalent at matching positions. Short-word completion and incremental stability remain strict. Latency measures engine queries or completion, excluding cold start, InputMethodKit/IPC, rendering and inter-key delays. Short Tab Keystroke P95 excludes background reranking; Final P95 includes it when it changes the displayed prompt.

Test programs, benchmark tools, corpora and per-case reports are not included in the public source distribution.

Release validation covers 777 core regressions, 3,112 simplified/traditional dictionary cases, model execution, IPC, composition recovery and settings persistence, plus real input in native controls, WebKit, Chrome, Electron and Terminal.

## Build and Install

Development requires **Free Pascal 3.2.2, Xcode command-line tools, and Python 3.11+**. Lazarus/LCL is not required. Obtain the generated assets from [Cassotis Lexicon v2.0.0](https://github.com/shenmin/cassotis-lexicon/tree/v2.0.0) and point `CASSOTIS_LEXICON_ROOT` to your checkout (`/path/to/...` is a placeholder):

```sh
export CASSOTIS_LEXICON_ROOT="/path/to/cassotis-lexicon"
./build_all.sh
./install.sh
```

The application is built at `build/arm64/Cassotis.app` and installed to `~/Library/Input Methods/Cassotis.app`. Add 言泉输入法 under System Settings → Keyboard → Text Input, then select it from the input menu. If the input-source list does not refresh, log out and log back in.

By default, Shift switches between Chinese and English input, Space or a number selects a candidate, Tab accepts a completion, and Ctrl+Shift+F10 opens settings. Each application remembers its own Chinese/English mode by default (Settings → General); an application that was never switched in inherits the current mode. See [CONFIGURATION.md](CONFIGURATION.md) for the full key bindings and data locations.

`./rebuild_all.sh` cleans the build output and performs a complete rebuild. `./uninstall.sh` removes the current user's input method while preserving learned words. See [BUILD.md](BUILD.md) for build prerequisites, model downloads, dictionary imports, packaging, and signing. Builds use a local ad hoc signature by default.

## Source and License

The engine is derived from [Cassotis IME for Windows](https://github.com/shenmin/cassotis-ime), with Free Pascal porting foundations shared with the [Linux version](https://github.com/shenmin/cassotis-ime-linux). macOS 2.0.0 incorporates the Windows 2.0.0 engine changes and [Cassotis Lexicon 2.0.0](https://github.com/shenmin/cassotis-lexicon) dictionaries and models; shared engine updates continue to follow Windows. macOS has its own frontend, releases and benchmark history.

`src/macos` contains the native frontend, `src/service` / `src/ipc` implement the process protocol, `src/engine` / `src/dictionary` contain the shared production core, and `src/host` hosts the local models. See the [architecture document](docs/ARCHITECTURE.md) for module details. Model/schema checksums and lexicon input hashes are in `data/runtime-assets.sha256` and `data/lexicon-inputs.json`; licenses and provenance are described in [NOTICE.md](NOTICE.md). Application code is licensed under GPL-3.0, and the dictionaries use the upstream CC BY-SA 4.0 license.
