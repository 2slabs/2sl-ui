# 2sl-ui

The design system for 2sl's Ableton tools: Live Extensions (webview dialogs) and, by colour and type, Max for Live devices. It's the [2sl.to](https://2sl.to) look, the "LPX Grid" look of Launchpad colours, pixel type, 1px outlines and inversion, plus a dark theme that sits next to Live.

First used in [chord-progressions](../chord-progressions). Open `demo.html` (e.g. `npx vite` in this folder) to see every component in both themes.

## Files

| file | what |
|---|---|
| `tokens.css` | colours, type, spacing, light + dark themes, base element styles |
| `components.css` | header, params grid, radio chips, select, toggle, slider + presets, input, readout, table, notice, step grid, pads, key-hint footer |
| `ui.ts` | DOM helpers: `radioGroup`, `toggle`, `fillSelect`, `slider`, `applyTheme`, `closeDialog` |
| `fonts/` | Cozette (MIT), the 2sl.to font |
| `max/2sl-colors.json` | the same colours as Max RGBA floats, for Max for Live |
| `demo.html` | every component, both themes |
| `scripts/sync.sh` | copy the system into a project's `ui/2sl/` |

## Principles

1. **Ink on pad.** Two colours do almost everything: `--ink` and `--pad`. Hierarchy comes from inversion, outline and position, not from more colours.
2. **Inversion means "current".** The selected chip, the title, key hints and the primary action are ink-filled with `--inverse` text, as in the site's nav.
3. **Blue means "now".** `--now` is for hover, focus, the playing pad and the playhead. Never use it decoratively.
4. **Launchpad hues are for lit things.** `--hue-*` fill pads (clips, chords, scenes) and category swatches, always with `--pad-text`. Give each category one hue and keep it everywhere.
5. **Pixel type at pixel sizes.** Cozette at 13px (everything) and 26px (the one big value per pad), 39px only for a hero. Smoothing off. Lowercase UI text, as on the site. Musical names keep their case (`Am11`, `♭VII`).
6. **4px grid, 1px lines.** Spacing is multiples of `--unit`. Borders are 1px `--ink`, with 2px only to mark a beat line in step grids.
7. **Grey is for decoration, `--label` is for text.** `--unlit` is the site's grey and stays exact for fills, ticks and rests, but it fails WCAG AA as text. Secondary text uses `--label`, which passes on both themes.

## Themes

`<html data-theme="dark">` or `"light"`. Dark is the default inside Live. The extension SDK can't read Live's theme, so offer a dark/light radio in the header and save it.

| token | light (2sl.to) | dark (Live) | use |
|---|---|---|---|
| `--pad` | `#D5D8DB` | `#262626` | background |
| `--ink` | `#000000` | `#D5D8DB` | text, outlines, selected fill |
| `--inverse` | `#FFFFFF` | `#262626` | text on ink |
| `--unlit` | `#737980` | `#7E848B` | decoration only |
| `--label` | `#595E65` | `#8E949B` | secondary text (AA: 4.6 / 4.9) |
| `--now` | `#2D5BFF` | `#2D5BFF` | hover, focus, playing |
| `--mint` | `#72DEC2` | `#72DEC2` | text selection |
| `--hue-red / orange / green / blue` | `#3E…` quarter brightness | `#6A…` ~half brightness | lit pads, swatches |
| `--hue-ink`, `--hue-grey` | `#000`, `#464B51` | `#0A0A0A`, `#4A4F55` | neutral pads |

## Components and when to use them

These rules include Ableton's *Designing Extensions* guide (in the SDK docs), which the **SDK licence requires extensions to follow**.

| need | use | rule |
|---|---|---|
| choose one of ≤ 5 short options you want visible | radio chips (`radioGroup`) | equal widths (the CSS does this); more than 5 → select |
| choose from ≥ 4 options, or long labels | `.ui-select` (`fillSelect`) | group long lists with optgroups |
| something is on or off | toggle (`toggle`) | never two on/off buttons |
| a continuous range | slider (`slider`) | add tick marks + clickable presets for standard values; don't use for 2–3 steps |
| a rhythm / sequence | `.ui-steps` | 16 per bar, beat numbers above, `.now` playhead while previewing |
| the main musical result | `.ui-pads` / `.ui-pad` | the focal point: biggest, coloured, near the bottom above the actions |
| actions | `.ui-key` footer | verbs; `Cancel` always called cancel; one `.primary` (the confirming action) on the right |
| a typed value | `.ui-input` | numbers: show the unit beside it |
| the one number that matters | `.ui-readout` | 39px, at most one per screen |
| a list of rows | `.ui-table` | `.num` columns right-aligned, `.dim` rows for unchanged items |
| a warning or tip | `.ui-notice` (`.warn`) | one line; warn in orange only when something will go wrong |
| unavailable control | `:disabled` | grey it out, don't hide it |

Layout: header (title + status) → main choice → parameters in a `.ui-params` grid, grouped and separated by `.ui-rule` → visualisation → pads → footer. Top to bottom follows the data flow.

## Using it in a Live Extension

1. `scripts/sync.sh ../my-extension` copies the CSS, `ui.ts` and fonts into `my-extension/ui/2sl/`. Each project keeps its own copy so it builds and ships on its own.
2. In the dialog HTML:
   ```html
   <html lang="en" data-theme="dark">
   <link rel="stylesheet" href="./2sl/tokens.css">
   <link rel="stylesheet" href="./2sl/components.css">
   ```
3. Dialogs load from a `data:` URL and can't fetch files, so the build must inline stylesheets, fonts and scripts. Copy the `inline-ui` esbuild plugin from `chord-progressions/build.ts`: it inlines `<link rel="stylesheet">`, `<script type="module" src>` and `url("./…")` assets.
4. `import { radioGroup, toggle, closeDialog } from "./2sl/ui.ts";`

## Using it in Max for Live

- **Colours:** `max/2sl-colors.json` has every token as RGBA floats. Panels use `pad`, `live.*` objects use `ink` for text and outlines and `now` for active/on, and pads use the hues. Pick the dark set: it sits in Live's device view.
- **Type:** install Cozette on the machine (the TTF/OTF from github.com/slavfox/Cozette releases; macOS can't install the woff2) and set `fontname Cozette`, `fontsize 13`. Devices fall back to Live's font on machines without it, so don't rely on it for layout-critical widths.
- Keep the same principles: inversion for current, blue for now, hues for lit things.

## Changing the system

Edit here, check `demo.html` in both themes, then re-run `scripts/sync.sh` in each project that should get the change. The CSS has no build step.
