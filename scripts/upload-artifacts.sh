#!/usr/bin/env bash
# upload-artifacts.sh — Upload screenshots and videos from agent session
# Collects from /tmp/agent-artifacts/ and /tmp/playwright-artifacts/
set -euo pipefail

ARTIFACTS_DIR="/tmp/agent-artifacts"
PLAYWRIGHT_DIR="/tmp/playwright-artifacts"
OUTPUT_JSON="/tmp/artifact-urls.json"

echo '{"artifacts": []}' > "$OUTPUT_JSON"

# Collect all artifact files
FILES=()
for dir in "$ARTIFACTS_DIR/screenshots" "$PLAYWRIGHT_DIR"; do
  if [ -d "$dir" ]; then
    while IFS= read -r -d '' file; do
      FILES+=("$file")
    done < <(find "$dir" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.webm" -o -name "*.mp4" \) -print0 2>/dev/null)
  fi
done

if [ ${#FILES[@]} -eq 0 ]; then
  echo "No artifacts to upload"
  exit 0
fi

echo "Found ${#FILES[@]} artifact(s)"

for file in "${FILES[@]}"; do
  FILENAME=$(basename "$file")
  EXT="${FILENAME##*.}"

  case "$EXT" in
    png|jpg|jpeg) TYPE="image" ;;
    webm|mp4) TYPE="video" ;;
    *) TYPE="file" ;;
  esac

  echo "  $TYPE: $FILENAME ($(du -h "$file" | cut -f1))"

  # Artifacts are uploaded via GitHub Actions upload-artifact step
  # This script just catalogs them for the response
  jq --arg fn "$FILENAME" --arg type "$TYPE" --arg path "$file" \
    '.artifacts += [{"filename": $fn, "type": $type, "path": $path}]' \
    "$OUTPUT_JSON" > "${OUTPUT_JSON}.tmp" && mv "${OUTPUT_JSON}.tmp" "$OUTPUT_JSON"
done

echo "Artifact manifest written to $OUTPUT_JSON"
