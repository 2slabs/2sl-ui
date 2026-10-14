#!/bin/sh
# Copy 2sl-ui into a project (each project ships its own copy). Checks 2sl-ui first and stops on
# any problem (scripts/derived_tokens.py --check).
#
#   scripts/sync.sh <project-dir>                  everything into <project-dir>/ui/2sl/
#   scripts/sync.sh --into <dir>                   everything into <dir> (any path)
#   scripts/sync.sh --tokens-only <project-dir>    tokens.css + fonts only (web pages: no dialog
#   scripts/sync.sh --tokens-only --into <dir>     components, no ui.ts)
#
# A tokens-only sync removes components.css and ui.ts left in the target by an earlier full sync
# (only from a target with a 2sl-ui VERSION file, i.e. one this script wrote), and says so.
set -eu
here=$(cd "$(dirname "$0")/.." && pwd)
usage='usage: sync.sh [--tokens-only] (<project-dir> | --into <dir>)'

tokens_only=false
destination=""
project_directory=""
while [ $# -gt 0 ]; do
  case "$1" in
    --tokens-only) tokens_only=true ;;
    --into)
      [ $# -ge 2 ] || { echo "sync.sh: --into needs a directory (╯°□°)╯" >&2; echo "$usage" >&2; exit 2; }
      destination=$2
      shift ;;
    -*) echo "sync.sh: unknown option $1 (╯°□°)╯" >&2; echo "$usage" >&2; exit 2 ;;
    *)
      [ -z "$project_directory" ] || { echo "sync.sh: more than one project directory (╯°□°)╯" >&2; echo "$usage" >&2; exit 2; }
      project_directory=$1 ;;
  esac
  shift
done
if [ -n "$project_directory" ] && [ -n "$destination" ]; then
  echo "sync.sh: give a project directory or --into, not both (╯°□°)╯" >&2; echo "$usage" >&2; exit 2
fi
if [ -n "$project_directory" ]; then
  [ -d "$project_directory" ] || { echo "sync.sh: project directory $project_directory does not exist (╯°□°)╯" >&2; exit 1; }
  destination="$project_directory/ui/2sl"
fi
[ -n "$destination" ] || { echo "$usage" >&2; exit 2; }

python3 "$here/scripts/derived_tokens.py" --check

mkdir -p "$destination/fonts"
cp "$here/tokens.css" "$destination/"
cp "$here/fonts/CozetteVector.woff2" "$here/fonts/LICENSE-Cozette.txt" "$destination/fonts/"
if [ "$tokens_only" = true ]; then
  mode="tokens only"
  if [ -f "$destination/VERSION" ]; then
    for dialog_file in components.css ui.ts; do
      if [ -e "$destination/$dialog_file" ]; then
        rm "$destination/$dialog_file"
        echo "sync.sh: removed $destination/$dialog_file (left by an earlier full sync; tokens-only target)"
      fi
    done
  fi
else
  mode="full"
  cp "$here/components.css" "$here/ui.ts" "$destination/"
fi

rev=$(git -C "$here" describe --always --dirty 2>/dev/null || echo "uncommitted")
printf '2sl-ui %s, synced %s (%s). Edit in 2sl-ui, not here.\n' "$rev" "$(date +%Y-%m-%d)" "$mode" > "$destination/VERSION"
echo "synced 2sl-ui ($rev, $mode) into $destination (^_^)"
