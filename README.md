# 2sl-ui

2sl's design system and the one source of truth for its look: Launchpad colours, pixel type, 1px outlines and inversion (the "LPX Grid" look), in a light theme and a dark theme that sits next to Live. Every colour, the font, the type sizes and the base element styles are defined here; consumers copy or generate from this repo and define no colours of their own.

| consumer | takes | how |
|---|---|---|
| [2sl.to](../2sl.to) (website) | `tokens.css` + fonts, light theme | `scripts/sync.sh --tokens-only src` → `src/ui/2sl/`; `build.py` serves it at `/2sl/` |
| LPX Grid (`LPX_Script/app`, macOS) | colour and type tokens, Cozette | `app/sync_2sl_ui.py` generates Swift from `tokens.css` and cross-checks `max/2sl-colors.json` |
| [chord-progressions](../chord-progressions), [bassline](../bassline) (Live Extensions) | everything | `scripts/sync.sh <repo>` → `ui/2sl/` |
| Max for Live devices | colours, the font | `max/2sl-colors.json`; Cozette installed on the machine |

Open `demo.html` (e.g. `npx vite` in this folder) to see every token and component in both themes.

## Files

| file | what |
|---|---|
| `tokens.css` | colours, type, spacing, page layout, light + dark themes, base element styles |
| `components.css` | header, params grid, radio chips, select, toggle, slider + presets, input, readout, table, notice, step grid, pads, key-hint footer, the marked state |
| `ui.ts` | DOM helpers: `radioGroup`, `toggle`, `fillSelect`, `slider`, `applyTheme`, `closeDialog` |
| `fonts/` | Cozette (MIT) as woff2, and its licence |
| `max/2sl-colors.json` | every colour token as Max RGBA floats. **Generated**, never edit by hand |
| `demo.html` | every token and component, both themes |
| `scripts/derived_tokens.py` | checks `tokens.css` and generates `max/2sl-colors.json` (`--check` to verify only) |
| `scripts/sync.sh` | copy the system into a project |
| `references/` | sources: the Launchpad palette and the WCAG contrast rule this system relies on |
| `SHORTCUTS.md` | known deviations to come back to |

## Principles

1. **Ink on pad.** Two colours do almost everything: `--ink` and `--pad`. Hierarchy comes from inversion, outline and position, not from more colours.
2. **Inversion means "current".** The selected chip, the title, key hints, the open page in a nav and the primary action are ink-filled with `--inverse` text.
3. **Blue means "now".** `--now` is for hover, focus, the playing pad and the playhead, with `--now-text` on it. Never use it decoratively.
4. **Launchpad hues are for lit things.** `--hue-*` fill pads (clips, chords, scenes, snapshots) and category swatches, always with `--pad-text`. Give each category one hue and keep it everywhere.
5. **Pixel type at pixel sizes.** Cozette at 13, 26 and 39px only (see Type). Smoothing off. Lowercase UI text. Musical names keep their case (`Am11`, `♭VII`), as do cell ids (`A1`) and proper nouns.
6. **4px grid, 1px lines.** Spacing is multiples of `--unit`. Borders are 1px `--ink`, with 2px only to mark a beat line in step grids.
7. **Grey is for decoration and disabled things, `--label` is for text.** `--unlit` stays exact for fills, ticks and rests, but it fails WCAG AA as text, so readable text never uses it. The one text use is disabled controls, which WCAG exempts (see States).
8. **Square and flat.** See Shape.

## Themes

`<html data-theme="dark">` or `"light"`. Light is the default (`:root`); dark overrides only what changes. Dark is the right choice inside Live; the extension SDK can't read Live's theme, so offer a dark/light radio in the header and save it. The website is light only.

| token | light | dark | use |
|---|---|---|---|
| `--pad` | `#D5D8DB` | `#262626` | background, an unlit pad |
| `--ink` | `#000000` | `#D5D8DB` | text, outlines, selected fill, the text caret |
| `--inverse` | `#FFFFFF` | `#262626` | text on ink |
| `--unlit` | `#737980` | `#7E848B` | decoration; disabled text and lines |
| `--label` | `#595E65` | `#8E949B` | secondary text (AA: 4.6 / 4.9) |
| `--now` | `#2D5BFF` | `#2D5BFF` | hover, focus, playing |
| `--now-text` | `#FFFFFF` | `#FFFFFF` | text on `--now` |
| `--mint` | `#72DEC2` | `#72DEC2` | text selection background |
| `--selection-text` | `#000000` | `#000000` | text on `--mint` |
| `--hue-red … --hue-pink` | quarter brightness | lit × 0x6A/0xFF | pads, swatches (see Launchpad hues) |
| `--hue-red-lit … --hue-pink-lit` | full brightness | same | the pad that is lit right now |
| `--hue-ink`, `--hue-grey` | `#000000`, `#464B51` | `#0A0A0A`, `#4A4F55` | neutral pads |
| `--pad-text` | `#FFFFFF` | `#FFFFFF` | text on a hue (and on lit blue and purple) |
| `--lit-pad-text` | `#000000` | `#000000` | text on a lit hue |
| `--pad-edge` | `#000000` | `#000000` | the 1px outline around a pad |

Every colour is a literal upper-case `#RRGGBB`, and the dark block only sets tokens the light block has: `app/sync_2sl_ui.py` and `scripts/derived_tokens.py` parse the file that way and fail otherwise.

## Launchpad hues

The hues come from the Launchpad: LPX_Script's `palette.py` (`SNAPSHOT_ROW_HUES_TOP_TO_BOTTOM`, the snapshot page's eight rows) is their source, copied with the conversion in `references/launchpad-palette.md`. An LED value `v` (0–127) shows on screen as `v * 255 // 127` (LPX Grid's `GridModel.screenChannel`). Three tokens per hue:

- **light** `--hue-*` = the script's stored colour, `palette.py`'s `quarter_brightness` of the row hue, on screen. E.g. red (127, 0, 0) is stored as (31, 0, 0), which is `#3E0000`. So the light hues are exactly the colours LPX Grid shows for stored snapshot cells.
- **dark** `--hue-*` = the lit colour scaled so its brightest channel is `0x6A` (each channel × 0x6A / 0xFF, rounded), so pads read on `#262626`.
- **lit** `--hue-*-lit` = the full LED colour on screen (the matching snapshot, a pressed pad). The same in both themes.

| hue | LED | light | dark | lit | text on lit |
|---|---|---|---|---|---|
| red | 127, 0, 0 | `#3E0000` | `#6A0000` | `#FF0000` | `--lit-pad-text` |
| orange | 127, 40, 0 | `#3E1400` | `#6A2300` * | `#FF5000` | `--lit-pad-text` |
| yellow | 127, 110, 0 | `#3E3600` | `#6A5B00` | `#FFDC00` | `--lit-pad-text` |
| green | 0, 127, 0 | `#003E00` | `#005A00` * | `#00FF00` | `--lit-pad-text` |
| cyan | 0, 127, 127 | `#003E3E` | `#006A6A` | `#00FFFF` | `--lit-pad-text` |
| blue | 0, 0, 127 | `#00003E` | `#00006A` | `#0000FF` | `--pad-text` |
| purple | 70, 0, 127 | `#22003E` | `#3A006A` | `#8C00FF` | `--pad-text` |
| pink | 127, 0, 70 | `#3E0022` | `#6A003A` | `#FF008C` | `--lit-pad-text` |

\* Two dark hues predate the written rule and are kept because consumers depend on them: orange is `#6A2300` where the rule gives `#6A2100` (2/255 in green, invisible), and green was dimmed by hand to `#005A00` (the rule gives `#006A00`). New hues follow the rule; `scripts/derived_tokens.py` checks every hue against it and lists these two as the only exceptions.

Text on a lit hue is whichever of black and white contrasts more (WCAG relative luminance), as LPX Grid computes it: black (`--lit-pad-text`) on all but blue and purple. White `--pad-text` passes AA on every light and dark hue. `--hue-ink` and `--hue-grey` are neutrals, not Launchpad rows, so they have no lit variant.

## States

One look per state, the same in CSS and in a pixel canvas (LPX Grid draws its UI into a bitmap with antialiasing off, so a state must be solid token colours, never blending).

| state | meaning | look |
|---|---|---|
| current | the one chosen / open / confirming thing in its group | inverted: `--ink` fill, `--inverse` text |
| now | playing, hovered, focused | `--now` (fill with `--now-text`, or a 1px frame) |
| marked | selected but not current: part of a multi-selection, the remembered choice in a group that doesn't have focus, the row the edit caret is on | a 1px `--ink` frame 1px outside the thing (`.ui-marked`); in text rows (tables, lists) a `▸` in a leading 2ch column instead, where frames would be noise |
| disabled | can't be used now | text and lines in `--unlit`, fills in `--unlit` with `--pad` text, no hover. Never opacity. Don't hide it |
| text caret | the insertion point in editable text | 1px `--ink`, the full line height (`caret-color: var(--ink)` in CSS) |

`now` wins over `marked` (the playhead and focus use the same frame in blue). Disabled text is the only text in `--unlit`: WCAG 1.4.3 exempts inactive components from the contrast minimum (`references/wcag-contrast-minimum.md`), and keeping it distinct from `--label` keeps disabled visibly different from secondary.

## Type

Cozette is a bitmap face: crisp only at multiples of its 13px design size. Three sizes, by role, the same in dialogs, apps and web pages:

| token | size / line | role | dialogs, apps | web pages |
|---|---|---|---|---|
| `--small` | 13 / `--line` (18) | text | everything | everything: body, nav, captions, tables, card titles |
| `--large` | 26 / 36 | a heading or a focal value | the big value on a pad, a view's headline | the wordmark, page title bars, section headings, a page's lede |
| `--huge` | 39 / 54 | the one thing on the screen | `.ui-readout` | a home or hero statement |

- `--huge` at most once per screen or page. `--large` is the only heading size: there is no third heading level, sub-headings are 13px with an ink rule or inversion.
- Narrow screens (≤ 860px) step down one size: 39 → 26, ledes 26 → 13.
- No bold, no italics. Emphasis is inversion, never weight or colour.
- In a pixel canvas, 26 and 39 are the 13px glyphs scaled ×2 and ×3, nearest-neighbour.

## Shape

- Zero border radius. No shadows, no blur.
- Lines are 1px solid (2px only for step-grid beat lines). Images get a 1px `--ink` frame; pixel art is scaled at whole multiples with `image-rendering: pixelated`.
- **Gradients are a drawing tool, never shading.** No colour ramps, fades or soft transitions: every visible pixel is a token colour. CSS gradients with hard stops (0-length transitions) are allowed to draw pixel patterns: the step grid's hold stripes, an empty-image grid, the select's arrow. Horizontal and vertical stops are pixel-exact; the select arrow's 45° stops are antialiased by browsers, a known deviation (SHORTCUTS.md).

## Layout

- **Dialogs and devices:** header (title + status) → main choice → parameters in a `.ui-params` grid, grouped and separated by `.ui-rule` → visualisation → pads → footer. Top to bottom follows the data flow. Pad the dialog with `calc(var(--unit) * 4)`.
- **Web pages:** content up to `--page-width` (1200px) wide, centred, with `--gutter` (24px, 16px at ≤ 860px) at the window edges and between page blocks. Ordinary web navigation (wordmark left, links right, the current page inverted); the dialog interaction model (key hints, chips, pads) stays in tools. Prose under 72ch. Page parts that only the site has (nav, cards, facts tables, figures) stay in the site's own CSS until a second web consumer needs them.

## Components and when to use them

These rules include Ableton's *Designing Extensions* guide (in the SDK docs), which the **SDK licence requires extensions to follow**.

| need | use | rule |
|---|---|---|
| choose one of ≤ 5 short options you want visible | radio chips (`radioGroup`) | equal widths (the CSS does this); more than 5 → select |
| choose from ≥ 4 options, or long labels | `.ui-select` (`fillSelect`) | group long lists with optgroups |
| something is on or off | toggle (`toggle`) | never two on/off buttons |
| a continuous range | slider (`slider`) | add tick marks + clickable presets for standard values; don't use for 2–3 steps |
| a rhythm / sequence | `.ui-steps` | 16 per bar, beat numbers above, `.now` playhead while previewing |
| the main musical result | `.ui-pads` / `.ui-pad` | the focal point: biggest, coloured, near the bottom above the actions. `--hue` sets the colour; `.lit` with `--hue-lit` for a pad that is on now (`.lit-light-text` on blue and purple) |
| actions | `.ui-key` footer | verbs; `Cancel` always called cancel; one `.primary` (the confirming action) on the right |
| a typed value | `.ui-input` | numbers: show the unit beside it |
| the one number that matters | `.ui-readout` | 39px, at most one per screen |
| a list of rows | `.ui-table` | `.num` columns right-aligned, `.dim` rows for unchanged items |
| a warning or tip | `.ui-notice` (`.warn`) | one line; warn in orange only when something will go wrong |
| selected but not current | `.ui-marked` | see States |
| unavailable control | `:disabled` | `--unlit`, see States; grey it out, don't hide it |

## Syncing into a project

```sh
scripts/sync.sh ../my-extension                 # everything into ../my-extension/ui/2sl/
scripts/sync.sh --tokens-only src               # web pages: tokens.css + fonts into src/ui/2sl/
scripts/sync.sh --into ../somewhere/2sl         # any target directory (combine with --tokens-only)
```

Each project keeps its own copy so it builds and ships on its own, with a `VERSION` line naming the 2sl-ui commit and mode. Every sync runs `scripts/derived_tokens.py --check` first and stops if 2sl-ui disagrees with itself. A tokens-only sync removes `components.css` and `ui.ts` that an earlier full sync left in the target.

## Using it in a Live Extension

1. `scripts/sync.sh ../my-extension`.
2. In the dialog HTML:
   ```html
   <html lang="en" data-theme="dark">
   <link rel="stylesheet" href="./2sl/tokens.css">
   <link rel="stylesheet" href="./2sl/components.css">
   ```
3. Dialogs load from a `data:` URL and can't fetch files, so the build must inline stylesheets, fonts and scripts. Copy the `inline-ui` esbuild plugin from `chord-progressions/build.ts`: it inlines `<link rel="stylesheet">`, `<script type="module" src>` and `url("./…")` assets.
4. `import { radioGroup, toggle, closeDialog } from "./2sl/ui.ts";`

## Using it on a web page

`scripts/sync.sh --tokens-only <project>`, serve `tokens.css` and `fonts/`, link `tokens.css` before the page's own CSS, set `data-theme="light"`. Use the token names only; a page's CSS adds layout and page parts, never colours, sizes or fonts. Pages may set `body { cursor: auto }` (tokens.css sets the dialog default).

## Using it in a native app

Generate code from `tokens.css`, don't hand-copy: parse the `:root` block (light) and the `:root[data-theme="dark"]` block (dark = light + overrides), as LPX Grid's `app/sync_2sl_ui.py` does, and fail when a token you need is missing.

**Font:** CoreText loads Cozette straight from the woff2 bytes, so an app can embed `fonts/CozetteVector.woff2` (as a resource or as data) and needs nothing installed: `CTFontManagerCreateFontDescriptorsFromData` on the bytes, then `CTFontCreateWithFontDescriptor` at 13, 26 or 39 (or register it for the process with `CTFontManagerRegisterGraphicsFont`). LPX Grid does this with the woff2 embedded as base64. Draw with antialiasing and font smoothing off (`setShouldAntialias(false)`, `setShouldSmoothFonts(false)`) and on whole pixels. Fail loudly if the font doesn't load: it's built in, so that's a build bug.

## Using it in Max for Live

- **Colours:** `max/2sl-colors.json` has every colour token, both themes, as RGBA floats. Panels use `pad`, `live.*` objects use `ink` for text and outlines and `now` for active/on, and pads use the hues. Pick the dark set: it sits in Live's device view.
- **Type:** Max uses fonts installed on the machine. CoreText could read the woff2, but installing a font system-wide with Font Book needs TTF or OTF, so install Cozette's TTF/OTF from github.com/slavfox/Cozette releases and set `fontname Cozette`, `fontsize 13`. Devices fall back to Live's font on machines without it, so don't rely on it for layout-critical widths.
- Keep the same principles: inversion for current, blue for now, hues for lit things.

## Changing the system

1. Edit `tokens.css` / `components.css` / `ui.ts`. Only add tokens; renaming or changing a value breaks consumers, so do it only when a value is wrong, and say so in the commit.
2. `python3 scripts/derived_tokens.py` (regenerates `max/2sl-colors.json`, checks the hues).
3. Check `demo.html` in both themes, commit.
4. Re-sync each consumer: `scripts/sync.sh --tokens-only ../2sl.to/src`, `scripts/sync.sh ../chord-progressions`, `scripts/sync.sh ../bassline`, and `python3 sync_2sl_ui.py` in `LPX_Script/app`.
