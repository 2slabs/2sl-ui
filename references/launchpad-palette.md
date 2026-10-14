# Launchpad palette (source of the `--hue-*` tokens)

Copied 2026-10-14 from LPX_Script (`~/Developer/LPX_Script`). `scripts/derived_tokens.py` re-checks
the LED values against `palette.py` whenever that checkout is beside this repo (or `LPX_SCRIPT_DIR`).

## palette.py: the snapshot page's row hues, LED values 0..127 per channel

```python
SNAPSHOT_ROW_HUES_TOP_TO_BOTTOM = (
    (127, 0, 0),     # red
    (127, 40, 0),    # orange
    (127, 110, 0),   # yellow
    (0, 127, 0),     # green
    (0, 127, 127),   # cyan
    (0, 0, 127),     # blue
    (70, 0, 127),    # purple
    (127, 0, 70),    # pink
)

def scaled(rgb_triplet, numerator, denominator):
    """Scale brightness by numerator/denominator (integer maths, stays in 0..127)."""
    return tuple(channel * numerator // denominator for channel in rgb_triplet)

def quarter_brightness(rgb_triplet):
    return scaled(rgb_triplet, 1, 4)

def snapshot_stored_colour(row_index_from_top):
    return quarter_brightness(SNAPSHOT_ROW_HUES_TOP_TO_BOTTOM[row_index_from_top])

def snapshot_matching_colour(row_index_from_top):
    return SNAPSHOT_ROW_HUES_TOP_TO_BOTTOM[row_index_from_top]
```

## LPX Grid: LED value to screen (`app/Sources/LPXGridCore/GridModel.swift`)

```swift
private static func screenChannel(_ ledValue: Int) -> CGFloat {
    CGFloat(ledValue * 255 / 127) / 255
}
```

So an LED channel `v` is the 8-bit screen channel `v * 255 // 127` (127 → 0xFF, 31 → 0x3E).
Stored colour on screen = light `--hue-*`; matching colour on screen = `--hue-*-lit`.
