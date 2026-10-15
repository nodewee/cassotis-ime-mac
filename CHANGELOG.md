# Changelog

## 2.0.0 (build 4, unreleased)

- Add an ordered Custom Phrases settings page with explicit Add and Save Changes actions, exact letter shortcuts, literal multiline Tab commits, duplicate priority, and Windows-compatible JSON import/export. Keep numbered candidates and Space unchanged, and protect phrases from asynchronous prediction and learning cleanup.
- Keep drafts separate from saved custom-phrase rows. Cancelling edits or clearing the form cannot mutate the list; failed writes preserve both the draft and the saved contents.
- Allow large custom-phrase lists time to finish saving without reporting a premature connection error; keep ordinary input deadlines unchanged.
- Move the logging controls into Advanced. Keep per-keystroke IPC small even for the maximum custom-phrase list, and preserve phrases when older clients update settings.

- Add automatically saved ASCII-punctuation exceptions with Markdown, standard Chinese and custom presets. Preserve saved exceptions while disabled by English punctuation or full-width input.
- Recognize English in Chinese full-Pinyin, half-width mode, preserving case and allowing Space, arrow keys and verified mouse selection without changing Chinese candidate numbering. Remember explicit choices without creating English user words.
- Keep original typed keys through typo-corrected partial selection and undo, including swaps across word boundaries (`quanptai`, `jitnian`).
- Restore both nasal-boundary prefixes for input such as `tiana` and `xinga`, retaining the original boundary, complete candidates, all prefix homophones and stable pages; explicit apostrophe and Double Pinyin boundaries remain authoritative.
- Fix `ying`, `jiu` and `bu` to prefer 应/應, 就 and 不 in simplified and traditional Chinese.
- Do not learn a rejected long-sentence completion when the next key only lengthens or rewrites the last syllable (`jid` → `jidu`, `xia` → `xian`); a key that starts a new syllable still records the rejection.
- Read a three- to five-syllable phrase that is no dictionary entry as a clause inside a sentence when nothing precedes it, and prefer the dictionary's most frequent words there (`shezhizhong` → 设置中, no longer 射之中).
- Align with the Windows and Cassotis Lexicon v2.2.0 development snapshots (tags pending), including 67 additional reply, set and repository phrases per script on top of the earlier 389 additions.
- Replace all eleven neural graphs with one shared character language model for sentence and word selection, completion, phrase generation and Pinyin-constrained correction; remove the retired graphs, indexes, hosts and compact parameters.
- Improve the first two long-sentence candidates, and make completed long input follow the same candidate path whether entered at once or key by key.
- Generate and correct three-to-five-syllable phrases outside the dictionary; preserve fixed exact and learned preferences, and remember explicitly selected phrases.
- Add U/I/V symbols, dates, times, Chinese numbers and financial amounts, including Shift-entry for double Pinyin and a/b/c/d selection for numeric candidates. See [Quick Input](QUICK_INPUT.md).
- Add the default-on, immediately saved decimal-period-after-digit preference. Direct typing is distinguished from pasted text, candidate selection and cursor movement without HID access. Preserve digits typed while the engine starts so the preference works immediately, without opening Settings; keep an explicitly disabled choice when upgrading.
- Compress the installer DMG with LZMA to reduce the download size while keeping the complete dictionaries and shared model.
- Ignore non-key events delivered to the input method's `handleEvent:`, where reading `keyCode` from a mouse drag raised an exception and broke the input connection.
- Cancel a modifier-only shortcut, such as the bare Shift Chinese/English switch, when a key or mouse button was pressed while the modifier was held, including input the frontmost application consumed before the input method saw it (for example Shift+Return in some terminals). The frontend compares system-wide event counts and times around the press and release; it reads no key contents and needs no privacy permission, and keeps the previous behavior when the counters are unavailable. When events are handled late and the counters cannot show whether input fell inside the hold, the shortcut is cancelled.
- Remember the Chinese/English mode per application. With the default-on "remember per application" preference in Settings → General, each application keeps the mode the user last chose there and restores it when that application becomes active again; an application that was never switched in inherits the current mode, and turning the preference off returns to one global mode. The memory lives in the input method's UserDefaults and survives a restart.

## 1.0.0 (build 3)

- Align the engine, dictionaries and deployed models with Windows / Cassotis Lexicon v1.31.0.
- Replace RBT3 with a shared character language model for long sentences, contextual words, mixed Pinyin abbreviations and Tab continuations. Keep dictionary, pronunciation and learned-preference protections.
- Improve whole-word recall for mixed abbreviations, including single-consonant `n` / `m` / `r` and `zh` / `ch` / `sh` boundaries.
- Compare completion of the current word with following phrases and predicted next characters; base Tab decisions on the final visible candidate and preserve explicit syllable boundaries.
- Rerank short Tab suggestions asynchronously after displaying the lexical choice. Reject results from replaced input generations or recreated contexts.
- Reuse only the model stage of long-completion prefetch, then apply the shared-LM policy to the final request. Follow the upstream 80 ms production result budget.
- Store the character model in verified source parts and reconstruct it atomically during builds; ship only the complete model in the application.

## 0.2.0 (build 2)

- Align the shared engine, production models and dictionaries with Windows / Cassotis Lexicon v1.29.0.
- Add conservative short-word context reranking with shared encoder segments and a 30 ms result budget, preserving learned preferences and safe abstention.
- Improve literary paths, bounded classical phrase recovery, decreasing long-sentence prefixes, fuzzy character ordering and evidence-backed compound candidates.
- Add optional three-row candidate browsing, stable paging and direct mouse selection across visible rows; verified snapshots reject stale selections and removals. Inactive rows reserve the same number-label width as the active row so words stay in place when moving up or down. Keep the completion row visible.
- Add exact specialist vocabulary without polluting general predictions, deduplicate popularity evidence for additive readings, and accelerate Pinyin and dictionary prefix lookup.
- Correct ARM64 compiler differences in score-sentinel comparisons and floating-point intermediates to preserve candidate paths and Delphi scoring semantics.
- Keep automatic input-source enablement requests and per-layer notarization; upgrades preserve settings and learning. Explain the manual System Settings path when macOS does not show a consent dialog, and automatically verify enablement when returning to the installer.


## 0.1.0 (build 1)

- Use the stable lowercase release filename `cassotis-ime-macos-<version>-arm64-installer-signed.dmg` and document signing and notarization separately.
- Style the installer disk image with a website-inspired Retina background and a saved Finder layout for the installer and installation guide.
- Add an automatically saved logging switch, off by default, that starts or stops file logging immediately without restarting the input engine; rotate active logs at 2 MiB.
- Clearly label the DMG, mounted volume and bundled application as the Cassotis installer.
- Use the same white-backed logo with pronounced rounded corners in the macOS input-source switcher, menu bar and Cassotis's Chinese/English status bubble.
- Align the engine and dictionaries with Windows / Cassotis Lexicon v1.27.0; retain macOS 0.1.0 and build 1.
- Validate reused Pinyin paths against current syllable boundaries, restore five-syllable decoding, and bound cold character-LM work and exact-prefix learning bonuses.
- Offer an exact-word Tab join when no prediction is available, without learning the joined text. Show joins in the normal text color and predictive continuations in the theme accent color.
- Preserve attested compound-prefix highlighting on the five-syllable fast path and carry completion sources through the native protocol.
- Follow Windows' predictive-only completion statistics and long-sentence Top1/Top2 scoring.


- Prevent background macOS input clients from interrupting a composition. Finish launching the new frontend during installation so the first key does not wait on executable verification; restore the previous app if launch fails.

- Align the engine and lexicon with Windows / Cassotis Lexicon v1.26.1.
- Add guarded joint sentence repair with a bilateral verifier and preserve exact FP32 evidence when reusing query encodings.
- Reuse validated repaired prefixes for displayed and committed Tab completions; prefetch long completion work with request and context isolation.
- Fix Ziguang initial/final boundaries, including `sh`, `zh`, and `ch` for `song`, `zong`, and `cong`. Keep completed `ng` syllables and mixed retroflex abbreviations stable through typing, backspace and partial selection.
- Display learned words in the active simplified/traditional script while preserving learning identity and removal of both aliases.
- Show conservative invalid-Pinyin and repeated-vowel diagnostics in the candidate footer, preserving the two-row height, Tab completions and logo. Also supply marked-text colors to clients that retain them; macOS can replace inline styles.
- Reduce exact-component sorting work without changing ordering.

### Earlier changes

- Add a native macOS InputMethodKit / AppKit input method with a Free Pascal helper, local ONNX inference and simplified/traditional dictionaries.
- Align the pinyin engine with Windows 1.25.0, using Lexicon 1.25.0 and schema 24; cover prefix recall, compound ranking, ü aliases and stable candidate paging.
- Support full pinyin, abbreviated pinyin, six double-pinyin schemes, fuzzy matching, local learning and Tab completion.
- Keep the candidate panel at two rows, show up to nine candidates, highlight the selected item and allow removal of user words.
- Provide eight appearance options, font completion, live previews, native shortcut recording and automatically saved settings.
- Show an animated Chinese/English status bubble with the color logo and 13-point text at the caret on mode changes and input-source activation; avoid system cursor accessories, dismiss automatically and respect reduced motion.
- Use the color logo in the input menu and link About and Settings to the macOS website.
- Handle Chinese punctuation, cold-start keystrokes, focus changes, secure fields and recovery from helper failures.
- Provide build, rebuild and packaging scripts, plus a native graphical installer that preserves user settings and learning data.
- Keep source distributions focused on runtime and build components, validate assets with standalone checksums, and use configurable compiler and lexicon locations.
