# WCAG 2.2, Success Criterion 1.4.3 Contrast (Minimum), Level AA

Source: https://www.w3.org/TR/WCAG22/#contrast-minimum (fetched 2026-10-14).

Text needs a contrast ratio of at least 4.5:1 (3:1 for large-scale text), with exceptions. The
one 2sl-ui relies on (disabled text in `--unlit`), from the "Incidental" exception:

> "Text or images of text that are part of an inactive user interface component, that are pure
> decoration, that are not visible to anyone, or that are part of a picture that contains
> significant other visual content, have no contrast requirement."

Contrast ratio = (L1 + 0.05) / (L2 + 0.05) with L the relative luminance of the lighter (L1) and
darker (L2) colour; LPX Grid's `prefersLightText` and README "Launchpad hues" use the same formula.
