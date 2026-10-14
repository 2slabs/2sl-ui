#!/bin/sh
# Copy 2sl-ui into a project's ui/2sl/ (each project ships its own copy).
#   scripts/sync.sh ../my-extension
set -eu
here=$(cd "$(dirname "$0")/.." && pwd)
project=${1:?usage: sync.sh <project-dir>}
dest="$project/ui/2sl"
mkdir -p "$dest/fonts"
cp "$here/tokens.css" "$here/components.css" "$here/ui.ts" "$dest/"
cp "$here/fonts/CozetteVector.woff2" "$here/fonts/LICENSE-Cozette.txt" "$dest/fonts/"
rev=$(git -C "$here" rev-parse --short HEAD 2>/dev/null || echo "uncommitted")
printf '2sl-ui %s, synced %s. Edit in 2sl-ui, not here.\n' "$rev" "$(date +%Y-%m-%d)" > "$dest/VERSION"
echo "synced 2sl-ui ($rev) into $dest"
