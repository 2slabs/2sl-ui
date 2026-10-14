# Shortcuts

Known deviations from the rules in README.md, to come back to.

- **The select arrow is antialiased.** `.ui-select` draws its arrow with two 45° hard-stop
  `linear-gradient`s; browsers antialias diagonal stops, so the arrow's edge pixels are blends,
  against README "Shape" (every pixel a token colour). Fix: an inline SVG or a pixel-exact
  1-bit image in `--ink`.
- **Two dark hues are off the written rule** (`#6A2300` orange, `#005A00` green; README
  "Launchpad hues"). Kept because consumers depend on them; listed in
  `DARK_HUES_KEPT_OFF_RULE` in `scripts/derived_tokens.py`. Decide whether to move them onto the
  rule (`#6A2100`, `#006A00`) in a breaking release.
- **`.ui-pad .dim` uses `opacity: 0.6`** to soften the small label on a pad. That blends with the
  hue, which a pixel canvas can't reproduce from tokens. Fix: a token per pad text level, or drop
  the dimming.
- **`.ui-slider` styles only WebKit's range parts** (`::-webkit-slider-*`). Fine inside Live's
  webviews (WebKit on macOS, WebView2 on Windows); Firefox would show its default slider.
- **`.vite/deps/` is committed** (a Vite dependency cache from the first commit). It changes
  whenever `npx vite` runs; it should be in `.gitignore` and removed from the repo.
