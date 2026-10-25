#!/usr/bin/env bash
# atlas-open <route> — opens an Atlas page (e.g. `planning`, `screentime/day`) in the browser;
# the bar modules' onClick handlers use it so Atlas's address stays in atlas-env.sh alone.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=atlas-env.sh
source "$SCRIPT_DIR/atlas-env.sh"

exec xdg-open "$ATLAS_URL/#$1"
